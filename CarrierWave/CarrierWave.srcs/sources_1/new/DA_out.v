`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLU
// Engineer: lyjslay/liuyj1918@mails.jlu.edu.cn
// 
// Create Date: 2021/10/26 14:49:29
// Design Name: 
// Module Name: DA_out
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


module DA_out(
    input [13:0] digital_sig, //要输出的数字量
    input sys_clk,
    input rst_n,
    output [13:0] DA9764_data,//伸缩为14bit
    output DA9764_clk //DA的时钟12.5Mhz
    );



    /*
    **25MHz计数,生成DA转换时钟(12.5MHz)
    */
    reg cnt_25m;
    parameter CNT_25M = 2;//2*0.02us = 0.04us(25M)
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            cnt_25m <= 0;
        end
        else if(cnt_25m == CNT_25M - 1) begin
            cnt_25m <= 0;
        end
        else begin
            cnt_25m <= cnt_25m + 1'd1;
        end
    end





    /*
    **DA下降沿同步digital_sig,上圣言转换输出
    */    
    reg [13:0] DA9764_data_reg;
    reg DA_state;
    reg DA_clk_reg;
    parameter POSEDGE = 0 ;
    parameter NEGEDGE = 1 ;

    assign DA9764_data = DA9764_data_reg;
    assign DA9764_clk = DA_clk_reg;

    always@(posedge sys_clk) begin
        if(!rst_n)begin
            DA_state <= POSEDGE;
            DA9764_data_reg <= 14'd0;
            DA_clk_reg <= 0;
        end
        else begin
            case(DA_state)
                POSEDGE:begin //上升沿保持输出数据
                    DA_clk_reg <= 1;
                    DA_state <= NEGEDGE;
                    DA9764_data_reg <= DA9764_data_reg;
                end
                NEGEDGE:begin //下降沿改变数据
                    DA_clk_reg <= 0;
                    DA_state <= POSEDGE;
                    DA9764_data_reg <= digital_sig[13:0];//截取高14bit输出给da    
                end
            endcase
        end      
    end



endmodule
