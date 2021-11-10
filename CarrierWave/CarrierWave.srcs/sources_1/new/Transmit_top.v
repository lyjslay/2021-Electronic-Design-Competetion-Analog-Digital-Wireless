`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/04 19:36:22
// Design Name: 
// Module Name: Transmit_top
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


module Transmit_top(
    input sys_clk,
    input rst_n,
    input [11:0] AD_data,
    input [4:0] key_input, //地板案件控制载波频率

    output AD_clk,
    output [13:0] DA_data,//输出给DA的模拟型号
    output conbined_wave, //合成后的数字波形
    output DA_clk,

    //数码管信号
    output sclk,//上身沿串口读数
    output rclk,//上身沿更新一位数据,以为
    output DIO,//串口段码数据
     
    input [3:0] col,//军阵键盘的信号
    output [3:0] row,
    // output [15:0] key_data,
    output [3:0] led,//底板灯
    output core_led//核心板灯

);

    reg [13:0] digital_sig; //键盘输入的四个数的二进制形式
    reg [13:0] digital_sig_tmp;
    reg digital_sig_ok;

    /*
    -----------------------------------------------------------------------------------------
    ** 矩阵键盘 0~9数字,12为确认(OK),13为清除(CLR),15为停止数字信号,10/14无用,11为默认
    -----------------------------------------------------------------------------------------
    */
    wire [3:0] matrix_key_out;
    reg [3:0] led_reg;
    wire matrix_down_flag;
    assign led = led_reg;
    matrix_key u_matrix_key (
        .sys_clk                 ( sys_clk   ),
        .rst_n                   ( rst_n     ),
        .col                     ( col       ),

        .row                     ( row       ),
        .key_out                 ( matrix_key_out   ),
        .matrix_down_flag        ( matrix_down_flag )
    );
    // wire keyin_flag;
    // reg [3:0] key_out_reg1;
    // reg [3:0] key_out_reg2;
    // assign keyin_flag = (key_out_reg1 != key_out_reg2) ? 1 : 0;
    // always@(posedge sys_clk) begin
    //     if(!rst_n)begin
    //         //led_reg <= 4'b0000;
    //         key_out_reg1 <= 4'd11;//默认为不用的按键
    //         key_out_reg2 <= 4'd11;
    //     end
    //     else begin
    //         //led_reg <= key_out;
    //         key_out_reg1 <=key_out;
    //         key_out_reg2 <= key_out_reg1;
    //     end
    // end

    //接收四次输入的值
    reg [3:0] bit0;
    reg [3:0] bit1;
    reg [3:0] bit2;
    reg [3:0] bit3;
    reg [2:0] keyin_num; //计数已输入数字的个数
    reg ok_sig;
    reg stop_sig;
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            bit0 <= 4'd0;
            bit1 <= 4'd0;
            bit2 <= 4'd0;
            bit3 <= 4'd0;
            keyin_num <= 0;
            ok_sig <= 0;
            stop_sig <= 0;
            led_reg <= 4'b1111;
            digital_sig <= 14'd0; //按下ok信号后同步tmp至此寄存器
            digital_sig_tmp <= 14'd0; //每输入一个数就加上
            digital_sig_ok <= 0;

        end
        else if(matrix_down_flag)begin //矩阵有按键被按下
            if(matrix_key_out == 12 && keyin_num == 3) begin //按下的是ok键,且已经输入了4个数
                ok_sig <= 1; 
                stop_sig <= 0; 
                keyin_num <= 0;
                led_reg <= matrix_key_out;
                digital_sig <= digital_sig_tmp; //赋值并清零tmp等待下一次接受
                digital_sig_tmp <= 0;
                digital_sig_ok <= 1; //一直有效,直到按下其他数字开始或者停止键,
            end
            else if(matrix_key_out == 12 && keyin_num != 3) begin //未接受完毕
                led_reg <= led_reg;
                keyin_num <= keyin_num;
                led_reg <= 11;//灯为未使用的键,报错
                ok_sig <= 0;
                stop_sig <= 0; 
                digital_sig <= 0;
                digital_sig_tmp <= digital_sig_tmp;
            end
            else if(matrix_key_out == 15) begin //按下了停止信号,即没有数字信号
                stop_sig <= 1; //持续一个脉冲
                bit0 <= 4'd0;
                bit1 <= 4'd0;
                bit2 <= 4'd0;
                bit3 <= 4'd0;
                keyin_num <= 0;
                led_reg <= matrix_key_out;
                ok_sig <= 0;
                digital_sig <= 0;
                digital_sig_tmp <= 0;
            end
            else if(matrix_key_out == 13) begin //清除信号
                bit0 <= 4'd0;
                bit1 <= 4'd0;
                bit2 <= 4'd0;
                bit3 <= 4'd0;
                keyin_num <= 0;
                led_reg <= matrix_key_out;
                ok_sig <= 0;
                stop_sig <= 0; 
                digital_sig <= 0;
                digital_sig_tmp <= 0;
            end
            else if(matrix_key_out == 10 || matrix_key_out == 11 || matrix_key_out == 14) begin //按下了未定义的按钮
                led_reg <= 4'b0101;
                stop_sig <= 0; 
                ok_sig <= 0;
            end
            else begin //其他的数字信号,并按顺序转为十进制
                ok_sig <= 0;
                case(keyin_num)
                    0: begin
                        led_reg <= 4'b1110;
                        bit0 <= matrix_key_out;
                        keyin_num <= 1;
                        digital_sig_tmp <= digital_sig_tmp + matrix_key_out;//第一位加本身
                    end
                    1: begin
                        led_reg <= 4'b1100;
                        bit1 <= matrix_key_out;
                        keyin_num <= 2;
                        digital_sig_tmp <= digital_sig_tmp + (matrix_key_out << 3 + matrix_key_out << 1);//第二位乘10
                    end
                    2: begin
                        led_reg <= 4'b1000;
                        bit2 <= matrix_key_out;
                        keyin_num <= 3;
                        digital_sig_tmp <= digital_sig_tmp + (matrix_key_out << 6) + (matrix_key_out << 5) + (matrix_key_out << 2);//第三位乘100
                    end
                    3: begin
                        led_reg <= 4'b0000;
                        bit3 <= matrix_key_out;
                        keyin_num <= 3;
                        digital_sig_tmp <= digital_sig_tmp + (matrix_key_out << 10) - (matrix_key_out <<4) - (matrix_key_out << 3);//第四位乘1000
                    end
                endcase
            end
        end
        else begin
            ok_sig <= 0; //ok信号一直保持,因为数字信号稳定时需要一直传输
            stop_sig <= 0;
            digital_sig_ok <= digital_sig_ok;
        end
    end


    /*
    -----------------------------------------------------------------------------------------
    ** 数码管
    -----------------------------------------------------------------------------------------
    */
    seg_led u_seg_led (
        .sys_clk                 ( sys_clk    ),
        .rst_n                   ( rst_n      ),
        .bit0                    ( bit0       ),
        .bit1                    ( bit1       ),
        .bit2                    ( bit2       ),
        .bit3                    ( bit3       ),
        .ok_sig                  ( ok_sig     ),
        .stop_sig                ( stop_sig   ),

        .sclk                    ( sclk       ),
        .rclk                    ( rclk       ),
        .DIO                     ( DIO        )
    );


    /*
    -----------------------------------------------------------------------------------------
    ** pll模块(125M)
    -----------------------------------------------------------------------------------------
    */
    wire  clk_125m;
    wire  pll_locked;
    assign DA_clk = clk_125m;

    clk_gen  u_clk_gen (
        .sys_clk              ( sys_clk       ),
        .rst_n                ( rst_n         ),

        .clk_125m             ( clk_125m   ),
        .pll_locked           ( pll_locked    )
    );
    

    /*
    -----------------------------------------------------------------------------------------
    **AD采样模块,采样频率50kHz
    -----------------------------------------------------------------------------------------
    */
    // AD_samp Inputs
    wire [11:0] ad_sync_data;

    // AD_samp Outputs
    wire  ad_sync_done;

    AD_samp u_AD_samp (
        .sys_clk                 ( sys_clk             ),
        .rst_n                   ( rst_n               ),
        .AD9226_ChanA_data       ( AD_data             ),

        .AD9226_ChanA_clk        ( AD_clk              ),
        .ad_sync_done            ( ad_sync_done        ),
        .ad_sync_data            ( ad_sync_data        )
    );




    /*
    -----------------------------------------------------------------------------------------
    ** 生成AM波形
    -----------------------------------------------------------------------------------------
    */
    // FM Inputs
    wire dds_clk_125m;   
    assign dds_clk_125m = clk_125m;          


   
    // AM Outputs
    wire [13:0] FM_wave;
    assign DA_data = FM_wave;

    AM u_AM (
        .sys_clk                 ( sys_clk          ),
        .rst_n                   ( rst_n            ),
        .dds_clk_125m            ( dds_clk_125m     ),
        .AD_sync_done            ( ad_sync_done     ),
        .AD_data                 ( ad_sync_data     ),
        .digital_sig_ok          ( digital_sig_ok   ),
        .digital_sig             ( digital_sig      ),
        .key_input               ( key_input        ),

        .FM_wave                 ( FM_wave          ),
        .conbined_wave           ( conbined_wave    )
    );





    /*
    -----------------------------------------------------------------------------------------
    **核心板上的灯,程序烧完后一直闪烁运行
    -----------------------------------------------------------------------------------------
    */
    reg [31:0] cnt_500ms;
    reg core_led_reg;
    parameter CNT_500MS = 25000000 ;
    assign core_led = core_led_reg;
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            cnt_500ms <= 32'd0;
            core_led_reg <= 0;
        end
        else if(cnt_500ms == CNT_500MS - 1) begin
            cnt_500ms <= 32'd0;
            core_led_reg <= ~core_led_reg;
        end
        else begin
            cnt_500ms <= cnt_500ms + 32'd1;
            core_led_reg <= core_led_reg;
        end
    end

endmodule
