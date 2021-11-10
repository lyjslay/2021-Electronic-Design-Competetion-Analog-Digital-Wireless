`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/04 10:08:05
// Design Name: 
// Module Name: clk_gen
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


module clk_gen(
    input sys_clk,
    input rst_n,
    output clk_125m,
    output pll_locked
);

    assign clk_125m = clk_out1;
      clk_wiz_0 pll_clk_gen(
        // Clock out ports
        .clk_out1(clk_out1),     // output clk_out1
        // Status and control signals
        .reset(~rst_n), // input reset
        .locked(pll_locked),       // output locked
    // Clock in ports
        .clk_in1(sys_clk)// input clk_in1
    );      
endmodule
