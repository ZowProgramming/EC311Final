`timescale 1 ps / 100 fs

module regfile(RdData1, RdData2, WrData, RdReg1, RdReg2, WrReg, RegWr, reset, clk);
    input [4:0] RdReg1, RdReg2, WrReg;
    input [31:0] WrData;
    input RegWr, reset, clk;
    output [31:0] RdData1, RdData2;
    wire [31:0] WrEn;
    wire [31:0] RegArray [0:31];

    decoder Decoder1(WrEn, RegWr, WrReg);
    register reg0 (RegArray[0],32'b0,1'b1,1'b0, clk);
    register reg1 (RegArray[1],WrData,WrEn[1],reset,clk);
    register reg2 (RegArray[2],WrData,WrEn[2],reset,clk);
    register reg3 (RegArray[3],WrData,WrEn[3],reset,clk);
    register reg4 (RegArray[4],WrData,WrEn[4],reset,clk);
    register reg5 (RegArray[5],WrData,WrEn[5],reset,clk);
    register reg6 (RegArray[6],WrData,WrEn[6],reset,clk);
    register reg7 (RegArray[7],WrData,WrEn[7],reset,clk);
    register reg8 (RegArray[8],WrData,WrEn[8],reset,clk);
    register reg9 (RegArray[9],WrData,WrEn[9],reset,clk);
    register reg10 (RegArray[10],WrData,WrEn[10],reset,clk);
    register reg11 (RegArray[11],WrData,WrEn[11],reset,clk);
    register reg12 (RegArray[12],WrData,WrEn[12],reset,clk);
    register reg13 (RegArray[13],WrData,WrEn[13],reset,clk);
    register reg14 (RegArray[14],WrData,WrEn[14],reset,clk);
    register reg15 (RegArray[15],WrData,WrEn[15],reset,clk);
    register reg16 (RegArray[16],WrData,WrEn[16],reset,clk);
    register reg17 (RegArray[17],WrData,WrEn[17],reset,clk);
    register reg18 (RegArray[18],WrData,WrEn[18],reset,clk);
    register reg19 (RegArray[19],WrData,WrEn[19],reset,clk);
    register reg20 (RegArray[20],WrData,WrEn[20],reset,clk);
    register reg21 (RegArray[21],WrData,WrEn[21],reset,clk);
    register reg22 (RegArray[22],WrData,WrEn[22],reset,clk);
    register reg23 (RegArray[23],WrData,WrEn[23],reset,clk);
    register reg24 (RegArray[24],WrData,WrEn[24],reset,clk);
    register reg25 (RegArray[25],WrData,WrEn[25],reset,clk);
    register reg26 (RegArray[26],WrData,WrEn[26],reset,clk);
    register reg27 (RegArray[27],WrData,WrEn[27],reset,clk);
    register reg28 (RegArray[28],WrData,WrEn[28],reset,clk);
    register reg29 (RegArray[29],WrData,WrEn[29],reset,clk);
    register reg30 (RegArray[30],WrData,WrEn[30],reset,clk);
    register reg31 (RegArray[31],WrData,WrEn[31],reset,clk);


    mux32x32to32 Mux1(RdData1,RegArray[0], RegArray[1],RegArray[2], RegArray[3],RegArray[4],RegArray[5],RegArray[6],RegArray[7],
        RegArray[8],RegArray[9],RegArray[10],RegArray[11],RegArray[12],RegArray[13],RegArray[14],RegArray[15],RegArray[16],RegArray[17],
        RegArray[18], RegArray[19],RegArray[20],RegArray[21],RegArray[22],RegArray[23],RegArray[24],RegArray[25],RegArray[26],
        RegArray[27], RegArray[28], RegArray[29],RegArray[30],RegArray[31], RdReg1
    ); 
    mux32x32to32 Mux2(RdData2,RegArray[0], RegArray[1],RegArray[2], RegArray[3],RegArray[4],RegArray[5],RegArray[6],RegArray[7],
        RegArray[8],RegArray[9],RegArray[10],RegArray[11],RegArray[12],RegArray[13],RegArray[14],RegArray[15],RegArray[16],RegArray[17],
        RegArray[18], RegArray[19],RegArray[20],RegArray[21],RegArray[22],RegArray[23],RegArray[24],RegArray[25],RegArray[26],
        RegArray[27], RegArray[28], RegArray[29],RegArray[30],RegArray[31], RdReg2
    );

endmodule

//DFF
module D_FF (q, d, reset, clk);
    output q;
    input d, reset, clk;
    reg q;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q = 0;
        end else begin  
            q = d;
        end
    end

endmodule

// 1 bit register 
module RegBit(BitOut, BitData, WrEn,reset, clk);
    output BitOut; // 1 bit of register
    input BitData, WrEn; 
    input reset,clk;
    wire d,f1, f2; // input of D Flip-Flop
    wire reset;
    //assign reset=0;
    and #(50) U1(f1, BitOut, (~WrEn));
    and #(50) U2(f2, BitData, WrEn);
    or  #(50) U3(d, f1, f2);
    D_FF DFF0(BitOut, d, reset, clk);
endmodule

//32 bit register 
module register(RegOut, RegIn, WrEn, reset, clk); 
    output [31:0] RegOut;
    input [31:0] RegIn;
    input WrEn, reset, clk;

    RegBit bit31(RegOut[31], RegIn[31], WrEn,reset,clk);
    RegBit bit30(RegOut[30], RegIn[30], WrEn,reset,clk);
    RegBit bit29(RegOut[29], RegIn[29], WrEn,reset,clk); 
    RegBit bit28(RegOut[28], RegIn[28], WrEn,reset,clk); 
    RegBit bit27(RegOut[27], RegIn[27], WrEn,reset,clk); 
    RegBit bit26(RegOut[26], RegIn[26], WrEn,reset,clk); 
    RegBit bit25(RegOut[25], RegIn[25], WrEn,reset,clk); 
    RegBit bit24(RegOut[24], RegIn[24], WrEn,reset,clk); 
    RegBit bit23(RegOut[23], RegIn[23], WrEn,reset,clk); 
    RegBit bit22(RegOut[22], RegIn[22], WrEn,reset,clk); 
    RegBit bit21(RegOut[21], RegIn[21], WrEn,reset,clk); 
    RegBit bit20(RegOut[20], RegIn[20], WrEn,reset,clk); 
    RegBit bit19(RegOut[19], RegIn[19], WrEn,reset,clk); 
    RegBit bit18(RegOut[18], RegIn[18], WrEn,reset,clk); 
    RegBit bit17(RegOut[17], RegIn[17], WrEn,reset,clk); 
    RegBit bit16(RegOut[16], RegIn[16], WrEn,reset,clk); 
    RegBit bit15(RegOut[15], RegIn[15], WrEn,reset,clk); 
    RegBit bit14(RegOut[14], RegIn[14], WrEn,reset,clk); 
    RegBit bit13(RegOut[13], RegIn[13], WrEn,reset,clk); 
    RegBit bit12(RegOut[12], RegIn[12], WrEn,reset,clk); 
    RegBit bit11(RegOut[11], RegIn[11], WrEn,reset,clk); 
    RegBit bit10(RegOut[10], RegIn[10], WrEn,reset,clk); 
    RegBit bit9(RegOut[9], RegIn[9], WrEn,reset,clk); 
    RegBit bit8(RegOut[8], RegIn[8], WrEn,reset,clk); 
    RegBit bit7(RegOut[7], RegIn[7], WrEn,reset,clk); 
    RegBit bit6(RegOut[6], RegIn[6], WrEn,reset,clk); 
    RegBit bit5(RegOut[5], RegIn[5], WrEn,reset,clk); 
    RegBit bit4(RegOut[4], RegIn[4], WrEn,reset,clk); 
    RegBit bit3(RegOut[3], RegIn[3], WrEn,reset,clk); 
    RegBit bit2(RegOut[2], RegIn[2], WrEn,reset,clk); 
    RegBit bit1(RegOut[1], RegIn[1], WrEn,reset,clk); 
    RegBit bit0(RegOut[0], RegIn[0], WrEn,reset,clk); 

endmodule

module decoder(WrEn, RegWr, WrReg);
    input RegWr;
    input [4:0] WrReg;
    output [31:0] WrEn;
    wire [31:0] OE; // Output Enable
    dec5to32 dec(OE,WrReg);
    assign WrEn[0]=0;
    and  #(50) gate1(WrEn[1],OE[1],RegWr);
    and  #(50) gate2(WrEn[2],OE[2],RegWr);
    and  #(50) gate3(WrEn[3],OE[3],RegWr);
    and  #(50) gate4(WrEn[4],OE[4],RegWr);
    and  #(50) gate5(WrEn[5],OE[5],RegWr);
    and  #(50) gate6(WrEn[6],OE[6],RegWr);
    and  #(50) gate7(WrEn[7],OE[7],RegWr);
    and  #(50) gate8(WrEn[8],OE[8],RegWr);
    and  #(50) gate9(WrEn[9],OE[9],RegWr);
    and  #(50) gate10(WrEn[10],OE[10],RegWr);
    and  #(50) gate11(WrEn[11],OE[11],RegWr);
    and  #(50) gate12(WrEn[12],OE[12],RegWr);
    and  #(50) gate13(WrEn[13],OE[13],RegWr);
    and  #(50) gate14(WrEn[14],OE[14],RegWr);
    and  #(50) gate15(WrEn[15],OE[15],RegWr);
    and  #(50) gate16(WrEn[16],OE[16],RegWr);
    and  #(50) gate17(WrEn[17],OE[17],RegWr);
    and  #(50) gate18(WrEn[18],OE[18],RegWr);
    and  #(50) gate19(WrEn[19],OE[19],RegWr);
    and  #(50) gate20(WrEn[20],OE[20],RegWr);
    and  #(50) gate21(WrEn[21],OE[21],RegWr);
    and  #(50) gate22(WrEn[22],OE[22],RegWr);
    and  #(50) gate23(WrEn[23],OE[23],RegWr);
    and  #(50) gate24(WrEn[24],OE[24],RegWr);
    and  #(50) gate25(WrEn[25],OE[25],RegWr);
    and  #(50) gate26(WrEn[26],OE[26],RegWr);
    and  #(50) gate27(WrEn[27],OE[27],RegWr);
    and  #(50) gate28(WrEn[28],OE[28],RegWr);
    and  #(50) gate29(WrEn[29],OE[29],RegWr);
    and  #(50) gate30(WrEn[30],OE[30],RegWr);
    and  #(50) gate31(WrEn[31],OE[31],RegWr);

endmodule

module andmore(g,a,b,c,d,e);
  output g;
  input a,b,c,d,e;
  and #(50) and1(f1,a,b,c,d),
            and2(g,f1,e);
endmodule

module dec5to32(Out,Adr);
    input [4:0] Adr; // Adr=Address of register
    output [31:0] Out;
    not #(50) Inv4(Nota, Adr[4]);
    not #(50) Inv3(Notb, Adr[3]);
    not #(50) Inv2(Notc, Adr[2]);
    not #(50) Inv1(Notd, Adr[1]);
    not #(50) Inv0(Note, Adr[0]);

    andmore a0(Out[0],  Nota,Notb,Notc,Notd,Note); // 00000
    andmore a1(Out[1],  Nota,Notb,Notc,Notd,Adr[0]); // 00001
    andmore a2(Out[2],  Nota,Notb,Notc,Adr[1],Note); //00010
    andmore a3(Out[3],  Nota,Notb,Notc,Adr[1],Adr[0]);
    andmore a4(Out[4],  Nota,Notb,Adr[2],Notd,Note);
    andmore a5(Out[5],  Nota,Notb,Adr[2],Notd,Adr[0]);
    andmore a6(Out[6],  Nota,Notb,Adr[2],Adr[1],Note);
    andmore a7(Out[7],  Nota,Notb,Adr[2],Adr[1],Adr[0]);
    andmore a8(Out[8],  Nota,Adr[3],Notc,Notd,Note);
    andmore a9(Out[9],  Nota,Adr[3],Notc,Notd,Adr[0]);
    andmore a10(Out[10],  Nota,Adr[3],Notc,Adr[1],Note);
    andmore a11(Out[11],  Nota,Adr[3],Notc,Adr[1],Adr[0]);
    andmore a12(Out[12],  Nota,Adr[3],Adr[2],Notd,Note);
    andmore a13(Out[13],  Nota,Adr[3],Adr[2],Notd,Adr[0]);
    andmore a14(Out[14],  Nota,Adr[3],Adr[2],Adr[1],Note);
    andmore a15(Out[15],  Nota,Adr[3],Adr[2],Adr[1],Adr[0]);
    andmore a16(Out[16],  Adr[4],Notb,Notc,Notd,Note);
    andmore a17(Out[17],  Adr[4],Notb,Notc,Notd,Adr[0]);
    andmore a18(Out[18],  Adr[4],Notb,Notc,Adr[1],Note);
    andmore a19(Out[19],  Adr[4],Notb,Notc,Adr[1],Adr[0]);
    andmore a20(Out[20],  Adr[4],Notb,Adr[2],Notd,Note);
    andmore a21(Out[21],  Adr[4],Notb,Adr[2],Notd,Adr[0]);
    andmore a22(Out[22],  Adr[4],Notb,Adr[2],Adr[1],Note);
    andmore a23(Out[23],  Adr[4],Notb,Adr[2],Adr[1],Adr[0]);
    andmore a24(Out[24],  Adr[4],Adr[3],Notc,Notd,Note);
    andmore a25(Out[25],  Adr[4],Adr[3],Notc,Notd,Adr[0]);
    andmore a26(Out[26],  Adr[4],Adr[3],Notc,Adr[1],Note);
    andmore a27(Out[27],  Adr[4],Adr[3],Notc,Adr[1],Adr[0]);
    andmore a28(Out[28],  Adr[4],Adr[3],Adr[2],Notd,Note);
    andmore a29(Out[29],  Adr[4],Adr[3],Adr[2],Notd,Adr[0]);
    andmore a30(Out[30],  Adr[4],Adr[3],Adr[2],Adr[1],Note);
    andmore a31(Out[31],  Adr[4],Adr[3],Adr[2],Adr[1],Adr[0]); // 11111

endmodule

module mux32to1(Out, In , Sel);
    output Out;
    input [31:0] In; 
    input [4:0] Sel; 
    wire [31:0] OE,f; // OE = Output Enable
    dec5to32 dec1(OE,Sel);

    and  #(50) g_0(f[0],OE[0],In[0]);
    and  #(50) g_1(f[1],OE[1],In[1]);
    and  #(50) g_2(f[2],OE[2],In[2]);
    and  #(50) g_3(f[3],OE[3],In[3]);
    and  #(50) g_4(f[4],OE[4],In[4]);
    and  #(50) g_5(f[5],OE[5],In[5]);
    and  #(50) g_6(f[6],OE[6],In[6]);
    and  #(50) g_7(f[7],OE[7],In[7]);
    and  #(50) g_8(f[8],OE[8],In[8]);
    and  #(50) g_9(f[9],OE[9],In[9]);
    and  #(50) g_10(f[10],OE[10],In[10]);
    and  #(50) g_11(f[11],OE[11],In[11]);
    and  #(50) g_12(f[12],OE[12],In[12]);
    and  #(50) g_13(f[13],OE[13],In[13]);
    and  #(50) g_14(f[14],OE[14],In[14]);
    and  #(50) g_15(f[15],OE[15],In[15]);
    and  #(50) g_16(f[16],OE[16],In[16]);
    and  #(50) g_17(f[17],OE[17],In[17]);
    and  #(50) g_18(f[18],OE[18],In[18]);
    and  #(50) g_19(f[19],OE[19],In[19]);
    and  #(50) g_20(f[20],OE[20],In[20]);
    and  #(50) g_21(f[21],OE[21],In[21]);
    and  #(50) g_22(f[22],OE[22],In[22]);
    and  #(50) g_23(f[23],OE[23],In[23]);
    and  #(50) g_24(f[24],OE[24],In[24]);
    and  #(50) g_25(f[25],OE[25],In[25]);
    and  #(50) g_26(f[26],OE[26],In[26]);
    and  #(50) g_27(f[27],OE[27],In[27]);
    and  #(50) g_28(f[28],OE[28],In[28]);
    and  #(50) g_29(f[29],OE[29],In[29]);
    and  #(50) g_30(f[30],OE[30],In[30]);
    and  #(50) g_31(f[31],OE[31],In[31]);

    

    or #(50) gate3(g3,f[0],f[1],f[2],f[3]);
    or #(50) gate4(g4,f[4],f[5],f[6],f[7]);
    or #(50) gate5(g5,f[8],f[9],f[10],f[11]);
    or #(50) gate6(g6,f[12],f[13],f[14],f[15]);
    or #(50) gate7(g7,f[16],f[17],f[18],f[19]);
    or #(50) gate8(g8,f[20],f[21],f[22],f[23]);
    or #(50) gate9(g9,f[24],f[25],f[26],f[27]);
    or #(50) gate10(g10,f[28],f[29],f[30],f[31]);
    or #(50) gate11(g11,g3,g4,g5,g6);
    or #(50) gate12(g12,g7,g8,g9,10);
    or #(50) gate(Out,g11,g12);

 endmodule

 module mux32x32to32(RdData,In0,In1,In2,In3,In4,In5,In6,In7,In8,In9,In10,In11,In12,In13,In14,In15,In16,In17,In18,In19,In20,In21,In22,In23,In24,In25,In26,In27,In28,In29,In30,In31,RdReg);
    input [31:0] In0, In1,In2,In3,In4,In5,In6,In7,In8,In9,In10,In11,In12,In13,In14,In15,In16,In17,In18,In19,In20,In21,In22,In23,In24,In25,In26,In27,In28,In29,In30,In31;
    input [4:0] RdReg;
    output [31:0] RdData;
    reg [31:0] ArrayReg [0:31];
    integer j;
    always @(*)
    begin
    for (j=0;j<=31;j=j+1)
            ArrayReg[j] = {In31[j], In30[j],In29[j],In28[j],In27[j],In26[j],In25[j],In24[j],In23[j],In22[j],In21[j],
        In20[j],In19[j],In18[j],In17[j],In16[j],In15[j],In14[j],In13[j],In12[j],In11[j],
        In10[j],In9[j],In8[j],In7[j],In6[j],In5[j],In4[j],In3[j],In2[j],In1[j],In0[j]};
    
    end
    mux32to1  mux0(RdData[0],ArrayReg[0],RdReg);
    mux32to1  mux1(RdData[1],ArrayReg[1],RdReg);
    mux32to1  mux2(RdData[2],ArrayReg[2],RdReg);
    mux32to1  mux3(RdData[3],ArrayReg[3],RdReg);
    mux32to1  mux4(RdData[4],ArrayReg[4],RdReg);
    mux32to1  mux5(RdData[5],ArrayReg[5],RdReg);
    mux32to1  mux6(RdData[6],ArrayReg[6],RdReg);
    mux32to1  mux7(RdData[7],ArrayReg[7],RdReg);
    mux32to1  mux8(RdData[8],ArrayReg[8],RdReg);
    mux32to1  mux9(RdData[9],ArrayReg[9],RdReg);
    mux32to1  mux10(RdData[10],ArrayReg[10],RdReg);
    mux32to1  mux11(RdData[11],ArrayReg[11],RdReg); 
    mux32to1  mux12(RdData[12],ArrayReg[12],RdReg);
    mux32to1  mux13(RdData[13],ArrayReg[13],RdReg);
    mux32to1  mux14(RdData[14],ArrayReg[14],RdReg);
    mux32to1  mux15(RdData[15],ArrayReg[15],RdReg); 
    mux32to1  mux16(RdData[16],ArrayReg[16],RdReg);
    mux32to1  mux17(RdData[17],ArrayReg[17],RdReg);
    mux32to1  mux18(RdData[18],ArrayReg[18],RdReg);
    mux32to1  mux19(RdData[19],ArrayReg[19],RdReg);
    mux32to1  mux20(RdData[20],ArrayReg[20],RdReg);
    mux32to1  mux21(RdData[21],ArrayReg[21],RdReg);
    mux32to1  mux22(RdData[22],ArrayReg[22],RdReg);
    mux32to1  mux23(RdData[23],ArrayReg[23],RdReg);
    mux32to1  mux24(RdData[24],ArrayReg[24],RdReg);
    mux32to1  mux25(RdData[25],ArrayReg[25],RdReg);
    mux32to1  mux26(RdData[26],ArrayReg[26],RdReg);
    mux32to1  mux27(RdData[27],ArrayReg[27],RdReg);
    mux32to1  mux28(RdData[28],ArrayReg[28],RdReg);
    mux32to1  mux29(RdData[29],ArrayReg[29],RdReg);
    mux32to1  mux30(RdData[30],ArrayReg[30],RdReg);
    mux32to1  mux31(RdData[31],ArrayReg[31],RdReg);

endmodule