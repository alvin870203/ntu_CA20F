module ADD #(
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
    reg [27:0]           sum;
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

            // allign
            s_a = i_s_a;
            s_b = i_s_b;
            if (i_e_a > i_e_b) begin
                e_diff = i_e_a - i_e_b;
                e_a = i_e_a;
                e_b = i_e_a;
                f_a = i_f_a;
                f_b = i_f_b >> e_diff;
            end else if (i_e_a < i_e_b) begin
                e_diff = i_e_b - i_e_a;
                e_b = i_e_b;
                e_a = i_e_b;
                f_b = i_f_b;
                f_a = i_f_a >> e_diff;
            end else begin
                e_diff = 0;
                e_b = i_e_b;
                e_a = i_e_a;
                f_b = i_f_b;
                f_a = i_f_a;
            end

            // sum
            if (s_a == s_b) begin
                sum = f_a + f_b;
                s_data = s_a;
            end else begin
                if (f_a >= f_b) begin
                    sum = f_a - f_b;
                    s_data = s_a;
                end else begin
                    sum = f_b - f_a;
                    s_data = s_b;
                end
            end

            // normalize and round
            if (sum[27]) begin
                e_data = e_a + 1;
                case ({sum[3], sum[2] | sum[1] | sum[0]})
                    2'b11: begin
                        f_data = sum[26:4] + 1;
                    end
                    2'b10: begin
                        f_data = sum[4] ? sum[26:4] + 1 : sum[26:4];
                    end
                    default: begin
                        f_data = sum[26:4];
                    end
                endcase
            end else begin
                e_data = e_a;
                case ({sum[2], sum[1] | sum[0]})
                    2'b11: begin
                        f_data = sum[25:3] + 1;
                    end
                    2'b10: begin
                        f_data = sum[3] ? sum[25:3] + 1 : sum[25:3];
                    end
                    default: begin
                        f_data = sum[25:3];
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