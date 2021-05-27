module ProgCount #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input               i_clk,
    input               i_rst_n,
    input [ADDR_W-1:0]  i_PC_next,  //(PC_next),
    input               i_InstNext, //(InstNext),
    input               i_Branch_valid,/////////////////////////////////////////////////////
    output [ADDR_W-1:0] o_PC        //(PC)
    //.o_i_valid_addr(o_i_valid_addr)
);

    reg [ADDR_W-1:0] o_PC_r, o_PC_w; //(PC)

    assign o_PC = o_PC_r;

    always @(*) begin
        if (i_InstNext) begin
            o_PC_w = i_Branch_valid ? i_PC_next+4 : i_PC_next;//i_PC_next;////////////////////////////
        end else begin
            o_PC_w = o_PC_r;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_PC_r <= 0;
        end else begin
            o_PC_r <= o_PC_w;
        end
    end


endmodule