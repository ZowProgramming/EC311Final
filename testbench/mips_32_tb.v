`timescale 1 ps / 100 fs

module mips_32_tb;  
      // Inputs  
      reg clk;  
      reg reset;
      //reg s, b;  
      // Outputs  
      wire [31:0] pc_out;  
      wire [31:0] alu_result;//,reg3,reg4;
      wire [15:0] leds;  
      parameter ClockDelay = 5000;
      // Instantiate the Unit Under Test (UUT)  
      uut_mips_processor uut (  
           .clk(clk),   
           .reset(reset),   
           .pc_out(pc_out),  
           .led(leds),
           //.clk_toggle(s),
           //.clk_button(b)
           .alu_result(alu_result)  
           //.reg3(reg3),  
          // .reg4(reg4)  
      );  
      initial clk = 0;
    always #(ClockDelay/4) clk = ~clk;
    //always #(ClockDelay*40) b = ~b;

    initial 
    begin
       reset = 1;
       //s = 1;
       //b = 0;
      #(ClockDelay/4);
      reset = 0;
    end
endmodule