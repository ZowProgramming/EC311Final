`timescale 1 ps / 100 fs

module leds(clk, reset, device, data_in, leds, command);
    input wire clk, reset;
    input wire [4:0] device;
    input wire [31:0] data_in;
    //output wire [31:0] data_out;
    output reg [15:0] leds; //Physical LEDs
    input wire [5:0] command;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            leds <= 16'd0;
        end else if(device == 5'b00000 & command == 6'b000001) begin
            leds <= data_in[15:0];
        end
    end


endmodule