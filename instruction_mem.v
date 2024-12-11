`timescale 1 ps / 100 fs

module instruction_mem(instruction, address);
    input [31:0] address;
    output [31:0] instruction;
    reg [31:0] instrmem[1023:0];
    reg [31:0] tmp;

    buf #1000 buf0(instruction[0],tmp[0]),
        buf1(instruction[1],tmp[1]),
        buf2(instruction[2],tmp[2]),
        buf3(instruction[3],tmp[3]),
        buf4(instruction[4],tmp[4]),
        buf5(instruction[5],tmp[5]),
        buf6(instruction[6],tmp[6]),
        buf7(instruction[7],tmp[7]),
        buf8(instruction[8],tmp[8]),
        buf9(instruction[9],tmp[9]),
        buf10(instruction[10],tmp[10]),
        buf11(instruction[11],tmp[11]),
        buf12(instruction[12],tmp[12]),
        buf13(instruction[13],tmp[13]),
        buf14(instruction[14],tmp[14]),
        buf15(instruction[15],tmp[15]),
        buf16(instruction[16],tmp[16]),
        buf17(instruction[17],tmp[17]),
        buf18(instruction[18],tmp[18]),
        buf19(instruction[19],tmp[19]),
        buf20(instruction[20],tmp[20]),
        buf21(instruction[21],tmp[21]),
        buf22(instruction[22],tmp[22]),
        buf23(instruction[23],tmp[23]),
        buf24(instruction[24],tmp[24]),
        buf25(instruction[25],tmp[25]),
        buf26(instruction[26],tmp[26]),
        buf27(instruction[27],tmp[27]),
        buf28(instruction[28],tmp[28]),
        buf29(instruction[29],tmp[29]),
        buf30(instruction[30],tmp[30]),
        buf31(instruction[31],tmp[31]);

    always @(address) begin
        tmp = instrmem[address/4];
    end

    initial begin
        $readmemb("instr.txt", instrmem);
    end

endmodule

module instrmemstimulous();

reg [31:0] addr;
wire [31:0] instr;

instruction_mem instructionmemory(instr, addr);

    initial begin
        $monitor("Mem Address=%h instruction=%b",addr,instr);
        addr=32'd0;
        #10000 addr=32'd4;
        #10000 addr=32'd8;
        #10000 addr=32'd12;
        #10000 addr=32'd16;
        #10000 addr=32'd20;
        #10000 addr=32'd24;
        #10000 addr=32'd28;
        #10000;
        $finish;
    end

endmodule