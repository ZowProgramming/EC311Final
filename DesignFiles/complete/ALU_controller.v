`timescale 1 ps / 100 fs

module ALU_controller( ALUControl, ALUOp, funct);
    output reg[2:0] ALUControl;
    input [1:0] ALUOp; // 2
    input [5:0] funct; // 6
    wire [7:0] ALUControlIn; // 8
    assign ALUControlIn = {ALUOp, funct};
    always @(ALUControlIn)
    casex (ALUControlIn)
        8'b11xxxxxx : ALUControl = 3'b000;// Addi,lw,sw
        8'b10xxxxxx : ALUControl = 3'b100;// slti
        8'b01xxxxxx : ALUControl = 3'b001;//BEQ
        8'b00100000 : ALUControl = 3'b000; //ADD
        8'b00100010 : ALUControl = 3'b001; //SUB
        8'b00100100 : ALUControl = 3'b010; //AND
        8'b00100101 : ALUControl = 3'b011; //OR
        8'b00101010 : ALUControl = 3'b100; //slt
        8'b00011000 : ALUControl = 3'b101; //MULT
        8'b00011010 : ALUControl = 3'b110; //DIV
        default : ALUControl = 3'b000;
    endcase
endmodule

module JR_controller( input[1:0] alu_op, 
       input [5:0] funct,
       output JRControl
    );
    assign JRControl = ({alu_op,funct}==8'b00001001) ? 1'b1 : 1'b0;
endmodule