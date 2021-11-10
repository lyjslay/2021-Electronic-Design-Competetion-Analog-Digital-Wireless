`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: 
// 
// Create Date: 2021/11/04 11:42:25
// Design Name: 
// Module Name: Carrier_top
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


module Carrier_top(
    input sys_clk,
    input rst_n,
    input [4:0] key_input,
    output DA_clk_125m,
    output [13:0] DA_data,
    output core_led
    );


    /*
    -----------------------------------------------------------------------------------------
    **按键检测模块
    -----------------------------------------------------------------------------------------
    */
    wire  [4:0]  key_out;
    wire  keydown_flag;
    reg freq_change;//按键控制载波频率变化,一个sys_clk脉冲
    key_det  u_key_det (
        .sys_clk                 ( sys_clk        ),
        .rst_n                   ( rst_n          ),
        .key_input               ( key_input      ),

        .key_out                 ( key_out        ),
        .keydown_flag            ( keydown_flag   ) 
    );

    always@(posedge sys_clk) begin
        if(!rst_n)begin
            freq_change <= 0;
        end
        else if(keydown_flag) begin
            if(key_out[0] == 0) begin //按键0控制频率
                freq_change <= 1;
            end
            else begin
                freq_change <= 0;
            end
        end
        else begin
            freq_change <= 0;
        end
    end






    // clk_gen Outputs
    wire  clk_125m;
    wire  pll_locked;
    assign DA_clk_125m = clk_125m;

    clk_gen  u_clk_gen (
        .sys_clk              ( sys_clk       ),
        .rst_n                ( rst_n         ),

        .clk_125m             ( clk_125m   ),
        .pll_locked           ( pll_locked    )
    );


    // CarrierWave Outputs
    wire  [13:0]  sin_data;
    assign DA_data = sin_data;

    CarrierWave u_CarrierWave (
        .DA_clk_125m             ( clk_125m   ),
        .sys_clk                 ( sys_clk       ),
        .rst_n                   ( rst_n         ),
        .pll_locked              ( pll_locked    ),
        .freq_change             ( freq_change   ),

        .sin_data                ( sin_data      )
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
