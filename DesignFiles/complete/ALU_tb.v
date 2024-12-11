`timescale 1 ps / 100 fs

module ALU_tb;
    reg clk;
    reg [31:0] A, B;
    reg [2:0] ALUControl;
    
    wire [31:0] ALUOut;
    wire [31:0] High, Low;
    wire Zero, CarryOut, Overflow, Negative, DivZero;
    
    ALU uut(
        .clk(clk),
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUOut(ALUOut),
        .High(High),
        .Low(Low),
        .Zero(Zero),
        .CarryOut(CarryOut),
        .Overflow(Overflow),
        .Negative(Negative),
        .DivZero(DivZero)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        A = 0;
        B = 0;
        ALUControl = 3'b000; // Initialize with addition
        
        // Apply test cases
        #10; // Wait for clock edge
        
        // Test Addition
        A = 32'h00000010; B = 32'h00000020; ALUControl = 3'b000; #10;
        
        // Test Subtraction
        A = 32'h00000030; B = 32'h00000010; ALUControl = 3'b001; #10;
        
        // Test AND
        A = 32'hFF00FF00; B = 32'h00FF00FF; ALUControl = 3'b010; #10;
        
        // Test OR
        A = 32'hFF00FF00; B = 32'h00FF00FF; ALUControl = 3'b011; #10;
        
        // Test Set Less Than
        A = 32'h00000010; B = 32'h00000020; ALUControl = 3'b100; #10;
        
        // Test Multiplication
        A = 32'h00000010; B = 32'h00000004; ALUControl = 3'b101; #10;
        
        // Test Division
        A = 32'h00000020; B = 32'h00000004; ALUControl = 3'b110; #10;
        
        // Test Division by Zero
        A = 32'h00000020; B = 32'h00000000; ALUControl = 3'b110; #10;
        
        //----------------------------------------------------------------
        // TEST EDGE CASES
        
        // Test Signed Addition Overflow
        A = 32'h7FFFFFFF; B = 32'h00000001; ALUControl = 3'b000; #10;
        
        // Test Signed Subtraction Overflow
        A = 32'h80000000; B = 32'hFFFFFFFF; ALUControl = 3'b001; #10;
        
        // Test Subtraction with Borrow
        A = 32'h00000010; B = 32'h00000020; ALUControl = 3'b001; #10;
        
        // Test AND with All Zeros
        A = 32'h00000000; B = 32'h00000000; ALUControl = 3'b010; #10;
        
        // Test OR with All Ones
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; ALUControl = 3'b011; #10;
        
        // Test Set Less Than with Equal Values
        A = 32'h00000020; B = 32'h00000020; ALUControl = 3'b100; #10;
        
        // Test Multiplication Overflow
        A = 32'h7FFFFFFF; B = 32'h00000002; ALUControl = 3'b101; #10;
        
        // Test Multiplication with Zero
        A = 32'h00000000; B = 32'h12345678; ALUControl = 3'b101; #10;
        
        // Test Division with Remainder
        A = 32'h00000015; B = 32'h00000002; ALUControl = 3'b110; #10;
        
        // Test Division Result of Zero
        A = 32'h00000000; B = 32'h00000002; ALUControl = 3'b110; #10;
        
        // Test Negative Subtraction Result
        A = 32'h00000010; B = 32'h00000020; ALUControl = 3'b001; #10;
        
        // Test Negative Set Less Than
        A = 32'h80000000; B = 32'h00000000; ALUControl = 3'b100; #10;
        
        // Test Addition Carry Out
        A = 32'hFFFFFFFF; B = 32'h00000001; ALUControl = 3'b000; #10;
        
        // Test Multiplication with Negative Values
        A = 32'hFFFFFFF0; B = 32'h00000002; ALUControl = 3'b101; #10;
        
        $finish;
    end
endmodule
