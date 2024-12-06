`timescale 1ns / 1ps

module interupt_wrapper(clk, reset,)

module interupt_controller(clk, reset, intr_rq, intr_bus, intr_in, intr_out, bus_oe);
    input wire clk, reset;
    input wire [7:0] intr_rq;
    inout wire [7:0] intr_bus;
    input wire intr_in,
    output wire intr_out, bus_oe;

    /////////////////
    // States for FSM
    /////////////////

    localparam  [2:0]   S_Reset                 = 3'b000,  // Reset or start state
                        S_StartPolling          = 3'b001,  // Polling each interrupt source periodically
                        S_TxIntInfoPolling      = 3'b010,  // Assert intr_out if interrupt present and send source ID on intr_bus 
                        S_AckTxInfoRxPolling    = 3'b011,  // Wait for intr_in to go high
                        S_AckISRDonePolling     = 3'b100;  // De-assert intr_out signal


    reg [2:0] state_reg, state_next;
    reg [1:0] cmdCycle_reg, cmdCycle_next;
    reg [2:0] intrIndex_reg, intrIndex_next;
    reg [2:0] intrPtr_reg, intrPtr_next;
    reg oe_reg, oe_next;
    reg [7:0] intrBus_reg, intrBus_next;
    reg intrOut_reg, intrOut_next; 
    reg [7:0] flags; // Register to store flags for interrupt sources

    always @ (posedge clk or posedge reset) begin : fsm
        if(reset) begin
            state_reg <= S_Reset;
            oe_reg <= 1'b0;
            intrBus_reg <= 8'bzzzzzzzz;
            intrOut_reg <= 1'b0;
            intrIndex_reg <= 3'b000;
            intrPtr_reg <= 3'b000;
        end else begin
            state_reg <= state_next;
            oe_reg <= oe_next;
            intrBus_reg <= intrBus_next;
            intrOut_reg <= intrOut_next;
            intrIndex_reg <= intrIndex_next;
            intrPtr_reg <= intrPtr_next;
        end
    end

    // set flags upon interrupt
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            flags <= 8'b00000000; // clear flags when reset
        end else begin
            flags <= flags | intr_rq; // set flags to where interrupt has been requested
        end
    end

    ///////////////////
    // Next State Logic
    ///////////////////

    always @(*) begin : next_state
        state_next = state_reg;
        oe_next = oe_reg;
        intrOut_next = intrOut_reg;
        intrBus_next = intrBus_reg;
        intrIndex_next = intrIndex_reg;
        intrPtr_next = intrPtr_reg;

        case (state_reg)
            S_Reset: begin
                intrIndex_next = 3'b000;
                intrPtr_next = 3'b000;
                oe_next = 1'b0;
                state_next = S_StartPolling;
            end
    /*
    If the mode is polling then the controller enters this state.
    The priorities are fixed in this mode.
    It checks one source every clock cycle. If an interrupt input is active then
    the output is set high and then the controller waits for an acknowledgement from the processor.
    */

            S_StartPolling: begin
                if (|flags) begin           // If the current interrupt source is active.
                    intrIndex_next = intrIndex_reg; // preserve the current index
                    intrOut_next    =   1'b1;               // Set the interrupt output bit to 1.
                    state_next      =   S_TxIntInfoPolling; // Transmit the information about this interrupt.
                end
                else begin                                  // If the current interrupt source is not active.
                    intrOut_next    =   1'b0;               // Make sure interrupt output is zero, redundant.
                    intrIndex_next  =   (intrIndex_reg + 1) % 8;  // Check the next interrupt source. wrap around if needed.
                end

                oe_next         =   1'b0;                   // Controller is not driving the bus.
            end
    /*
    If the interrupt is active then we next send the information about it to the processor.
    This information is sent on the bidirectional bus. It is sent after the interrupt has been acknowledged.

    The processor receives the request, processes it and returns acknowledgement on intr_in. (High to Low).
    Upon receiving this acknowledgement, the controller sends the information about the interrupt on the bus.
    Processor then sends the acknowlegement back to the controller. This is checked in the S_AckTxInfoRxPolling state.
    */

            S_TxIntInfoPolling: begin
                if (~intr_in) begin                                 // intr_in is from the processor to the controller.
                    intrOut_next    =   1'b0;                       // If processor has acknowledged the interrupt, lower it.
                    intrBus_next    =   {5'b01011, intrIndex_reg};  // 01011 is the control code that the lower 3 bits are the interrupt ID.
                    flags[intrIndex_reg] <= 1'b0;                   // clear the flags register after interrupt is processed
                    oe_next         =   1'b1;                       // Controller will drive the bus with this data.
                    state_next      =   S_AckTxInfoRxPolling;       // Go to acknowledge state and wait for the acknowledge.
                end                                                 // Wait until processor acknowledges the interrupt. Keep output high till that time.
                else
                    state_next      =   S_TxIntInfoPolling;
            end
    /*
    In the previous state, the processor had acknowledged the interrupt and the controller had sent the interrupt ID
    to the processor. Upon receiving it, the processor again acknowledges it on the intr_in pin. (High to Low).
    Once the processor acknowledges the address, the controller stops driving the bus and tristates it.
    Then it waits for the processor to return when the interrupt is serviced.
    */

            S_AckTxInfoRxPolling: begin
                if (~intr_in) begin                                 // The processor has acknowledged the interrupt address.
                    oe_next         =   1'b0;                       // Controller no longer drives the bus.
                    state_next      =   S_AckISRDonePolling;        // Go do polling done state.
                end                                                 // Wait until processor acknowledges the address. Keep bus active till that time.
            end
    /*
    Once the processor has acknowledged the interrupt and the address of the interrupt,
    It will send the acknowledge on the bus once the interrupt has been serviced.
    Wait till that information is received and then go back to poll next source.
    */

            S_AckISRDonePolling: begin
                // If the proper source and condition has been acknowleged, check next interrupt.
                if ((~intr_in) && (intr_bus[7:3] == 5'b10100) && (intr_bus[2:0] == intrIndex_reg)) begin
                    state_next  =   S_StartPolling;
                end
                // If the acknowledgement did not have proper condition codes then that is an error and
                // controller goes back to reset.
                else if ((~intr_in) && (intr_bus[7:3] != 5'b10100) && (intr_bus[2:0] != intrIndex_reg)) begin
                    state_next  =   S_Reset;
                end
                else begin
                    state_next  =   S_AckISRDonePolling;            // Else wait in the current state.
                end
            end

            default: begin // Reset as default
                state_next      =   S_Reset;
                oe_next         =   1'b0;
            end

        endcase
    end

    // Interrupt output. It's the same as the intrOut_reg but done like this for clarity.
    assign intr_out =   intrOut_reg;
    // Bus is bidirectional. oe (output enable) decides if the controller is driving it
    // or is expecting input on it.
    assign intr_bus =   (oe_reg) ? intrBus_reg : 8'bzzzzzzzz;
    // Used by the testbench. This signal tells the processor if the bus is being actively
    // driven by the controller.
    assign bus_oe   =   oe_reg;

endmodule

