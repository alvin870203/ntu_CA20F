module ALUcontrol #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input  [3:0] i_inst_30_14_12,
    input  [1:0] i_ALUOp,
    output [3:0] o_ALUinst
);

    reg [3:0] o_ALUinst_w;

    assign o_ALUinst = o_ALUinst_w;

    always @(*) begin
        case (i_ALUOp)
            2'b00: begin // ld, sd
                o_ALUinst_w = (i_inst_30_14_12[2:0] == 3'b011) ? 4'b0010 : 4'b1111; // ALU: add
            end

            2'b01: begin // beq, bne
                case (i_inst_30_14_12[2:0]) // inst[14:12]
                    3'b000: begin // beq
                        o_ALUinst_w = 4'b0110; // ALU: sub also Zero=1 if sub=0
                    end
                    3'b001: begin // bne
                        o_ALUinst_w = 4'b0111; // ALU: sub also Zero=0 if sub~=0
                    end
                    default: begin
                        o_ALUinst_w = 4'b1111; // Error: should not occur
                    end
                endcase
            end
            
            2'b10: begin // R-type
                case (i_inst_30_14_12) // {inst[30], inst[14:12]}
                    4'b0000: begin // add
                        o_ALUinst_w = 4'b0010; // ALU: add
                    end 
                    4'b1000: begin // sub
                        o_ALUinst_w = 4'b0110; // ALU: sub
                    end 
                    4'b0100: begin // xor
                        o_ALUinst_w = 4'b0011; // ALU: xor
                    end 
                    4'b0110: begin // or
                        o_ALUinst_w = 4'b0001; // ALU: or
                    end 
                    4'b0111: begin // and
                        o_ALUinst_w = 4'b0000; // ALU: and
                    end 
                    default: begin
                        o_ALUinst_w = 4'b1111; // Error: should not occur
                    end
                endcase
            end

            2'b11: begin // I-type
                case (i_inst_30_14_12[2:0]) // inst[14:12]
                    3'b000: begin // add
                        o_ALUinst_w = 4'b0010; // ALU: add
                    end 
                    3'b100: begin // xor
                        o_ALUinst_w = 4'b0011; // ALU: xor
                    end 
                    3'b110: begin // or
                        o_ALUinst_w = 4'b0001; // ALU: or
                    end 
                    3'b111: begin // and
                        o_ALUinst_w = 4'b0000; // ALU: and
                    end
                    3'b001: begin // slli
                        o_ALUinst_w = 4'b0100; // ALU: slli
                    end 
                    3'b101: begin // srli
                        o_ALUinst_w = 4'b0101; // ALU: srli
                    end 
                    default: begin
                        o_ALUinst_w = 4'b1111; // Error: should not occur
                    end
                endcase
            end
            default: begin
                o_ALUinst_w = 4'b1111; // Error: should not occur
            end
        endcase
    end

endmodule