`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/04 19:37:11
// Design Name: 
// Module Name: AD_samp
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


module AD_samp(
    input sys_clk,
    input rst_n,
    input [11:0] AD9226_ChanA_data,//通道AB的12bit数字量
    output AD9226_ChanA_clk,//通道AB的时钟
    output ad_sync_done,//AD数据同步完成标志
    output [11:0] ad_sync_data
);


    /*
    **100kHz计数,生成AD采样时钟(50kHz)
    */
    reg [8:0] cnt_100k;
    parameter CNT_100k = 500;//500*0.02us = 10us(100k)
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            cnt_100k <= 0;
        end
        else if(cnt_100k == CNT_100k - 1) begin
            cnt_100k <= 0;
        end
        else begin
            cnt_100k <= cnt_100k + 1'd1;
        end
    end




    /*
    **AD上升沿转换输入,下降沿同步数据
    */
    reg chanA_clk_reg;
    reg [11:0] chanA_data_reg;
    reg ad_sync_done_reg;//AD数据同步完成标志
    reg AD_state;
    parameter POSEDGE = 0;
    parameter NEGEDGE = 1;

    assign ad_sync_data = chanA_data_reg;
    assign AD9226_ChanA_clk = chanA_clk_reg;
    assign ad_sync_done = ad_sync_done_reg;

    always@(posedge sys_clk) begin
        if(!rst_n)begin
            chanA_clk_reg <= 0;
            chanA_data_reg <= 0;
            ad_sync_done_reg <= 0;
            AD_state <= POSEDGE;
        end
        else begin
            if(cnt_100k == CNT_100k - 1) begin //计够了10us便更换state,最终adclk为50khz
                case(AD_state)
                    POSEDGE:begin//adclk上升沿采集数据
                        chanA_clk_reg <= 1;
                        AD_state <= NEGEDGE;   
                        ad_sync_done_reg <= 0;  
                    end
                    NEGEDGE:begin//adclk下降沿同步数据
                        chanA_clk_reg <= 0;
                        AD_state <= POSEDGE;
                        ad_sync_done_reg <= 1;
                        chanA_data_reg <= AD9226_ChanA_data;
                    end
                    default: AD_state <= POSEDGE;
                endcase
            end
            else begin
                ad_sync_done_reg <= 0;
            end 
        end
    end




endmodule
