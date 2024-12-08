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

/*
NOTES ON FUNCTIONALITY

MODE-SPECIFIC FUNCTIONALITY NOTES
| Mode      | Notes
---------------------------------------------------------------------------
| + (000)   | Addition with carry out; Overflow detection for signed addition.
| - (001)   | Subtraction using 2's complement addition. CarryOut represents borrow.
             Overflow detection handles signed subtraction.
| & (010)   | Bitwise AND operation, no overflow or carry.
| | (011)   | Bitwise OR operation, no overflow or carry.
| < (100)   | Set less than; ALUOut is 1 if A < B, otherwise 0.
| * (101)   | The upper 32 bits of any multiplication result go to High, 
             the lower 32 bits go to Low. Overflow if High is used. 
| / (110)   | Division; DivZero flag set if B is zero. High receives the number of times divided, 
             Low receives the remainder (modulus)

*/

module ALU(clk, A, B, ALUControl, ALUOut, High, Low, Zero, CarryOut, Overflow, Negative, DivZero);
    input clk;
    input [31:0] A, B; //32 Bit inputs
    input [2:0] ALUControl; //Control Signal
    output [31:0] ALUOut; //32 Bit Output
    output reg [31:0] High;
    output reg [31:0] Low;
    output reg Zero, CarryOut, Overflow, Negative, DivZero; // Output flags
    
    reg [31:0] ALUResult;
    assign ALUOut = ALUResult;
    
    // Carryout Infrastructure for Addition & Subtraction
    wire [32:0] tmp;
    assign tmp = (ALUControl == 3'b001) ? {1'b0,A} + {1'b0, ~B + 1} : {1'b0,A} + {1'b0,B};
    
    // Multiplication Infrastructure
    reg [63:0] mult_result;
    
    always @ (posedge clk) begin
        case(ALUControl)
            3'b000 : begin
                ALUResult = A + B;
                CarryOut = tmp[32]; // assign CarryOut output as MSB of tmp
                Overflow = (A[31] == B[31]) && (ALUResult[31] != A[31]); 
                /* overflow: the sign bits of the numbers are the same, 
                but the sign bit of the result is not */
            end
            3'b001 : begin 
                ALUResult = tmp[31:0];
                CarryOut = ~tmp[32]; // represents borrow
                Overflow = (A[31] != B[31]) && (ALUResult[31] != A[31]);
                /* overflow: the numbers have different signs, but the result sign does 
                not match that of A's indicating overflow */
            end
            3'b010 : ALUResult = A & B;
            3'b011 : ALUResult = A | B;
            3'b100 : ALUResult = (A<B) ? 32'd1 : 32'd0;
            3'b101 : begin
                mult_result = A * B;
                Low = mult_result[31:0];
                High = mult_result[63:32];
                Overflow = (High != {32{Low[31]}}); /* Overflow is 
                being checked by comparing the upper 32 bits (High) against the 
                sign extension of the lower 32 bits (Low[31]). If these do 
                not match, it indicates the product cannot be represented within 
                32 bits, signaling an overflow.*/
            end
            3'b110 : begin
                if (B == 0) begin
                    DivZero = 1;
                    High = 0;
                    Low = 0;
                end else begin
                    High = A / B;
                    Low = A % B;
                    DivZero = 0;
                end
            end
        endcase
        Zero = (ALUResult == 0);
    end
endmodule