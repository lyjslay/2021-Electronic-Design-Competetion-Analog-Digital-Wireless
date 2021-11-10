`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay/liuyi1918@mails.jlu.edu.cn
// 
// Create Date: 2021/11/06 08:46:16
// Design Name: 
// Module Name: reciever
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


module reciever(
    input sys_clk,
    input rst_n,
    input deAM_input,//输入的比较器出来的方波(2Mhz的比特率,相当于串口的数据)
    output [11:0] recv_analog_data,//接收到的数字量
    output recv_analog_done,
    output recv_digital_done,
    output [13:0] recv_digital_data,
    output shutdown_sig
);


    /*
    **检测解调后的方波的的下降沿(起始位)作为开始的信号
    */
    reg [1:0] start_reg1;//打两排消除亚瓦讷太
    reg [1:0] start_reg2;//2'b10时说明检测到下降沿
    //下降沿的标志,即接受开始的标志,一个周期的脉冲
    //*******虽然该信号在数据传输过程中也会产生,但因为由于状态机的限制,接收过程的下降沿不在IDLE状态,因此可视为无效
    wire recv_start;
    assign recv_start = (start_reg2 == 2'b10) ? 1'b1 : 1'b0;   
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            start_reg1 <= 2'b0;
            start_reg2 <= 2'b0;
        end
        else begin
            start_reg1 <= {start_reg1[0], deAM_input};
            start_reg2 <= {start_reg2[0],start_reg1[1]};
        end
    end


    /*
    **计数产生波特率
    */
    reg [12:0] baud_cnt;
    reg recv_flag;//发送数据的标志信号,在波特率计数到一半时采样
    reg [7:0] deAM_high_cnt;//存储半个波特率期间采集到高电平的数量
    reg high_valid0; //采集到的高电平是否有效(根据计数来算),低电平较稳定无需验证,与recv_flag相同是脉冲信号
    //reg high_valid1; //0前半段1后半段
    parameter BAUD_CNT = 25; // 50M/2M = 5208
    parameter BAUD_CNT_HALF = 12;
    
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            recv_flag <= 0;
            baud_cnt <= 0;
            deAM_high_cnt <= 0;
            high_valid0 <= 0;
            //high_valid1 <= 0;
        end
        else if(recv_start) begin //检测到起始位下降沿清零重新开始波特率
            baud_cnt <= 0;
            recv_flag <= 0;
            high_valid0 <= 0;
            //high_valid1 <= 0;
            deAM_high_cnt <= 0;
        end
        else if(baud_cnt == BAUD_CNT - 1) begin
            recv_flag <= 0;
            baud_cnt <= 0;
            high_valid0 <= 0;
            // if(deAM_high_cnt > 12) begin//总的大于一半
            //     high_valid1 <= 1;
            // end
        end
        else if(baud_cnt == BAUD_CNT_HALF) begin //波特率记到一半时最稳定,设置接收标志,下个周期同步数据
            recv_flag <= 1;
            baud_cnt <= baud_cnt + 13'd1;
            if(deAM_high_cnt > 6) begin //半个波特率能采12次,大于一半就认为高电平可靠
                high_valid0 <= 1;
                deAM_high_cnt <= 0;//确定为高,计数清零
            end
        end
        else begin
            recv_flag <= 0;
            baud_cnt <= baud_cnt + 13'd1;
            if(deAM_input == 1 && baud_cnt < BAUD_CNT_HALF) begin
                deAM_high_cnt <= deAM_high_cnt + 1;
            end
            else begin
                high_valid0 <= 0;
                deAM_high_cnt <= deAM_high_cnt;
            end
        end
    end


    reg [11:0] analog_data_reg_tmp;//接收到的数据
    reg [13:0] digital_data_reg_tmp;
    reg [3:0] feature_data_reg_tmp;
    reg [11:0] analog_data_reg;
    reg [13:0] digital_data_reg;
    reg [3:0] feature_data_reg;
    reg analog_done_reg;
    reg digital_done_reg;
    assign recv_analog_data = analog_data_reg;
    assign recv_digital_data = digital_data_reg;
    assign recv_analog_done = analog_done_reg;
    assign recv_digital_done = digital_done_reg;

    reg [3:0] recv_state;
    reg [3:0] analog_cnt;
    reg [3:0] digital_cnt;
    reg [2:0] feature_cnt;
    reg [7:0] total_cnt; //收到数据的总数,用于区分数据包
    reg with_digital_reg; //有数字信号,在feature状态中设置
    reg shutdown_sig_reg;
    assign shutdown_sig = shutdown_sig_reg;
    reg error;//出错的标志,出错后一直在IDLE,直到total_cnt计够后,下一帧数据起始位到来,才清除
 
    parameter IDLE = 4'b0001; 
    parameter ANALOG = 4'b0010;
    parameter FEATURE = 4'b0100;
    parameter DIGITAL = 4'b1000;
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            recv_state <= IDLE;
            analog_data_reg_tmp <= 12'd0;
            digital_data_reg_tmp <= 14'd0;
            feature_data_reg_tmp <= 4'd0;
            analog_data_reg <= 12'd2048;//0v
            digital_data_reg <= 14'h3fff;
            feature_data_reg <= 4'd0;
            with_digital_reg <= 0;
            analog_done_reg <= 0;
            digital_done_reg <= 0;
            analog_cnt <= 0;
            feature_cnt <= 0;
            digital_cnt <= 0;
            total_cnt <= 0;
            error <= 0;
            shutdown_sig_reg <= 0;
        end
        else begin
            case(recv_state)
                IDLE: begin
                    analog_data_reg_tmp <= 12'd0;
                    digital_data_reg_tmp <= 14'd0;
                    feature_data_reg_tmp <= 4'd0;
                    with_digital_reg <= 0;
                    digital_done_reg <= 0;
                    analog_done_reg <= 0;
                    analog_cnt <= 0;//一定要清零计数器,否则再次进去就不对了
                    digital_cnt <= 0;
                    feature_cnt <= 0;
                    if(error) begin //如果该帧数据有错
                        if(recv_flag) total_cnt <= total_cnt + 1; //在所有的状态中一直计数,直到total_cnt > 36以后且接收到新的起始位(recv_start)就认为是新的一帧数据
                        else begin
                            if(total_cnt > 36 && recv_start) begin //等待新的一帧到来
                                recv_state <= ANALOG;//检测到下降沿
                                error <= 0;
                                // total_cnt <= 0; //这里先不清零,等待新的一帧收到recv_flag到来后在清零,即为第0位,否则会窜
                            end
                            else begin //否则一直在IDLE里
                                recv_state <= IDLE;
                            end
                        end
                    end
                    else begin //如果没错,状态机正常运行
                        if(recv_start) recv_state <= ANALOG;
                        else recv_state <= IDLE;
                    end      
                end
                ANALOG: begin
                    analog_done_reg <= 0;
                    digital_done_reg <= 0;
                    if(recv_flag) begin
                        if(analog_cnt == 13) begin analog_cnt <= 0; total_cnt <= total_cnt + 1; end
                        else if(total_cnt > 36) begin analog_cnt <= analog_cnt + 1; total_cnt <= 0; end
                        else  begin analog_cnt <= analog_cnt + 1; total_cnt <= total_cnt + 1; end
                        case(analog_cnt)
                            0: begin //起始位,如果不是0就出错了
                                if(deAM_input != 0) begin 
                                    recv_state <= IDLE;//
                                    error <= 1;
                                end
                            end
                            1: analog_data_reg_tmp[0] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            2: analog_data_reg_tmp[1] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            3: analog_data_reg_tmp[2] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            4: analog_data_reg_tmp[3] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            5: analog_data_reg_tmp[4] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            6: analog_data_reg_tmp[5] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            7: analog_data_reg_tmp[6] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            8: analog_data_reg_tmp[7] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            9: analog_data_reg_tmp[8] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            10: analog_data_reg_tmp[9] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            11: analog_data_reg_tmp[10] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            12: analog_data_reg_tmp[11] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            13: begin //停止位
                                if(high_valid0 == 1) begin 
                                    recv_state <= FEATURE;
                                    analog_data_reg <= analog_data_reg_tmp;
                                    analog_done_reg <= 1;
                                end
                                else begin
                                    recv_state <= IDLE;
                                    error <= 1;
                                    analog_data_reg <= 12'd2048; //0V
                                end
                            end
                        endcase
                    end     
                end
                FEATURE: begin
                    digital_done_reg <= 0;
                    analog_done_reg <= 0;
                    if(recv_flag) begin
                        if(feature_cnt == 5) begin feature_cnt <= 0; total_cnt <= total_cnt + 1; end
                        else begin feature_cnt <= feature_cnt + 1; total_cnt <= total_cnt + 1; end
                        case(feature_cnt)
                            0: begin //起始位,如果不是0就出错了
                                if(deAM_input != 0) begin
                                    recv_state <= IDLE;
                                    error <= 1;
                                end   
                            end
                            1: feature_data_reg_tmp[0] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            2: feature_data_reg_tmp[1] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            3: feature_data_reg_tmp[2] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            4: feature_data_reg_tmp[3] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            5: begin
                                if(high_valid0 == 1) begin //停止位是1,有效
                                    recv_state <= DIGITAL;
                                    feature_data_reg <= feature_data_reg_tmp; //寄存数据
                                    case(feature_data_reg_tmp)
                                        4'b1001: begin with_digital_reg <= 1; shutdown_sig_reg <= 0; end
                                        4'b0110: begin with_digital_reg <= 0; shutdown_sig_reg <= 1; end //没有数字信号一直保持高
                                        default: begin shutdown_sig_reg <= 1; shutdown_sig_reg <= 0; error <= 1; end//默认出错
                                    endcase
                                end
                                else begin //停止位不是1出错了
                                    recv_state <= IDLE;
                                    error <= 1;
                                    feature_data_reg <= 4'b0000;
                                end
                            end
                        endcase
                    end
                end
                DIGITAL: begin
                    analog_done_reg <= 0;
                    digital_done_reg <= 0;
                    if(recv_flag) begin
                        if(digital_cnt == 15) begin digital_cnt <= 0; total_cnt <= total_cnt + 1; end
                        else begin digital_cnt <= digital_cnt + 1; total_cnt <= total_cnt + 1; end
                        case(digital_cnt)
                            0: begin
                                if(deAM_input != 0) begin
                                    recv_state <= IDLE;
                                    error <= 1;
                                end   
                            end
                            1: digital_data_reg_tmp[0] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            2: digital_data_reg_tmp[1] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            3: digital_data_reg_tmp[2] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            4: digital_data_reg_tmp[3] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            5: digital_data_reg_tmp[4] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            6: digital_data_reg_tmp[5] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            7: digital_data_reg_tmp[6] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            8: digital_data_reg_tmp[7] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            9: digital_data_reg_tmp[8] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            10: digital_data_reg_tmp[9] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            11: digital_data_reg_tmp[10] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            12: digital_data_reg_tmp[11] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            13: digital_data_reg_tmp[12] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            14: digital_data_reg_tmp[13] <= (deAM_input == 1 && high_valid0 == 1) ? 1 : 0;
                            15: begin
                                recv_state <= IDLE;
                                if(high_valid0 == 1) begin //停止位是1,有效
                                    digital_data_reg <= (with_digital_reg) ? digital_data_reg_tmp : 14'h3fff; //寄存数据
                                    digital_done_reg <= 1;
                                end
                                else begin
                                    digital_data_reg <= 14'h3fff;
                                    error <= 1;
                                end
                            end
                        endcase
                    end
                end
            endcase
        end
    end




    


     

endmodule
