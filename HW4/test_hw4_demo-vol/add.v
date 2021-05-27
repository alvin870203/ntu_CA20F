module adder #(
    parameter DATA_W = 64
)(
    input i_clk,
    input i_rst_n,
    input [DATA_W-1:0] aa,
    input [DATA_W-1:0] bb,
    output [DATA_W-1:0] c
);
    reg [DATA_W/2:0] tempa_r, tempa_w;
    reg [DATA_W/2:0] tempb_r, tempb_w;
    reg [DATA_W-1:0] c_r, c_w;

        assign c = c_r;

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            tempa_r <= 0;
            tempb_r <= 0;
            c_r <= 0;
        end else begin
            tempa_r <= tempa_w;
            tempb_r <= tempb_w;
            c_r <= c_w;
        end
    end


    always @(*) begin
        tempa_w = aa[DATA_W/2-1:0] + bb[DATA_W/2-1:0];
        tempb_w = aa[DATA_W-1:DATA_W/2] + bb[DATA_W-1:DATA_W/2] + tempa_r[DATA_W/2];
        c_w = {tempb_r[DATA_W/2-1:0], tempa_r[DATA_W/2-1:0]};
    end

    // assign tempa = aa[DATA_W/2-1:0] + bb[DATA_W/2-1:0];
    // assign tempb = aa[DATA_W-1:DATA_W/2] + bb[DATA_W-1:DATA_W/2] + tempa[DATA_W/2];
    //     assign c = {tempb[DATA_W/2-1:0], tempa[DATA_W/2-1:0]};

endmodule