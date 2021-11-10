`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/04 20:02:12
// Design Name: 
// Module Name: Transmit_tb
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


module Transmit_tb();




    

    

    reg   [4:0]  key_input;
    reg   [3:0]  col; 
    reg sys_clk;
    reg rst_n;     

    // Transmit_top Outputs
    reg [11:0] AD_data;
    wire  AD_clk;
    wire  [13:0]  DA_data; 
    wire  conbined_wave;   
    wire  DA_clk;
    wire  sclk;
    wire  rclk;
    wire  DIO;
    wire  [3:0]  row;
    wire  [3:0]  led;
    wire  core_led;

    Transmit_top #(
        .CNT_500MS ( 25000000 ))
    u_Transmit_top (
        .sys_clk                 ( sys_clk         ),
        .rst_n                   ( rst_n           ),
        .AD_data                 ( AD_data         ),
        .key_input               ( key_input       ),
        .col                     ( col             ),

        .AD_clk                  ( AD_clk          ),
        .DA_data                 ( DA_data         ),
        .conbined_wave           ( conbined_wave   ),
        .DA_clk                  ( DA_clk          ),
        .sclk                    ( sclk            ),
        .rclk                    ( rclk            ),
        .DIO                     ( DIO             ),
        .row                     ( row             ),
        .led                     ( led             ),
        .core_led                ( core_led        )
    );
    
    initial
    begin
        forever #10  sys_clk = ~sys_clk;
    end

    always #20000 AD_data = (AD_data<512)?(AD_data*2):1;
    
    initial
    begin
        AD_data = 0;
        sys_clk = 0;
        rst_n = 0;
        key_input = 5'b11111;
        # 100;
        rst_n = 1;
        # 1000;
        key_input = 5'b11101;
        #100000000   ;
        key_input = 5'b11111;

    end




endmodule
