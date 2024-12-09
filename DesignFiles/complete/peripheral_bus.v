`timescale 1 ps / 100 fs

module peripheral_bus(clk, reset, device, data_in, data_out, command);
    input wire clk, reset;
    input wire [31:0] data_in; // 32 bits of data
    output wire [31:0] data_out; // 32 bits of data
    input wire [4:0] device;// 5 bits to state the device
    input wire [5:0] command;

    /////////////////
    // States for FSM
    /////////////////

    localparam [2:0] S_Reset = 3'b000,  // Reset or start state
                     S_DeviceSelect = 3'b001,  // Select the device
                     S_SendData = 3'b010,  // Send data to the device
                     S_RecieveData = 3'b011,  // Recieve data from the device
                     S_AwaitAck = 3'b100;  // Wait for ack from the CPU
    
    reg [2:0] state_reg, state_next;
    reg [1:0] cmdCycle_reg, cmdCycle_next;
    reg [4:0] deviceIndex_reg, deviceIndex_next;
    reg [2:0] devicePtr_reg, devicePtr_next;

    ///////////////////
    // Next State Logic
    ///////////////////

    always @ (posedge clk or posedge reset) begin : fsm
        if(reset) begin
            state_reg <= S_Reset;
            deviceIndex_reg <= 5'b00000;
            devicePtr_reg <= 3'b000;
        end else begin
            state_reg <= state_next;
            deviceIndex_reg <= deviceIndex_next;
        end
    end

    always @(*) begin : next_state
        state_next = state_reg;
        deviceIndex_next = deviceIndex_reg;

        case(state_reg)
            S_Reset : begin
                deviceIndex_next = 3'b000;
                state_next = S_DeviceSelect;
            end
            S_DeviceSelect : begin
                deviceIndex_next = device;
                if (command == 6'b000000) begin
                    state_next = S_RecieveData;
                end else begin
                    state_next = S_SendData;
                end
            end
            S_SendData : begin

                state_next = S_AwaitAck;
            end
        endcase
    end
            
endmodule
