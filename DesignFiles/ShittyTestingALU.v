`timescale 1ns / 1ps

/*
|ALU_Sel|   ALU Operation
----------------------------------------------------------------------
| 000  |   ALUOut = A + B;
| 001  |   ALUOut = A - B;
| 010  |   ALUOut = A and B;
| 011  |   ALUOut = A or B;
| 100  |   ALUOut = 1 if A<B else 0;
| 101  |   ALUOut = A * B;
| 110  |   ALUOut = A / B;
*/
module ALU(clk, A, B, ALUControl, ALUOut, carryOut);
    input clk;
    input [31:0] A, B; //32 Bit inputs
    input [2:0] ALUControl; //Control Signal
    output [31:0] ALUOut; //32 Bit Output
    output carryOut;
    
    reg [31:0] ALUResult;
    wire [32:0] tmp;
    
    assign ALUOut = ALUResult;
    assign tmp = {1'b0,A} + {1'b0,B};
    assign CarryOut = tmp[8];
    always @ (posedge clk) begin
        case(ALUControl)
            3'b000 : ALUResult = A + B;
            3'b001 : ALUResult = A - B;
            3'b010 : ALUResult = A & B;
            3'b011 : ALUResult = A | B;
            3'b100 : ALUResult = (A<B)?32'd1:32'd0;
            3'b101 : ALUResult = A * B; //TODO change this to store in special registers
            3'b110 : ALUResult = A / B;
        endcase
    end
endmodule
