module MUL #(
    parameter DATA_WIDTH = 32
)(
    input                   i_clk,
    input                   i_rst_n,
    input  [DATA_WIDTH-1:0] i_data_a,
    input  [DATA_WIDTH-1:0] i_data_b,
    input                   i_valid,
    output [DATA_WIDTH-1:0] o_data,
    output                  o_valid
);


    reg [DATA_WIDTH-1:0] o_data_w, o_data_r;
    reg                  o_valid_w, o_valid_r;
    reg                  i_s_a, i_s_b, s_a, s_b, s_data;
    reg [7:0]            i_e_a, i_e_b, e_a, e_b, e_data, e_diff;
    reg [26:0]           i_f_a, i_f_b, f_a, f_b;
    reg [53:0]           mul;
    reg [22:0]           f_data;
    
    integer i;

    assign o_data = o_data_r;
    assign o_valid = o_valid_r;


    always @(*) begin
        if (i_valid) begin
            o_valid_w = 1;
            
            // unpack
            i_s_a = i_data_a[31];
            i_s_b = i_data_b[31];
            i_e_a = i_data_a[30:23];
            i_e_b = i_data_b[30:23];
            i_f_a = {1'b1, i_data_a[22:0], 3'b000};
            i_f_b = {1'b1, i_data_b[22:0], 3'b000};

            // mul don't need to allign
            s_a = i_s_a;
            s_b = i_s_b;

            e_diff = 0;
            e_b = i_e_b;
            e_a = i_e_a;
            f_b = i_f_b;
            f_a = i_f_a;

            // mul
            s_data = (s_a == s_b) ? 0 : 1;
            mul = f_b * f_a;

            // normalize and round
            if (mul[53]) begin
                e_data = e_a + e_b -127 + 1;
                case ({mul[29], ~(mul[28:0] == 0)})
                    2'b11: begin
                        f_data = mul[52:30] + 1;
                    end
                    2'b10: begin
                        f_data = mul[30] ? mul[52:30] + 1 : mul[52:30];
                    end
                    default: begin
                        f_data = mul[52:30];
                    end
                endcase
            end else begin
                e_data = e_a + e_b - 127;
                case ({mul[28], ~(mul[27:0] == 0)})
                    2'b11: begin
                        f_data = mul[51:29] + 1;
                    end
                    2'b10: begin
                        f_data = mul[29] ? mul[51:29] + 1 : mul[51:29];
                    end
                    default: begin
                        f_data = mul[51:29];
                    end
                endcase
            end

            // unpack
            o_data_w = {s_data, e_data, f_data};
        end else begin
            o_data_w = 0;
            o_valid_w = 0;
        end
    end


    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_valid_r <= 0;
            o_data_r <= 0;
        end else begin
            o_valid_r <= o_valid_w;
            o_data_r <= o_data_w;
        end
    end

endmodule