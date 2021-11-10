`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/05 13:39:20
// Design Name: 
// Module Name: keyarray_tb
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


module keyarray_tb(

    );



    // matrix_key Inputs
    reg   sys_clk                              = 0 ;
    reg   rst_n                                = 0 ;
    reg   [3:0]  col                           = 0 ;

    // matrix_key Outputs
    wire  [3:0]  row                           ;
    wire  [3:0]  key_out                       ;
    wire  matrix_down_flag                     ;


    initial
    begin
        forever #10  sys_clk = ~sys_clk;
    end
    always @(row) begin
        case(row)
            4'b1110: col = 4'b1110;
            4'b1101: col = 4'b1111;
            4'b1011: col = 4'b1111;
            4'b0111: col = 4'b1111;
        endcase
        #200000000;
    end


    initial
    begin
        sys_clk = 0;
        rst_n = 0;
        #100 rst_n = 1;

    end

    matrix_key u_matrix_key (
        .sys_clk                 ( sys_clk                 ),
        .rst_n                   ( rst_n                   ),
        .col                     ( col               [3:0] ),

        .row                     ( row               [3:0] ),
        .key_out                 ( key_out           [3:0] ),
        .matrix_down_flag        ( matrix_down_flag        )
    );


endmodule
