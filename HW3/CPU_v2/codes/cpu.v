module cpu #( // Do not modify interface
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input                   i_clk,
    input                   i_rst_n,
    input                   i_i_valid_inst, // from instruction memory
    input  [ INST_W-1 : 0 ] i_i_inst,       // from instruction memory
    input                   i_d_valid_data, // from data memory
    input  [ DATA_W-1 : 0 ] i_d_data,       // from data memory
    output                  o_i_valid_addr, // to instruction memory
    output [ ADDR_W-1 : 0 ] o_i_addr,       // to instruction memory
    output [ DATA_W-1 : 0 ] o_d_data,       // to data memory
    output [ ADDR_W-1 : 0 ] o_d_addr,       // to data memory
    output                  o_d_MemRead,    // to data memory
    output                  o_d_MemWrite,   // to data memory
    output                  o_finish
);

// homework

    wire [INST_W-1:0] i_i_inst_cont;
    wire [DATA_W-1:0] i_d_data_cont;

    wire       Branch, MemtoReg, ALUSrc, RegWrite, InstNext;
    wire [1:0] ALUOp;

    wire [DATA_W-1:0] WriteData, ReadData1, ReadData2;

    wire [DATA_W-1:0] Imm_SignExt;
    
    wire [DATA_W-1:0] ALU_in2; // output of bottom left Mux
    
    wire [3:0]        ALUinst;
    wire              Zero;
    wire [DATA_W-1:0] ALUresult;

    wire [ADDR_W-1:0] PC, PC_next, PC1, PC0;


    Control #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_Control (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_inst_6_0(i_i_inst_cont[6:0]),
        .i_valid_inst(i_i_valid_inst),
        .i_valid_ld(i_d_valid_data),
        .o_Branch(Branch),
        .o_MemRead(o_d_MemRead),
        .o_MemtoReg(MemtoReg),
        .o_ALUOp(ALUOp),
        .o_MemWrite(o_d_MemWrite),
        .o_ALUSrc(ALUSrc),
        .o_RegWrite(RegWrite),
        .o_InstNext(InstNext),
        .o_Finish(o_finish)
    );


    inst_cont #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_inst_cont (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_inst(i_i_inst),
        .o_inst_cont(i_i_inst_cont)
    );


    RegFile #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_RegFile (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_RegWrite(RegWrite),
        .i_ReadReg1(i_i_inst_cont[19:15]),
        .i_ReadReg2(i_i_inst_cont[24:20]),
        .i_WriteReg(i_i_inst_cont[11:7]),
        .i_WriteData(WriteData),
        .o_ReadData1(ReadData1),
        .o_ReadData2(ReadData2)
    );

    assign o_d_data = ReadData2;


    ImmGen #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_ImmGen (
        .i_inst_31_0(i_i_inst_cont[31:0]),
        .o_Imm_SignExt(Imm_SignExt)
    );


    Mux #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_Mux_bl (
        .i_sel(ALUSrc),
        .i_in0(ReadData2),
        .i_in1(Imm_SignExt),
        .o_out(ALU_in2)
    );


    ALUcontrol #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_ALUcontrol (
        .i_inst_30_14_12({i_i_inst_cont[30], i_i_inst_cont[14:12]}),
        .i_ALUOp(ALUOp),
        .o_ALUinst(ALUinst)
    );


    ALU #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_ALU (
        .i_ALUinst(ALUinst),
        .i_ALU_in1(ReadData1),
        .i_ALU_in2(ALU_in2),
        .o_Zero(Zero),
        .o_ALUresult(ALUresult)
    );

    assign o_d_addr = ALUresult;


    Mux #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_Mux_br (
        .i_sel(MemtoReg),
        .i_in0(ALUresult),
        .i_in1(i_d_data_cont),
        .o_out(WriteData)
    );


    data_mem_cont #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_data_mem_cont (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_data_mem(i_d_data),
        .i_valid_mem(i_d_valid_data),
        .o_data_mem(i_d_data_cont)
    );


    Add #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_Add_r (
        .i_a(PC),
        .i_b({Imm_SignExt[DATA_W-2:0], 1'b0}), // shift left 1
        .o_sum(PC1)
    );


    Add #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_Add_l (
        .i_a(PC),
        .i_b(64'd4),
        .o_sum(PC0)
    );


    Mux #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_Mux_ur (
        .i_sel(Branch & Zero), // AND gate
        .i_in0(PC0),
        .i_in1(PC1),
        .o_out(PC_next)
    );


    ProgCount #(
        .INST_W(INST_W),
        .DATA_W(DATA_W),
        .ADDR_W(ADDR_W)
    ) u_ProgCount (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_PC_next(PC_next),
        .i_InstNext(InstNext),
        .o_PC(PC),
        .o_i_valid_addr(o_i_valid_addr)
    );

    assign o_i_addr = PC;

endmodule
