`timescale 1 ps / 100 fs

module data_mem(clk, mem_access_addr, mem_write_data, mem_write_en, mem_read, mem_read_data);
    input clk;
    input [31:0] mem_access_addr, mem_write_data;
    input mem_write_en, mem_read;
    output [31:0] mem_read_data;

    integer i;
    reg [31:0] ram [255:0];
    wire [15:0] ram_addr = mem_access_addr[16:1];
    initial begin  
        for(i=0;i<256;i=i+1)  
            ram[i] <= 32'd0;  
    end
    always @(posedge clk) begin  
        if (mem_write_en)  
            ram[ram_addr] <= mem_write_data;  
    end
    assign mem_read_data = (mem_read==1'b1) ? ram[ram_addr] : 32'd0;
endmodule