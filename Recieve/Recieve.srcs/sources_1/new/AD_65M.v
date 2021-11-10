`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/06 18:38:16
// Design Name: 
// Module Name: AD_65M
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


module AD_65M(
    input sys_clk, //65M
    input rst_n,
    input [11:0] AD9226_chanA_input,
    input [11:0] AD9226_chanB_input,
    output [11:0] AD_chanA_data,
    output [11:0] AD_chanB_data,
    output AD9226_chanA_clk,
    output AD9226_chanB_clk
    );

    assign AD9226_chanA_clk = sys_clk;
    assign AD9226_chanB_clk = sys_clk;
    reg [11:0] AD9266_chanA_reg;
    reg [11:0] AD9226_chanB_reg;
    always@(posedge sys_clk ) begin
        if(!rst_n)begin
            
        end
        else if( ) begin
            
        end
        else begin
            
        end
    end



endmodule
