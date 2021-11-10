`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/10/31 09:17:19
// Design Name: 
// Module Name: key_det
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


module key_det(
    input sys_clk,
    input rst_n,
    input [4:0] key_input,//5个按键,底板
    output [4:0] key_out, //案件的索引,5个案件3位二进制数九克表示,000表示都没有被按下
    output keydown_flag //有按键被按下的标志位
    );


    reg [4:0] key_out_reg;//按键输入寄存器
    reg [4:0] key_input_reg;
    reg [19:0] delay_cnt;
    reg keydown_flag_reg;
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            delay_cnt <= 20'd0;
            key_input_reg <= 5'd0;
        end
        else begin
            key_input_reg <= key_input;
            if(key_input_reg != key_input) begin //打一拍不相等说明有按键被按下或弹起
                delay_cnt <= 20'd1000000;//0.02us * 1_000_000 = 20ms
            end
            else begin
                if(delay_cnt == 20'd0) begin
                    delay_cnt <= 20'd0;
                end
                else begin
                    delay_cnt <= delay_cnt - 20'd1;
                end
            end
        end
    end


    assign key_out = key_out_reg;
    assign keydown_flag = keydown_flag_reg;
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            key_out_reg <= 5'd0;
            keydown_flag_reg <= 1'b0;
        end
        else if(delay_cnt == 20'd1) begin//消抖延时后输出按键的值,在==1保证仅同步一次
            key_out_reg <= key_input_reg;
            if(key_input == 5'b1_1111) begin
                keydown_flag_reg <= 1'b0;
            end
            else begin //不全为1说明有被按下
                keydown_flag_reg <= 1'b1;
            end
        end
        else begin
            key_out_reg <= key_out_reg;//之后按键状态仍然保持
            keydown_flag_reg <= 1'b0;
        end
    end

    
endmodule



