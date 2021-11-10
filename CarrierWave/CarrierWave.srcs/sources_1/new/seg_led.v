`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/05 14:47:23
// Design Name: 
// Module Name: seg_led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg_led(
    input sys_clk,
    input rst_n,
    input [3:0] bit0,
    input [3:0] bit1,
    input [3:0] bit2,
    input [3:0] bit3,
    input ok_sig,
    input stop_sig,
    output sclk,
    output rclk,
    output DIO
    );

    parameter SEG_0	=	8'hC0;   //  0
    parameter SEG_1	=	8'hF9;   //  1
    parameter SEG_2	=	8'hA4;   //  2
    parameter SEG_3	=	8'hB0;   //  3
    parameter SEG_4	=	8'h99;   //  4
    parameter SEG_5	=	8'h92;   //  5
    parameter SEG_6	=	8'h82;   //  6
    parameter SEG_7	=	8'hF8;   //  7
    parameter SEG_8	=	8'h80;   //  8
    parameter SEG_9	=	8'h90;   //  9
    parameter SEG_NONE = 8'hFF;

    parameter CLK_DIV_PERIOD = 2500;
 
    parameter	IDLE	=	3'd0;
    parameter	MAIN	=	3'd1;
    parameter	WRITE	=	3'd2;
    
    parameter	LOW		=	1'b0;
    parameter	HIGH	=	1'b1;


    reg [3:0] bit0_reg;
    reg [3:0] bit1_reg;
    reg [3:0] bit2_reg;
    reg [3:0] bit3_reg;
    //ok按键按下时同步按键输入的数据,寄存起来
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            bit0_reg <= 0;
            bit1_reg <= 0;
            bit2_reg <= 0;
            bit3_reg <= 0;
        end
        else begin
            if(ok_sig) begin
                bit0_reg <= bit0;
                bit1_reg <= bit1;
                bit2_reg <= bit2;
                bit3_reg <= bit3;
            end
            else if(stop_sig) begin
                bit0_reg <= 0;
                bit1_reg <= 0;
                bit2_reg <= 0;
                bit3_reg <= 0;
            end
        end
    end

    //根据bitx_reg内容查字库,设置每个bit的seg码
    reg [7:0] bit0_seg;
    reg [7:0] bit1_seg;
    reg [7:0] bit2_seg;
    reg [7:0] bit3_seg;
    always @(*) begin
        if(!rst_n) begin
            bit0_seg = SEG_NONE;
        end
        else begin
            case(bit0_reg)
                0: bit0_seg = SEG_0;
                1: bit0_seg = SEG_1;
                2: bit0_seg = SEG_2;
                3: bit0_seg = SEG_3;
                4: bit0_seg = SEG_4;
                5: bit0_seg = SEG_5;
                6: bit0_seg = SEG_6;
                7: bit0_seg = SEG_7;
                8: bit0_seg = SEG_8;
                9: bit0_seg = SEG_9;
                default: bit0_seg = SEG_NONE;
            endcase
        end
    end
    always @(*) begin
        if(!rst_n) begin
            bit1_seg = SEG_NONE;
        end
        else begin
            case(bit1_reg)
                0: bit1_seg = SEG_0;
                1: bit1_seg = SEG_1;
                2: bit1_seg = SEG_2;
                3: bit1_seg = SEG_3;
                4: bit1_seg = SEG_4;
                5: bit1_seg = SEG_5;
                6: bit1_seg = SEG_6;
                7: bit1_seg = SEG_7;
                8: bit1_seg = SEG_8;
                9: bit1_seg = SEG_9;
                default: bit1_seg = SEG_NONE;
            endcase
        end
    end
    always @(*) begin
        if(!rst_n) begin
            bit2_seg = SEG_NONE;
        end
        else begin
            case(bit2_reg)
                0: bit2_seg = SEG_0;
                1: bit2_seg = SEG_1;
                2: bit2_seg = SEG_2;
                3: bit2_seg = SEG_3;
                4: bit2_seg = SEG_4;
                5: bit2_seg = SEG_5;
                6: bit2_seg = SEG_6;
                7: bit2_seg = SEG_7;
                8: bit2_seg = SEG_8;
                9: bit2_seg = SEG_9;
                default: bit2_seg = SEG_NONE;
            endcase
        end
    end
    always @(*) begin
        if(!rst_n) begin
            bit3_seg = SEG_NONE;
        end
        else begin
            case(bit3_reg)
                0: bit3_seg = SEG_0;
                1: bit3_seg = SEG_1;
                2: bit3_seg = SEG_2;
                3: bit3_seg = SEG_3;
                4: bit3_seg = SEG_4;
                5: bit3_seg = SEG_5;
                6: bit3_seg = SEG_6;
                7: bit3_seg = SEG_7;
                8: bit3_seg = SEG_8;
                9: bit3_seg = SEG_9;
                default: bit3_seg = SEG_NONE;
            endcase
        end
    end



    //计数,产生分频的脉冲信号
    reg[15:0] cnt=0;
    reg clk_div; 
    always@(posedge sys_clk) begin
        if(!rst_n) begin
            cnt <= 1'b0;
            clk_div <= 1'b0;
        end 
        else begin
            if(cnt>=(CLK_DIV_PERIOD-1)) begin
                cnt <= 1'b0;
                clk_div <= 1'b1;
            end
            else begin
                cnt <= cnt + 1'b1;
                clk_div <= 1'b0;
            end 
        end
    end
    
    

    
    //状态机写入74HC595
    reg	[15:0] data_reg;
    reg	[2:0] cnt_main;
    reg	[5:0] cnt_write;
    reg	[2:0] state = IDLE;
    reg DIO_reg;
    reg RCLK_reg;
    reg SCLK_reg;
    assign DIO = DIO_reg;
    assign rclk = RCLK_reg;
    assign sclk = SCLK_reg;
    always@(posedge sys_clk) begin
        if(!rst_n) begin
            state <= IDLE;
            cnt_main <= 3'd0;
            cnt_write <= 6'd0;
            DIO_reg <= 1'b0;
            SCLK_reg <= LOW;
            RCLK_reg <= HIGH;
        end
        else begin
            case(state)
                IDLE:begin	//IDLE软复位
                    state <= MAIN;
                    cnt_main <= 3'd0;
                    cnt_write <= 6'd0;
                    DIO_reg <= 1'b0;
                    SCLK_reg <= LOW;
                    RCLK_reg <= LOW;
                end
                MAIN:begin
                    if(cnt_main == 3'd3) cnt_main <= 1'b0;
                    else cnt_main <= cnt_main + 1'b1;
                    case(cnt_main)
                        //对4位数码管逐位扫描
                        3'd0: begin 
                            state <= WRITE;
                            data_reg <= {bit0_seg,8'h08};
                        end
                        3'd1: begin 
                            state <= WRITE;
                            data_reg <= {bit1_seg,8'h04}; 
                        end
                        3'd2: begin 
                            state <= WRITE;
                            data_reg <= {bit2_seg,8'h02}; 
                        end
                        3'd3: begin 
                            state <= WRITE;
                            data_reg <= {bit3_seg,8'h01}; 
                        end
                        default: state <= IDLE;
                    endcase
                end
                WRITE:begin
                    if(clk_div) begin
                        if(cnt_write == 6'd33) cnt_write <= 1'b0;
                        else cnt_write <= cnt_write + 1'b1;
                        case(cnt_write)
                            6'd0:  begin SCLK_reg <= LOW; DIO_reg <= data_reg[15]; end		//SCK下降沿时串口更新数据
                            6'd1:  begin SCLK_reg <= HIGH; end								//SCK上升沿时串口数据稳定
                            6'd2:  begin SCLK_reg <= LOW; DIO_reg <= data_reg[14]; end
                            6'd3:  begin SCLK_reg <= HIGH; end
                            6'd4:  begin SCLK_reg <= LOW; DIO_reg <= data_reg[13]; end
                            6'd5:  begin SCLK_reg <= HIGH; end
                            6'd6:  begin SCLK_reg <= LOW; DIO_reg <= data_reg[12]; end
                            6'd7:  begin SCLK_reg <= HIGH; end
                            6'd8:  begin SCLK_reg <= LOW; DIO_reg <= data_reg[11]; end
                            6'd9:  begin SCLK_reg <= HIGH; end
                            6'd10: begin SCLK_reg <= LOW; DIO_reg <= data_reg[10]; end
                            6'd11: begin SCLK_reg <= HIGH; end
                            6'd12: begin SCLK_reg <= LOW; DIO_reg <= data_reg[9]; end
                            6'd13: begin SCLK_reg <= HIGH; end
                            6'd14: begin SCLK_reg <= LOW; DIO_reg <= data_reg[8]; end
                            6'd15: begin SCLK_reg <= HIGH; end
                            6'd16: begin SCLK_reg <= LOW; DIO_reg <= data_reg[7]; end
                            6'd17: begin SCLK_reg <= HIGH; end
                            6'd18: begin SCLK_reg <= LOW; DIO_reg <= data_reg[6]; end
                            6'd19: begin SCLK_reg <= HIGH; end
                            6'd20: begin SCLK_reg <= LOW; DIO_reg <= data_reg[5]; end
                            6'd21: begin SCLK_reg <= HIGH; end
                            6'd22: begin SCLK_reg <= LOW; DIO_reg <= data_reg[4]; end
                            6'd23: begin SCLK_reg <= HIGH; end
                            6'd24: begin SCLK_reg <= LOW; DIO_reg <= data_reg[3]; end
                            6'd25: begin SCLK_reg <= HIGH; end
                            6'd26: begin SCLK_reg <= LOW; DIO_reg <= data_reg[2]; end
                            6'd27: begin SCLK_reg <= HIGH; end
                            6'd28: begin SCLK_reg <= LOW; DIO_reg <= data_reg[1]; end
                            6'd29: begin SCLK_reg <= HIGH; end
                            6'd30: begin SCLK_reg <= LOW; DIO_reg <= data_reg[0]; end
                            6'd31: begin SCLK_reg <= HIGH; end
                            6'd32: begin RCLK_reg <= LOW; end								//当16位数据传送完成后RCK拉高，输出生效
                            6'd33: begin RCLK_reg <= HIGH; state <= MAIN; end
                            default: state <= IDLE;
                        endcase
                    end 
                    else begin
                        SCLK_reg <= SCLK_reg;
                        DIO_reg <= DIO_reg;
                        RCLK_reg <= RCLK_reg;
                        cnt_write <= cnt_write;
                        state <= state;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
