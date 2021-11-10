`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/06 22:38:55
// Design Name: 
// Module Name: bin2BCD
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


module bin2bcd(
    input sys_clk, 
    input rst_n,
    input start,
    input [13:0] bin,
    output [15:0] bcd,
    output valid
);
    
    reg [13:0] bin_in;
    reg op;
    reg [3:0] bit_cnt;

    always @(posedge sys_clk) begin
    if(!rst_n)
            bin_in <= 0;
    else if(start)
        bin_in <= bin;
    end
    
    always @(posedge sys_clk) begin
        if(!rst_n)
            op <= 0;
        else if(start)
            op <= 1;
        else if(bit_cnt == 14 - 1)
            op <= 0;
    end

    always @(posedge sys_clk) begin
        if(!rst_n)
            bit_cnt <= 0;
        else if(op)
            bit_cnt <= bit_cnt + 1'b1;
        else
            bit_cnt <= 0;
    end


    reg [15:0] bcd_reg;
    assign bcd = bcd_reg;
    always @(posedge sys_clk) begin
        if(!rst_n)
            bcd_reg <= 0;
        else if(op) begin
            bcd_reg[0] <= bin_in[13-bit_cnt];
            bcd_reg[4:1] <= (bcd[3:0] > 4) ? bcd[3:0] + 4'd3 : bcd[3:0];
            bcd_reg[8:5] <= (bcd[7:4] > 4) ? bcd[7:4] + 4'd3 : bcd[7:4];
            bcd_reg[12:9] <= (bcd[12:8] > 4) ? bcd[12:8] + 4'd3 : bcd[12:8];
            bcd_reg[15:13] <= (bcd[15:12] > 4) ? bcd[15:12] + 4'd3 : bcd[15:12];
          end
        else
            bcd_reg <= 0;
    end

    reg valid_reg;
    assign valid = valid_reg;
    always @(posedge sys_clk) begin
    if(!rst_n)
        valid_reg <= 0;
    else if(bit_cnt == 13 - 1)
        valid_reg <= 1;
    else
        valid_reg <= 0;    
    end



endmodule



