module sorter #(
    parameter DATA_W = 82
) (
    input i_clk,
    input i_rst_n,
    input [DATA_W*8-1:0] i_input,
    input [DATA_W*8-1:0] o_output
);

    reg [DATA_W*8-1:0] o_output_r, o_output_w;

    wire [DATA_W-1:0] i_input_ [0:7]; // 8個長度度為DATA_W的wire，整體視作一個array，i_input_[0]代表第1個8bit的wire
    integer i;

    reg [DATA_W-1:0] stage_1_r [0:7];
    reg [DATA_W-1:0] stage_1_w [0:7];
    reg [DATA_W-1:0] stage_2_r [0:7];
    reg [DATA_W-1:0] stage_2_w [0:7];
    reg [DATA_W-1:0] stage_3_r [0:7];
    reg [DATA_W-1:0] stage_3_w [0:7];
    reg [DATA_W-1:0] stage_4_r [0:7];
    reg [DATA_W-1:0] stage_4_w [0:7];
    reg [DATA_W-1:0] stage_5_r [0:7];
    reg [DATA_W-1:0] stage_5_w [0:7];
    reg [DATA_W-1:0] stage_6_r [0:7];
    reg [DATA_W-1:0] stage_6_w [0:7];


    //assign o_output = o_output_r;

    // combinational part

    // stage1
    always @(*) begin
        stage_1_w[0] = (i_input_[0] < i_input_[1]) ? i_input_[0] : i_input_[1];
        stage_1_w[1] = (i_input_[0] > i_input_[1]) ? i_input_[0] : i_input_[1];

        stage_1_w[2] = (i_input_[2] < i_input_[3]) ? i_input_[3] : i_input_[2];
        stage_1_w[3] = (i_input_[2] > i_input_[3]) ? i_input_[3] : i_input_[2];

        stage_1_w[4] = (i_input_[4] < i_input_[5]) ? i_input_[4] : i_input_[5];
        stage_1_w[5] = (i_input_[4] > i_input_[5]) ? i_input_[4] : i_input_[5];

        stage_1_w[6] = (i_input_[6] < i_input_[7]) ? i_input_[7] : i_input_[6];
        stage_1_w[7] = (i_input_[6] > i_input_[7]) ? i_input_[7] : i_input_[6];
        // if (i_input_[0] > i_input_[1]) begin
        //     stage_1_w[1] = i_input_[0];
        //     stage_1_w[0] = i_input_[1];
        // end else begin
        //     stage_1_w[1] = i_input_[1];
        //     stage_1_w[0] = i_input_[0];
        // end
    end

    // stage2
    always @(*) begin
        stage_1_w[0] = (stage_1_r[0] < stage_1_r[2]) ? stage_1_r[0] : stage_1_r[2];
        stage_1_w[0] = (stage_1_r[0] > stage_1_r[2]) ? stage_1_r[0] : stage_1_r[2];
        // ...
    end

    // ...

    //
    assign o_output[7:0] = stage_6_r[0];
    assign o_output[15:8] = stage_6_r[1];
    assign o_output[23:16] = stage_6_r[2];
    // ...
    

    // sequential part
    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            o_output_r <= 0;
            for (i = 0; i < 8; i=i+1) begin
                stage_1_r[i] <= 0;
                stage_2_r[i] <= 0;
                stage_3_r[i] <= 0;
                stage_4_r[i] <= 0;
                stage_5_r[i] <= 0;
                stage_6_r[i] <= 0;
            end
        end else begin
            for (i = 0; i < 8; i=i+1) begin
                stage_1_r[i] <= stage_1_w[i];
                stage_2_r[i] <= stage_2_w[i];
                stage_3_r[i] <= stage_3_w[i];
                stage_4_r[i] <= stage_4_w[i];
                stage_5_r[i] <= stage_5_w[i];
                stage_6_r[i] <= stage_6_w[i];
            end
            //o_output_r <= o_output_w;
        end
    end

endmodule