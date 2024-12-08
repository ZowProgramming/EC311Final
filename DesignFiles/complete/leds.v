`timescale 1ps/1ps

module leds(clk, reset, device, data_in, leds, command);
    input wire clk, reset;
    input wire [4:0] device;
    input wire [31:0] data_in;
    output wire [31:0] data_out;
    output [7:0] leds; //Physical LEDs
    input wire [5:0] command;

    reg [31:0] led_data; //current LED data

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            led_data <= 32'd0;
        end else if(devive == 5'b00000 & command == 6'b000001) begin
            led_data <= data_in;
        end
    end

    always @(*) begin
        leds = led_data[7:0];
    end

endmodule