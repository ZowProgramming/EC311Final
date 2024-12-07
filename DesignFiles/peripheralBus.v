`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2024 01:43:35 PM
// Design Name: 
// Module Name: peripheralBus
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module peripheralBus(
    input clk,
    input wire reset,
    input wire [31:0] address,
    input wire [31:0] dataIn,
    output reg [31:0] dataOut,
    input wire read,
    input wire write,
    output reg busReady,
    output reg [3:0] portSelect // choose how many ports you want I used 4 as arbitrary #
    );

    initial begin
        portSelect <= 0;
        if(read || write) begin
            case(address[31:30])
                2'b00: portSelect[0] <= 1;
                2'b01: portSelect[1] <= 1;
                2'b10: portSelect[2] <= 1;
                2'b11: portSelect[3] <= 1;
            endcase
        end
    end
    
    reg [31:0] portData [0:3];
    reg index;
    
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            dataOut <= 0;
            busReady <= 0;
        end
        else begin
            if(write) begin
                for(index = 0; index < 4; index = index + 1) begin
                    if(portSelect[index]) begin
                        portData[index] <= dataIn;
                        busReady <= 1;
                    end
                end
                
            end
            else if(read) begin
                for(index = 0; index < 4; index = index + 1) begin
                    if(portSelect[index]) begin 
                        dataOut <= portData[index];
                        busReady <= 1;
                    end
                end
            end
         end
     
    end 
        
    

endmodule
