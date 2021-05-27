module RegFile #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input               i_clk,
    input               i_rst_n,
    input               i_RegWrite,
    input  [4:0]        i_ReadReg1,
    input  [4:0]        i_ReadReg2,
    input  [4:0]        i_WriteReg,
    input  [DATA_W-1:0] i_WriteData,
    output [DATA_W-1:0] o_ReadData1,
    output [DATA_W-1:0] o_ReadData2
);

    reg [DATA_W-1:0] register   [0:31];
    reg [DATA_W-1:0] register_w [0:31];
    reg [DATA_W-1:0] o_ReadData1_w, o_ReadData2_w;

    integer i;

    assign o_ReadData1 = o_ReadData1_w;
    assign o_ReadData2 = o_ReadData2_w;

    always @(*) begin
        for (i=0; i<32; i++) begin
            register_w[i] = register[i];
        end
        if (i_RegWrite) begin
            register_w[i_WriteReg] = i_WriteData;
        end

        // if (i_RegWrite) begin
        //     register_w[i_WriteReg] = i_WriteData;
        // end else begin
        //     for (i=0; i<32; i++) begin
        //     register_w[i] = register[i];
        //     end
        // end
    end

    always @(*) begin
        o_ReadData1_w = register[i_ReadReg1];
        o_ReadData2_w = register[i_ReadReg2];
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            for (i=0; i<32; i++) begin
                register[i] <= 0;
            end
        end else begin
            register[0] <= 0;
            for (i=1; i<32; i++) begin
                register[i] <= register_w[i];
            end
        end
    end


endmodule