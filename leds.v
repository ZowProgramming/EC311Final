`timescale 1 ps / 100 fs

module leds(clk, reset, device, data_in, leds, command, perf_en);
    input wire clk, reset, perf_en;
    input wire [4:0] device;
    input wire [31:0] data_in;
    //output wire [31:0] data_out;
    output reg [7:0] leds; //Physical LEDs
    input wire [5:0] command;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            leds <= 8'd0;
        end else if(device == 5'b00000 & command == 6'b000001 & perf_en == 1'b1) begin
            leds <= data_in[7:0];
        end
    end


endmodule