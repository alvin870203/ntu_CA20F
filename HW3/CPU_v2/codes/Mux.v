module Mux #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input i_sel,
    input [DATA_W-1:0] i_in0,
    input [DATA_W-1:0] i_in1,
    output [DATA_W-1:0] o_out
);

reg [DATA_W-1:0] o_out_w;

assign o_out = o_out_w;

always @(*) begin
    if (i_sel) begin // sel 1
        o_out_w = i_in1;
    end else begin   // sel 0
        o_out_w = i_in0;
    end
end

endmodule