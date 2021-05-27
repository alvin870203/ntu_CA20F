module data_mem_cont #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input               i_clk,
    input               i_rst_n,
    input  [DATA_W-1:0] i_data_mem,
    input               i_valid_mem,
    output [DATA_W-1:0] o_data_mem
);

    reg [DATA_W-1:0] o_data_mem_r, o_data_mem_w;

    assign o_data_mem = o_data_mem_r;

    always @(*) begin
        if (i_valid_mem) begin
            o_data_mem_w = i_data_mem;
        end else begin
            o_data_mem_w = o_data_mem_r;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_data_mem_r <= 0;
        end else begin
            o_data_mem_r <= o_data_mem_w;
        end
    end

endmodule