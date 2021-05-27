module fpu #(
    parameter DATA_WIDTH = 32,
    parameter INST_WIDTH = 1
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input  [INST_WIDTH-1:0] i_inst,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_valid
);

    // homework
    
    // wire and register
    wire [DATA_WIDTH-1:0] o_data_add, o_data_mul;
    wire                  o_valid_add, o_valid_mul;

    // ADD module
    ADD #(
        .DATA_WIDTH(DATA_WIDTH)
    ) u_ADD (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_data_a(i_data_a),
        .i_data_b(i_data_b),
        .i_valid(i_valid),
        .o_data(o_data_add),
        .o_valid(o_valid_add)
    );

    // MUL module
    MUL #(
        .DATA_WIDTH(DATA_WIDTH)
    ) u_MUL (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_data_a(i_data_a),
        .i_data_b(i_data_b),
        .i_valid(i_valid),
        .o_data(o_data_mul),
        .o_valid(o_valid_mul)
    );

    assign o_data = i_inst ? o_data_mul : o_data_add;
    assign o_valid = i_inst ? o_valid_mul : o_valid_add;

    /*case (i_inst)
        1'b0: begin // add
            assign o_data = o_data_add;
            assign o_valid = o_valid_add;
        end
        1'b1: begin // mul
            assign o_data = o_data_mul;
            assign o_valid = o_valid_mul;
        end
        default: begin
            assign o_data = 0;
            assign o_valid = 0;
        end
    endcase*/

endmodule