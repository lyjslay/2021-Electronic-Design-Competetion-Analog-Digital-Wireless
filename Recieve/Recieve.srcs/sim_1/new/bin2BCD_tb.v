`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/06 23:29:16
// Design Name: 
// Module Name: bin2BCD_tb
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


module bin2BCD_tb(

    );
// bin2bcd Inputs
reg   sys_clk                              = 0 ;
reg   rst_n                                = 0 ;
reg   start                                = 0 ;
reg   [13:0]  bin                          = 0 ;

// bin2bcd Outputs
wire  [15:0]  bcd                          ;    
wire  valid                                ;


initial
begin
    forever #10  sys_clk = ~sys_clk;
end



bin2bcd  u_bin2bcd (
    .sys_clk                 ( sys_clk         ),
    .rst_n                   ( rst_n           ),
    .start                   ( start           ),
    .bin                     ( bin      [13:0] ),

    .bcd                     ( bcd      [15:0] ),
    .valid                   ( valid           )
);


    initial
    begin
    sys_clk = 0;
    rst_n = 0;
    #100 rst_n = 1;
    bin = 14'b01010101010101;
    start = 1;
    #20;
    start = 0;
    #1000
    bin = 14'b10000010010101;
    start = 1;
    #20;
    start = 0;
    #1000
    bin = 14'd1234;
    start = 1;
    #20;
    start = 0;
    end

endmodule
