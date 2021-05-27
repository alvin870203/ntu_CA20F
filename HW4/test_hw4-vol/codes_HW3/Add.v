module Add #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input  [DATA_W-1:0] i_a,
    input  [DATA_W-1:0] i_b,
    output [DATA_W-1:0] o_sum
);

    assign o_sum = i_a + i_b;

endmodule