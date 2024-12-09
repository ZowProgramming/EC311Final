`timescale 1 ps / 100 fs

module mips_processor(clk, reset, led);
    input clk, reset;
    output [15:0] led;
    //output [31:0] pc_out, alu_result;

    reg[31:0] pc_current;  
    wire signed[31:0] pc_next,pc2;  
    wire [31:0] instr;  
    wire[1:0] reg_dst,mem_to_reg,alu_op;  
    wire jump,branch,mem_read,mem_write,alu_src,reg_write;  
    wire [4:0] reg_write_dest; //$1 rd 
    wire [31:0] reg_write_data;  
    wire [4:0] reg_read_addr_1;  //$2 rt
    wire [31:0] reg_read_data_1;  
    wire [4:0] reg_read_addr_2;  //$3 ra 
    wire [31:0] reg_read_data_2;  
    wire [31:0] sign_ext_im,read_data2,zero_ext_im,imm_ext;  
    wire JRControl;  
    wire [2:0] ALU_Control;  
    wire [31:0] ALU_out; 
    wire [31:0] HI, LO; 
    wire zero_flag;  
    wire signed[31:0] im_shift_1, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr;  
    wire beq_control;  
    wire [30:0] jump_shift_1;  
    wire [31:0]mem_read_data;  
    wire [31:0] no_sign_ext;  
    wire sign_or_zero; 
    wire [31:0] perf_bus;

//////////////////
// Program Counter
//////////////////

    always @(posedge clk or posedge reset) begin
        if(reset)
            pc_current <= 32'd0;
        else
            pc_current <= pc_next;
    end

    // instruction memory
    instruction_mem instruction_memory(
                    .address(pc_current),
                    .instruction(instr) //Read current instruction
                    );

    assign pc2 = pc_current + 31'd2;

    assign sign_ext_im = {{16{instr[15]}},instr[15:0]};  
    assign zero_ext_im = {{16{1'b0}},instr[15:0]};  
    assign imm_ext = (sign_or_zero==1'b1) ? sign_ext_im : zero_ext_im;

    assign im_shift_1 = {imm_ext[30:0],1'b0};

    assign no_sign_ext = ~(im_shift_1) + 1'b1;
    // PC beq add
    assign PC_beq = (im_shift_1[31] == 1'b1) ? (pc2 - no_sign_ext): (pc2 +im_shift_1);  

    assign beq_control = branch & zero_flag;

    assign PC_4beq = (beq_control==1'b1) ? PC_beq : pc2;

    assign PC_j = {pc2[31],jump_shift_1};

    assign PC_4beqj = (jump == 1'b1) ? PC_j : PC_4beq;

    assign PC_jr = reg_read_data_1;

    assign pc_next = (JRControl==1'b1) ? PC_jr : PC_4beqj;

    
    // jump shift left 1
    assign jump_shift_1 = {instr[29:0],1'b0};
    // control unit
    controller control_unit(
                    .reset(reset),
                    .opcode(instr[31:26]), //First 6 Bits of instruction
                    .reg_dst(reg_dst),
                    .mem_to_reg(mem_to_reg),
                    .alu_op(alu_op),
                    .jump(jump),
                    .branch(branch),
                    .mem_read(mem_read),
                    .mem_write(mem_write),
                    .alu_src(alu_src),
                    .reg_write(reg_write),
                    .sign_or_zero(sign_or_zero)
                    );
    // multiplexer regdest  
    assign reg_write_dest = (reg_dst==2'b10) ? 5'b11111: ((reg_dst==2'b01) ? instr[15:11] : instr[20:16]); //Where to save: J-type - 31, R-type - rd, I-type - rt

    assign reg_read_addr_1 = instr[25:21];  
    assign reg_read_addr_2 = instr[20:16];

    // register file 
    regfile reg_file(
                    .clk(clk),
                    .reset(reset),
                    .RegWr(reg_write),  
                    .WrReg(reg_write_dest),  
                    .WrData(reg_write_data),  
                    .RdReg1(reg_read_addr_1),  
                    .RdData1(reg_read_data_1),  
                    .RdReg2(reg_read_addr_2),  
                    .RdData2(reg_read_data_2)
                    );
    // JR control 
    JR_controller JR_controller(
                    .alu_op(alu_op),
                    .funct(instr[5:0]), //Check for JR commands
                    .JRControl(JRControl)
                    );

    //ALU control
    ALU_controller alu_control(
                    .ALUControl(ALU_Control),
                    .ALUOp(alu_op),
                    .funct(instr[5:0]) //Last 6 bits have the math operation
                    );
    
    assign read_data2 = (alu_src==1'b1) ? imm_ext : reg_read_data_2; //What data to use in ALU: I-type - imm, rest - ra

    ALU alu( // TODO Fix
                    .clk(clk),
                    .A(reg_read_data_1),
                    .B(read_data2),
                    .ALUControl(ALU_Control),
                    .ALUOut(ALU_out),
                    .High(HI),
                    .Low(LO),
                    .Zero(zero_flag)
                    );

    data_mem datamem(
                    .clk(clk),
                    .mem_access_addr(ALU_out),  
                    .mem_write_data(reg_read_data_2),
                    .mem_write_en(mem_write),
                    .mem_read(mem_read),  
                    .mem_read_data(mem_read_data)
                    );

    /*interupt_controller interupt( //TODO allow for edit and checking
                    .clk(clk),
                    .reset(reset),

                    );*/

    leds led_output(
                    .clk(clk),
                    .reset(reset),
                    .device(instr[15:11]),
                    .data_in(reg_read_data_2),
                    .leds(led),
                    .command(instr[5:0])
                    );
    
    assign reg_write_data = (mem_to_reg == 2'b11) ? perf_bus:((mem_to_reg == 2'b10) ? pc2:((mem_to_reg == 2'b01)? mem_read_data: ALU_out));  //What data to write to register: jal - pc+4, lw - mem data, rest - ALU out

//assign pc_out = pc_current;  
    //assign alu_result = ALU_out;

endmodule
    