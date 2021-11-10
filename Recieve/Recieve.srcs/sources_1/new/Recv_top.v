`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/06 22:33:47
// Design Name: 
// Module Name: Recv_top
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


module Recv_top(
    input sys_clk,
    input rst_n,
    input deAM_input,
    //数码管
    output sclk,
    output rclk,
    output DIO,
    //DA
    output DA_clk,
    output [13:0] DA_data

);


    /*
    -----------------------------------------------------------------------------------------
    ** 接收端解码解调信号
    -----------------------------------------------------------------------------------------
    */
    wire  [11:0]  recv_analog_data;
    wire  recv_analog_done;
    wire  recv_digital_done;
    wire  [13:0]  recv_digital_data;
    wire  shutdown_sig;

    reciever u_reciever (
        .sys_clk                 ( sys_clk             ),
        .rst_n                   ( rst_n               ),
        .deAM_input              ( deAM_input          ),

        .recv_analog_data        ( recv_analog_data    ),
        .recv_analog_done        ( recv_analog_done    ),
        .recv_digital_done       ( recv_digital_done   ),
        .recv_digital_data       ( recv_digital_data   ),
        .shutdown_sig            ( shutdown_sig        )        
    );

    /*
    -----------------------------------------------------------------------------------------
    **二进制转bcd
    -----------------------------------------------------------------------------------------
    */

    reg  [3:0]  seg_bit0;
    reg  [3:0]  seg_bit1;
    reg  [3:0]  seg_bit2;
    reg  [3:0]  seg_bit3;
    // assign seg_bit00 = 1;
    // assign seg_bit10 = 2;
    // assign seg_bit20 = 3;
    // assign seg_bit30 = 4;
    wire [13:0] recv_digital_data1;
    assign recv_digital_data1 = 1234;


    wire  [15:0]  bcd;
    wire  valid;

    bin2bcd  u_bin2bcd (
        .sys_clk                 ( sys_clk   ),
        .rst_n                   ( rst_n     ),
        .start                   ( recv_digital_done     ),
        .bin                     ( recv_digital_data1       ),

        .bcd                     ( bcd       ),
        .valid                   ( valid     )
    );
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            seg_bit0 <= 2;
            seg_bit1 <= 3;
            seg_bit2 <= 4;
            seg_bit3 <= 5;
        end
        else if(valid) begin
            seg_bit0 <= bcd[3:0];
            seg_bit1 <= bcd[7:4];
            seg_bit2 <= bcd[11:8];
            seg_bit3 <= bcd[15:12];
        end
        else begin
            seg_bit0 <= seg_bit0;
            seg_bit1 <= seg_bit1;
            seg_bit2 <= seg_bit2;
            seg_bit3 <= seg_bit3;
        end
    end

    /*
    -----------------------------------------------------------------------------------------
    ** 数码管模块
    -----------------------------------------------------------------------------------------
    */
    seg_led u_seg_led (
        .sys_clk                 ( sys_clk    ),
        .rst_n                   ( rst_n      ),
        .bit0                    ( seg_bit0       ),
        .bit1                    ( seg_bit1       ),
        .bit2                    ( seg_bit2       ),
        .bit3                    ( seg_bit3       ),
        .shutdown_sig            ( shutdown_sig   ),

        .sclk                    ( sclk       ),
        .rclk                    ( rclk       ),
        .DIO                     ( DIO        )
    );

    /*
    -----------------------------------------------------------------------------------------
    ** DA输出模块 12.5M时钟
    -----------------------------------------------------------------------------------------
    */
    reg   [13:0]  digital_sig;

    always@(posedge sys_clk) begin
        if(!rst_n)begin
            digital_sig <= 14'd8192;
        end
        else if(recv_analog_done) begin
            digital_sig <= (recv_analog_data[11:0] << 2);
        end
        else begin
            digital_sig <= digital_sig;
        end
    end

    DA_out u_DA_out (
        .digital_sig             ( digital_sig   ),
        .sys_clk                 ( sys_clk       ),
        .rst_n                   ( rst_n         ),

        .DA9764_data             ( DA_data   ),
        .DA9764_clk              ( DA_clk    )
    );



endmodule
