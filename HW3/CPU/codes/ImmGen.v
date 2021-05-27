module ImmGen #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input  [INST_W-1:0] i_inst_31_0,
    output [ADDR_W-1:0] o_Imm_SignExt
);

    reg [ADDR_W-1:0] o_Imm_SignExt_w;

    assign o_Imm_SignExt = o_Imm_SignExt_w;

    always @(*) begin
        case (i_inst_31_0[6:0])
            7'b0000011: begin // ld
                o_Imm_SignExt_w = { {52{i_inst_31_0[31]}}, i_inst_31_0[31:20] };
            end 
            7'b0100011: begin // sd
                o_Imm_SignExt_w = { {52{i_inst_31_0[31]}}, i_inst_31_0[31:25], i_inst_31_0[11:7] };
            end
            7'b1100011: begin // beq,bne
                o_Imm_SignExt_w = { {52{i_inst_31_0[31]}}, i_inst_31_0[31], i_inst_31_0[7], i_inst_31_0[30:25], i_inst_31_0[11:8] };
            end
            7'b0010011: begin // I-type
                o_Imm_SignExt_w = { {52{i_inst_31_0[31]}}, i_inst_31_0[31:20] };
            end
            default: begin
                o_Imm_SignExt_w = 0;
            end
        endcase
    end

endmodule