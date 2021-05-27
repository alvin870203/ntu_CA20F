module adder #(
    parameter DATA_W = 63
)(
    input [DATA_W-1:0] aa,
    input [DATA_W-1:0] bb,
    output [DATA_W-1:0] c
);
        assign c = aa + bb;

endmodule