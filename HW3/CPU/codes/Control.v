module Control #(
	parameter ADDR_W = 64,
	parameter INST_W = 32,
	parameter DATA_W = 64
)(
    input i_clk,
    input i_rst_n,
    input [6:0] i_inst_6_0, //(i_i_inst[6:0]),
    input i_valid_inst, //(i_i_valid_inst),
    input i_valid_ld, //(i_d_valid_data),
    output o_Branch, //(Branch),
    output o_MemRead, //(o_d_MemRead),
    output o_MemtoReg, //(MemtoReg),
    output [1:0] o_ALUOp, //(ALUOp),
    output o_MemWrite, //(o_d_MemWrite),
    output o_ALUSrc, //(ALUSrc),
    output o_RegWrite, //(RegWrite),
    output o_InstNext, //(InstNext),
    output o_Finish //(o_finish)
);

    reg i_valid_inst_r, i_valid_inst_w;

    reg o_Branch_r, o_Branch_w; //(Branch),
    reg o_MemRead_r, o_MemRead_w; //(o_d_MemRead),
    reg o_MemRead_r_r; //
    reg o_MemtoReg_r, o_MemtoReg_w; //(MemtoReg),
    reg [1:0] o_ALUOp_r, o_ALUOp_w; //(ALUOp),
    reg o_MemWrite_r, o_MemWrite_w; //(o_d_MemWrite),
    reg o_ALUSrc_r, o_ALUSrc_w; //(ALUSrc),
    reg o_RegWrite_r, o_RegWrite_w; //(RegWrite),
    reg o_InstNext_r, o_InstNext_w; //(InstNext),
    reg o_Finish_r, o_Finish_w; //(o_finish)

    assign o_Branch     = o_Branch_r; //(Branch),
    assign o_MemRead    = o_MemRead_r & (~o_MemRead_r_r);//o_MemRead_r; //(o_d_MemRead),  //o_MemRead_w & (~o_MemRead_r);//
    assign o_MemtoReg   = o_MemtoReg_r; //(MemtoReg),
    assign o_ALUOp      = o_ALUOp_r; //(ALUOp),
    assign o_MemWrite   = o_MemWrite_r; //(o_d_MemWrite), //o_MemWrite_w & (~o_MemWrite_r);
    // way to be one cycle
    assign o_ALUSrc     = o_ALUSrc_r;//o_ALUSrc_w & (~o_ALUSrc_r); //(ALUSrc),
    assign o_RegWrite   = o_RegWrite_r; //(RegWrite),
    assign o_InstNext   = o_InstNext_r; //(InstNext),
    assign o_Finish     = o_Finish_r; //(o_finish)

    // generate continuous valid inst signal
    always @(*) begin
        if (i_valid_inst) begin
            i_valid_inst_w = i_valid_inst;
        end else begin
            i_valid_inst_w = i_valid_inst_r;
        end
    end

    always @(*) begin
        o_ALUSrc_w   = 0;
        o_MemtoReg_w = 0;
        o_RegWrite_w = 0;
        o_MemRead_w  = 0;
        o_MemWrite_w = 0;
        o_Branch_w   = 0;
        o_ALUOp_w    = 2'b00;
        if (o_InstNext_r == 1) begin // to be one cycle
            o_InstNext_w = 0;
        end else begin // after send a inst fetch request
            if (i_valid_inst_r) begin // get an inst, then can do follow steps..., at the end can request next inst.
                o_InstNext_w = 0; // request next inst, under some conditions (previous steps already complete valid)
                //i_valid_inst_w = 0; // (deleted) not valid after request next inst
                case (i_inst_6_0) // follow steps...
                    7'b0110011: begin // R-format
                        o_RegWrite_w = 1;
                        o_ALUOp_w    = 2'b10;
                        o_InstNext_w = 1;
                        i_valid_inst_w = 0; // not valid after request next inst
                    end
                    7'b0000011: begin // ld
                        o_ALUSrc_w   = 1;
                        o_MemRead_w  = 1;
                        //if (o_MemRead_r)
                        //    o_MemRead_w = 0;
                        //o_MemRead_w_w = o_MemRead_w & (~o_MemRead_r);
                        o_MemtoReg_w = 1;
                        if (i_valid_ld) begin // deal with Data Memory delay
                            o_RegWrite_w = 1;
                            o_InstNext_w = 1;
                            i_valid_inst_w = 0; // not valid after request next inst                            
                        end
                    end
                    7'b0100011: begin // sd
                        o_ALUSrc_w   = 1;
                        o_MemWrite_w = 1;
                        o_InstNext_w = 1;
                        i_valid_inst_w = 0; // not valid after request next inst
                    end
                    7'b1100011: begin // beq, bne
                        o_Branch_w   = 1;
                        o_ALUOp_w    = 2'b01;
                        //o_InstNext_w_tmp = 1
                        //i_valid_inst_w_tmp = 0;
                        o_InstNext_w = 1;
                        i_valid_inst_w = 0; // not valid after request next inst

                    end
                    7'b0010011: begin // I-type
                        o_ALUSrc_w   = 1;
                        o_RegWrite_w = 1;
                        o_ALUOp_w    = 2'b11;
                        o_InstNext_w = 1;
                        i_valid_inst_w = 0; // not valid after request next inst
                    end
                    //default: 
                endcase
                //o_InstNext_w = 1; // request next inst, under some conditions (previous steps already complete valid)
            end else begin // haven't get an inst, can not do follow steps and request next inst yet.
                o_InstNext_w = 0;
            end
        end 

    end


    always @(*) begin
        if (i_inst_6_0 == 7'b111_1111) begin
            o_Finish_w = 1;
        end else begin
            o_Finish_w = 0;
        end
    end
    

    always @(posedge i_clk or negedge i_rst_n) begin
        if (~i_rst_n) begin
            i_valid_inst_r <= 0;
            o_Branch_r     <= 0; //(Branch),
            o_MemRead_r    <= 0; //(o_d_MemRead),
            o_MemRead_r_r  <= 0;
            o_MemtoReg_r   <= 0; //(MemtoReg),
            o_ALUOp_r      <= 0; //(ALUOp),
            o_MemWrite_r   <= 0; //(o_d_MemWrite),
            o_ALUSrc_r     <= 0; //(ALUSrc),
            o_RegWrite_r   <= 0; //(RegWrite),
            o_InstNext_r   <= 1; //(InstNext), // start with valid to get first inst
            o_Finish_r     <= 0; //(o_finish)
        end else begin
            i_valid_inst_r <= i_valid_inst_w;
            o_Branch_r     <= o_Branch_w;
            o_MemRead_r    <= o_MemRead_w;
            o_MemRead_r_r  <= o_MemRead_r;
            o_MemtoReg_r   <= o_MemtoReg_w;
            o_ALUOp_r      <= o_ALUOp_w;
            o_MemWrite_r   <= o_MemWrite_w;
            o_ALUSrc_r     <= o_ALUSrc_w;
            o_RegWrite_r   <= o_RegWrite_w;
            o_InstNext_r   <= o_InstNext_w;
            o_Finish_r     <= o_Finish_w;
        end
    end
    
endmodule