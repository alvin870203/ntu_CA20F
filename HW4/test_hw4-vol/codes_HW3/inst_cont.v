module inst_cont #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input               i_clk,
    input               i_rst_n,
    input  [INST_W-1:0] i_inst,
    output [INST_W-1:0] o_inst_cont
);

    reg [INST_W-1:0] o_inst_cont_r, o_inst_cont_w;

    assign o_inst_cont = o_inst_cont_r;

    always @(*) begin
        if (i_inst) begin
            o_inst_cont_w = i_inst;
        end else begin
            o_inst_cont_w = o_inst_cont_r;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_inst_cont_r <= 0;
        end else begin
            o_inst_cont_r <= o_inst_cont_w;
        end
    end

endmodule