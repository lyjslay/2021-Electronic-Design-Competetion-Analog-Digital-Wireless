`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/06 23:39:59
// Design Name: 
// Module Name: recv_tb
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


module recv_tb(

    );

    // reciever Parameters
    parameter PERIOD         = 10     ;
    parameter BAUD_CNT       = 25     ;
    parameter BAUD_CNT_HALF  = 12     ;
    parameter IDLE           = 4'b0001;
    parameter ANALOG         = 4'b0010;
    parameter FEATURE        = 4'b0100;
    parameter DIGITAL        = 4'b1000;

    // reciever Inputs
    reg   sys_clk                              = 0 ;
    reg   rst_n                                = 0 ;
    reg   deAM_input                           = 0 ;

    // reciever Outputs
    wire  [11:0]  recv_analog_data             ;    
    wire  recv_analog_done                     ;    
    wire  recv_digital_done                    ;    
    wire  [13:0]  recv_digital_data            ;  
    integer i;  


    initial
    begin
        forever #10  sys_clk = ~sys_clk;
    end

    initial
    begin
        sys_clk = 0;
        rst_n = 0;
        #100 rst_n  =  1;
        deAM_input = 1;
        #100

        //开始通信
        for(i=0;i<40;i=i+1)begin
            //if(i==0 || i==14 || i==20)begin
            if(i==0 ||i==13|| i==14 || i==20)begin
                deAM_input = 0;
            end
            //else if(i == 13 || i==19 || i== 35) begin
            else if(i==19 || i== 35) begin
                deAM_input = 1;
            end
            else if(i<35) begin
                deAM_input = {$random}%2;
            end
            else begin
                deAM_input = 1;
            end
            #500;//2MHz

        end

        for(i=0;i<40;i=i+1)begin
            //if(i==0 || i==14 || i==20)begin
            if(i==0 || i==14 )begin
                deAM_input = 0;
            end
            //else if(i == 13 || i==19 || i== 35) begin
            else if(i==13 || i==19 || i==20 || i== 35) begin
                deAM_input = 1;
            end
            else if(i<35) begin
                deAM_input = {$random}%2;
            end
            else begin
                deAM_input = 1;
            end
            #500;//2MHz

        end

        for(i=0;i<40;i=i+1)begin
            if(i==0 || i==14 || i==16|| i== 17|| i==20)begin
           
                deAM_input = 0;
            end
            else if(i == 13 || i==15 || i== 18 || i==19 || i== 35) begin //1001
            
                deAM_input = 1;
            end
            else if(i<35) begin
                deAM_input = {$random}%2;
            end
            else begin
                deAM_input = 1;
            end
            #500;//2MHz

        end

        for(i=0;i<40;i=i+1)begin
            if(i==0 || i==14 || i==20 || i==15 || i== 18)begin
           
                deAM_input = 0;
            end
            else if(i == 13 || i==19 || i== 35 || i==16|| i== 17) begin
            
                deAM_input = 1;
            end
            else if(i<35) begin
                deAM_input = {$random}%2;
            end
            else begin
                deAM_input = 1;
            end
            #500;//2MHz

        end


        for(i=0;i<40;i=i+1)begin
            if(i==0 || i==14 || i==16|| i== 17|| i==20)begin
           
                deAM_input = 0;
            end
            else if(i == 13 || i==15 || i== 18 || i==19 || i== 35) begin //1001
            
                deAM_input = 1;
            end
            else if(i<35) begin
                deAM_input = {$random}%2;
            end
            else begin
                deAM_input = 1;
            end
            #500;//2MHz

        end

        

    end



    reciever u_reciever (
        .sys_clk                 ( sys_clk                   ),
        .rst_n                   ( rst_n                     ),
        .deAM_input              ( deAM_input                ),

        .recv_analog_data        ( recv_analog_data   [11:0] ),
        .recv_analog_done        ( recv_analog_done          ),
        .recv_digital_done       ( recv_digital_done         ),
        .recv_digital_data       ( recv_digital_data  [13:0] )
    );


endmodule
