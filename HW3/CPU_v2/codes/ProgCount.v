module ProgCount #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input               i_clk,
    input               i_rst_n, 
    input [ADDR_W-1:0]  i_PC_next,     //(PC_next),
    input               i_InstNext,    //(InstNext),
    output [ADDR_W-1:0] o_PC,          //(PC)
    output              o_i_valid_addr //(o_i_valid_addr)
);

    reg [ADDR_W-1:0] o_PC_r, o_PC_w;   //(PC)
    reg              o_i_valid_addr_r, o_i_valid_addr_w;
    
    // prevent first PC to be 0+4
    reg state, state_next;
    parameter start = 1'b0;
    parameter following = 1'b1;

    assign o_PC = o_PC_r;
    assign o_i_valid_addr = o_i_valid_addr_r;

    always @(*) begin
        o_i_valid_addr_w = i_InstNext;
        if (state == start) begin
            o_PC_w = 0;
        end else if (i_InstNext) begin
            o_PC_w = i_PC_next;
        end else begin
            o_PC_w = o_PC_r;
        end
    end

    always @(*) begin
        case (state)
            start:
                state_next = following;
            following:
                state_next = state; 
            default:
                state_next = following;
        endcase
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_PC_r <= 0;
            o_i_valid_addr_r <= 0;
            state <= start;
        end else begin
            o_PC_r <= o_PC_w;
            o_i_valid_addr_r <= o_i_valid_addr_w;
            state <= state_next;
        end
    end

endmodule