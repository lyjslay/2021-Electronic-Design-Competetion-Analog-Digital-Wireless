`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/04 13:05:39
// Design Name: 
// Module Name: matrix_key
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

module matrix_key (
	input sys_clk,
	input rst_n,
	input [3:0]	col,			//矩阵按键列
	output [3:0] row,			//矩阵按键行
	output [3:0] key_out,
	output matrix_down_flag
);

    parameter NUM_FOR_200HZ = 250000;//250000*0.02us = 5ms
	parameter STATE0 = 2'b00;
	parameter STATE1 = 2'b01;
	parameter STATE2 = 2'b10;
	parameter STATE3 = 2'b11;
 
	//计数器计数分频实现5ms周期信号clk_200hz
	reg	[19:0] cnt;
	reg	clk_200hz;
	reg clk_200hz_posedge;//上升下降沿标志
	reg clk_200hz_negedge;
	always@(posedge sys_clk) begin
		if(!rst_n) begin
			cnt <= 20'd0;
			clk_200hz <= 1'b0;
		end 
        else begin
			if(cnt == ((NUM_FOR_200HZ/2) - 1)) begin //上升沿
				cnt <= cnt + 1'd1;
				clk_200hz <= 1;
				clk_200hz_posedge <= 1;
				clk_200hz_negedge <= 0;
			end 
			else if(cnt == NUM_FOR_200HZ - 1) begin //下降沿
				cnt <= 0;
				clk_200hz <= 0;
				clk_200hz_negedge <= 1;
				clk_200hz_posedge <= 0;
			end
			else begin
				cnt <= cnt + 1'd1;
				clk_200hz <= clk_200hz;
				clk_200hz_negedge <= 0;
				clk_200hz_posedge <= 0;
			end
		end
	end


	reg	[1:0] c_state;
    reg [3:0] row_reg;
    assign row = row_reg;

	//clk_200hz扫描
	always@(posedge sys_clk) begin
		if(!rst_n) begin
			c_state <= STATE0;
			row_reg <= 4'b1110;
		end 
        else begin
			if(clk_200hz_posedge) begin
				case(c_state)//状态c_state跳转及对应状态下矩阵按键的row输出
					STATE0: begin 
						c_state <= STATE1; //200Hz下降沿时就进入state1了
						row_reg <= 4'b1101; //因此要扫描第二个口
					end	
					STATE1: begin 
						c_state <= STATE2; 
						row_reg <= 4'b1011;
					end
					STATE2: begin 
						c_state <= STATE3; 
						row_reg <= 4'b0111;
					end
					STATE3: begin 
						c_state <= STATE0; 
						row_reg <= 4'b1110;
					end
					default:begin 
						c_state <= STATE0; 
						row_reg <= 4'b1110; 
					end
				endcase
			end
		end
	end
 

    reg [3:0] key_out_reg;
	reg matrix_keydown_flag;
	assign matrix_down_flag = matrix_keydown_flag;
    assign key_out = key_out_reg;
	always@(posedge sys_clk) begin
		if(!rst_n) begin
			key_out_reg <= 4'd11; //默认为不用的按键
		end 
        else if(clk_200hz_negedge) begin
			case(c_state)
				STATE0: begin
					case(col)
						4'b1110: begin key_out_reg <= 0; matrix_keydown_flag <= 1; end
						4'b1101: begin key_out_reg <= 1; matrix_keydown_flag <= 1; end
						4'b1011: begin key_out_reg <= 2; matrix_keydown_flag <= 1; end
						4'b0111: begin key_out_reg <= 3; matrix_keydown_flag <= 1; end
						// default: matrix_keydown_flag <= 0;
					endcase
				end
				STATE1: begin
					case(col)
						4'b1110: begin key_out_reg <= 4; matrix_keydown_flag <= 1; end
						4'b1101: begin key_out_reg <= 5; matrix_keydown_flag <= 1; end
						4'b1011: begin key_out_reg <= 6; matrix_keydown_flag <= 1; end
						4'b0111: begin key_out_reg <= 7; matrix_keydown_flag <= 1; end
						// default: matrix_keydown_flag <= 0;
					endcase
				end
				STATE2: begin
					case(col)
						4'b1110: begin key_out_reg <= 8; matrix_keydown_flag <= 1; end
						4'b1101: begin key_out_reg <= 9; matrix_keydown_flag <= 1; end
						4'b1011: begin key_out_reg <= 10; matrix_keydown_flag <= 1; end
						4'b0111: begin key_out_reg <= 11; matrix_keydown_flag <= 1; end
						// default: matrix_keydown_flag <= 0;
					endcase
				end
				STATE3: begin
					case(col)
						4'b1110: begin key_out_reg <= 12; matrix_keydown_flag <= 1; end
						4'b1101: begin key_out_reg <= 13; matrix_keydown_flag <= 1; end
						4'b1011: begin key_out_reg <= 14; matrix_keydown_flag <= 1; end
						4'b0111: begin key_out_reg <= 15; matrix_keydown_flag <= 1; end
						// default: matrix_keydown_flag <= 0;
					endcase
				end
				default: begin key_out_reg <= key_out_reg; matrix_keydown_flag <= 0; end
			endcase
		end
		else begin
			key_out_reg <= key_out_reg; 
			matrix_keydown_flag <= matrix_keydown_flag;
		end
	end
 
endmodule