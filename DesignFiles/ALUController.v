`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 10:49:43 AM
// Design Name: 
// Module Name: ALUController
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


module ALUController( ALUControl, ALUOp, Function);
    output reg[2:0] ALUControl;
    input [1:0] ALUOp;
    input [3:0] Function;
    wire [5:0] ALUControlIn;
    assign ALUControlIn = {ALUOp, Function};
    always @(ALUControlIn)
    casex (ALUControlIn)
        6'b11xxxx : ALUControl = 3'b000;
        6'b10xxxx : ALUControl = 3'b100;
        6'b01xxxx : ALUControl = 3'b001;
        6'b000000 : ALUControl = 3'b000; //ADD
        6'b000001 : ALUControl = 3'b001; //SUB
        6'b000010 : ALUControl = 3'b010; //AND
        6'b000011 : ALUControl = 3'b011; //OR
        6'b000100 : ALUControl = 3'b100; //slt
        6'b000101 : ALUControl = 3'b101; //MULT
        6'b000110 : ALUControl = 3'b110; //DIV
        default : ALUControl = 3'b000;
    endcase
endmodule

module JRController( input[1:0] alu_op, 
       input [3:0] funct,
       output JRControl
    );
    assign JRControl = ({alu_op,funct}==6'b001000) ? 1'b1 : 1'b0;
endmodule
