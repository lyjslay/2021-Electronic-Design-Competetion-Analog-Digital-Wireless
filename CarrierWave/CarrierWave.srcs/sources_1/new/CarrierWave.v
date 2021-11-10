`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/04 10:01:11
// Design Name: 
// Module Name: CarrierWave
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


module CarrierWave(
    input DA_clk_125m,
    input sys_clk,
    input rst_n,
    input pll_locked,
    input freq_change,//选择20M,24M,28M
    output [13:0] sin_data
);


    reg [1:0] freq_switch;//0:20M,1:24M,2:28M
    wire [15:0] freq_config_data;
    parameter DDS_20M = 10487;
    parameter DDS_24M = 12585;
    parameter DDS_28M = 14683;
    assign freq_config_data = (freq_switch == 0) ? DDS_20M : 
                              (freq_switch == 1) ? DDS_24M : 
                              (freq_switch == 2) ? DDS_28M : DDS_20M;
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            freq_switch <= 2'd0;
        end
        else if(freq_change == 1) begin
            case(freq_switch)
                0: freq_switch <= 1;
                1: freq_switch <= 2;
                2: freq_switch <= 0;
                default: freq_switch <= 0;
            endcase
        end
        else begin
            freq_switch <= freq_switch;
        end
    end


    
    wire [15:0] m_axis_data_tdata;
    wire  m_axis_data_tvalid;

    assign sin_data = m_axis_data_tdata[13:0] + 14'h2000;
    dds_compiler_0 your_instance_name (
        .aclk(DA_clk_125m),                                  // input wire aclk
        .s_axis_config_tvalid(rst_n),  // input wire s_axis_config_tvalid
        .s_axis_config_tdata(freq_config_data),    // input wire [15 : 0] s_axis_config_tdata
        .m_axis_data_tvalid(m_axis_data_tvalid),      // output wire m_axis_data_tvalid
        .m_axis_data_tdata(m_axis_data_tdata)        // output wire [15 : 0] m_axis_data_tdata
    );



endmodule
