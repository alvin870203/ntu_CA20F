module ALU #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input  [3:0]        i_ALUinst,
    input  [DATA_W-1:0] i_ALU_in1,
    input  [DATA_W-1:0] i_ALU_in2,
    output              o_Zero,
    output [DATA_W-1:0] o_ALUresult
);

    reg              o_Zero_w;
    reg [DATA_W-1:0] o_ALUresult_w;

    assign o_Zero = o_Zero_w;
    assign o_ALUresult = o_ALUresult_w;

    always @(*) begin
        o_Zero_w = 0;
        case (i_ALUinst)
            4'b0000: begin // and
                o_ALUresult_w = i_ALU_in1 & i_ALU_in2;
            end
            4'b0001: begin // or
                o_ALUresult_w = i_ALU_in1 | i_ALU_in2;
            end
            4'b0010: begin // add
                o_ALUresult_w = i_ALU_in1 + i_ALU_in2;
            end
            4'b0110: begin // sub also Zero=1 if sub=0
                o_ALUresult_w = i_ALU_in1 - i_ALU_in2;
                o_Zero_w = (o_ALUresult_w == 0);
            end
            4'b0111: begin // sub also Zero=0 if sub~=0
                o_ALUresult_w = i_ALU_in1 - i_ALU_in2;
                o_Zero_w = ~(o_ALUresult_w == 0);
            end
            4'b0011: begin // xor
                o_ALUresult_w = i_ALU_in1 ^ i_ALU_in2;
            end
            4'b0100: begin // slli
                o_ALUresult_w = i_ALU_in1 << i_ALU_in2;
            end
            4'b0101: begin // srli
                o_ALUresult_w = i_ALU_in1 >> i_ALU_in2;
            end
            default: begin
                o_ALUresult_w = 0;
            end
        endcase 
    end

endmodule