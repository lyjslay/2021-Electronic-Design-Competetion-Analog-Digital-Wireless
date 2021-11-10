`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/07 00:18:26
// Design Name: 
// Module Name: led_tb
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


module led_tb(

    );
    // seg_led Inputs
    reg   sys_clk                              = 0 ;
    reg   rst_n                                = 0 ;
    reg   [3:0]  bit0                          = 0 ;
    reg   [3:0]  bit1                          = 0 ;
    reg   [3:0]  bit2                          = 0 ;
    reg   [3:0]  bit3                          = 0 ;
    reg   ok_sig                               = 0 ;
    reg   stop_sig                             = 0 ;

    // seg_led Outputs
    wire  sclk                                 ;
    wire  rclk                                 ;
    wire  DIO                                  ;


    initial
    begin
        forever #10  sys_clk = ~sys_clk;
    end

    initial
    begin
        sys_clk = 0;
        rst_n = 0;
        #100 rst_n  =  1;
        bit0 = 1;
        bit1 = 2;
        bit2 = 3;
        bit3 = 4;
        ok_sig = 1;
        #20;
        ok_sig = 0;
        
        # 10000000;
        bit0 = 2;
        bit1 = 3;
        bit2 = 3;
        bit3 = 3;
        ok_sig = 1;
        #20;
        ok_sig = 0;
    end

    seg_led u_seg_led (
        .sys_clk                 ( sys_clk         ),
        .rst_n                   ( rst_n           ),
        .bit0                    ( bit0      [3:0] ),
        .bit1                    ( bit1      [3:0] ),
        .bit2                    ( bit2      [3:0] ),
        .bit3                    ( bit3      [3:0] ),
        .ok_sig                  ( ok_sig          ),
        .stop_sig                ( stop_sig        ),

        .sclk                    ( sclk            ),
        .rclk                    ( rclk            ),
        .DIO                     ( DIO             )
    );

    initial
    begin

        $finish;
    end
endmodule
