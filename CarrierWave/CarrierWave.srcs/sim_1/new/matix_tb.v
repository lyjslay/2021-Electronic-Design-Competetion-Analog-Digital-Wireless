`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 11:25:45
// Design Name: 
// Module Name: matix_tb
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


module matix_tb(

    );


    // matrix_key Inputs
    reg   sys_clk                              = 0 ;
    reg   rst_n                                = 0 ;
    reg   [3:0]  col                           = 0 ;

    // matrix_key Outputs
    wire  [3:0]  row                           ;
    wire  [3:0]  key_value                      ;
    wire key_flag;


    initial
    begin
        forever #10  sys_clk = ~sys_clk;
    end

    initial
    begin
        sys_clk = 0;
        rst_n = 0;
        col = 4'b1110;
        #100;
        rst_n = 1;
        col =4'b1110;
        #200000000;
       col = 4'b1011;
        #200000000;
        col = 4'b0111;

    end

    matrix_key u_matrix_key (
        .sys_clk                 ( sys_clk   ),
        .rst_n                   ( rst_n     ),
        .col                     ( col       ),

        .row                     ( row       ),
        .key_out                 ( key_value   )
    );


endmodule
