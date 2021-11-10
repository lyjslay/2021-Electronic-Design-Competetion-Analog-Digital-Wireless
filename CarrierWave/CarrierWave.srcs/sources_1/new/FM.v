`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JLUEE
// Engineer: lyjslay
// 
// Create Date: 2021/11/04 16:00:35
// Design Name: 
// Module Name: FM
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


module AM(
    input sys_clk,
    input rst_n,
    input dds_clk_125m,
    input AD_sync_done,//AD采样完成信号(一个sys_clk的脉冲),获取要发送的幅度
    input [11:0] AD_data,//输入的AD采样的幅度
    input digital_sig_ok,//是否有数字信号输入,输入时一直保持为高
    input [13:0] digital_sig, //输入的数字量0-9999
    input [4:0] key_input,

    output [13:0] FM_wave, //发给DAC
    output conbined_wave
    );






    /*
    -----------------------------------------------------------------------------------------
    ** 按键设置载波频率
    -----------------------------------------------------------------------------------------
    */
    wire key_down_flag;
    wire [4:0] key_out;
    key_det  u_key_det (
        .sys_clk                 ( sys_clk        ),
        .rst_n                   ( rst_n          ),
        .key_input               ( key_input      ),

        .key_out                 ( key_out        ),
        .keydown_flag            ( key_down_flag   )
    );
    reg [23:0] freq_config_reg;
    reg [4:0] key_reg;
    parameter UP_DOWN_100K = 134218;//加减0.1MHz的控制字变化
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            key_reg <= 5'd0;
            freq_config_reg <= 3355443;//当前设置的载波频率,默认25MHz 25000000/7.45058
        end
        else if(key_down_flag) begin
            key_reg <= key_out;
            case(key_out)
                5'b11110: freq_config_reg <= 3355443;//25M
                5'b11101: freq_config_reg <= 3221226;//24M
                5'b11011: freq_config_reg <= 3489661;//26M
                5'b10111: freq_config_reg <= freq_config_reg - UP_DOWN_100K;
                5'b01111: freq_config_reg <= freq_config_reg + UP_DOWN_100K;
                default: freq_config_reg <= freq_config_reg;
            endcase
        end
        else begin
            key_reg <= key_reg;
            freq_config_reg <= freq_config_reg;
        end
    end
    


    



    //产生波特率
    reg [7:0] baud_cnt;    
    parameter SYS_CLK_FREQ = 50_000_000;
    parameter BAUD_RATE = 2_000_000;
    parameter BAUD_CNT = SYS_CLK_FREQ / BAUD_RATE; // 50M/2M = 25
    parameter BAUD_CNT_HALF = BAUD_CNT / 2;
    reg transmit_sig;//变更频率的标志,计数到一半时变更
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            baud_cnt <= 0;
            transmit_sig <= 0;
        end
        else begin
            if(AD_sync_done) begin //采集到新的模拟值,重新开始发送新的数据包
                baud_cnt <= 0;
                transmit_sig <= 0;
            end
            else if(baud_cnt == BAUD_CNT - 1) begin//计完一个波特率,bit_num+1,并更新刚才寄存的频率
                baud_cnt <= 0;
                transmit_sig <= 0;
            end
            else if(baud_cnt == BAUD_CNT_HALF - 1) begin //寄到一半波特率,开始改变频率的值并寄存
                baud_cnt <= baud_cnt + 8'd1;
                transmit_sig <= 1;
            end
            else begin
                baud_cnt <= baud_cnt + 8'd1;
                transmit_sig <= 0;
            end
        end
    end



    /*
    -----------------------------------------------------------------------------------------
    ** 控制AM的状态机,依次发送模拟量、特征码、数字量
    ** 流程: 
    ** IDLE:设置数据包,发送01对应不同的频率,设置DDS频率控制字(24bit)即可
    **      [29:16]为14bit数字量,对应FM频率     
    **      [15:12]为校验码
    **      [11:0]为模拟信号幅值 
    ** ANALOG/FEATURE/DIGITAL: 每次半波特计完,【计发送的bit】和【设置combined_wave】,记满之后拉高停止位跳转状态
    ** 说明: 
        1. AD采样率设为50kHz(信号最高为10k),即10k(100us)更新一次数据包
        2. 发送数据的波特率设置为2MHz,两次更新之间可发送40bit
        3. 一个波特之间包含25M(26M等三个频率)/2M = 12个周期的载波
    -----------------------------------------------------------------------------------------
    */
    parameter IDLE = 4'b0001; //空闲状态,一直发高
    parameter ANALOG = 4'b0010; //发送模拟
    parameter FEATURE = 4'b0100; //发送特征码
    parameter DIGITAL = 4'b1000; //发送数字
    reg [29:0] send_data_package;//包含数字信号、模拟信号和特征码的数据包
    reg [2:0] transmit_state;
    reg conbined_wave_reg;
    reg [3:0] analog_cnt;
    reg analog_done_reg;
    reg [3:0] digital_cnt;
    reg digital_done_reg;
    reg [2:0] feature_cnt; 
    reg feature_done_reg;
    assign conbined_wave = conbined_wave_reg;
    always@(posedge sys_clk) begin
        if(!rst_n)begin
            transmit_state <= IDLE;
            analog_cnt <= 0;
            feature_cnt <= 0;
            digital_cnt <= 0;
            analog_done_reg <= 0;
            digital_done_reg <= 0;
            feature_done_reg <= 0;
            conbined_wave_reg <= 1;

        end
        else begin
            case(transmit_state)
                IDLE:begin
                    if(AD_sync_done) begin 
                        transmit_state <= ANALOG; //ad同步完数据,进入发送状态
                        conbined_wave_reg <= 1; //IDLE时一直发送高
                        //同步DA数据并合成数据包
                        if(digital_sig_ok) begin //发送数字信号
                            send_data_package <= {digital_sig,4'b1001,AD_data};
                        end
                        else begin //不发送数字信号
                            send_data_package <= {14'h3fff,4'b0110,AD_data};
                        end
                    end
                    else begin
                        transmit_state <= IDLE;
                        conbined_wave_reg <= 1;
                    end
                end
                ANALOG:begin
                    if(transmit_sig) begin //每个波特率中间记忆次数,设置数据
                        if(analog_cnt == 13) analog_cnt <= 0;
                        else analog_cnt <= analog_cnt + 1;
                        case(analog_cnt) //与上边的if-else并行,因此从0开始
                            0: conbined_wave_reg = 0; //起始位
                            1: conbined_wave_reg = send_data_package[0];
                            2: conbined_wave_reg = send_data_package[1];
                            3: conbined_wave_reg = send_data_package[2];
                            4: conbined_wave_reg = send_data_package[3];
                            5: conbined_wave_reg = send_data_package[4];
                            6: conbined_wave_reg = send_data_package[5];
                            7: conbined_wave_reg = send_data_package[6];
                            8: conbined_wave_reg = send_data_package[7];
                            9: conbined_wave_reg = send_data_package[8];
                            10: conbined_wave_reg = send_data_package[9];
                            11: conbined_wave_reg = send_data_package[10];
                            12: begin //设置模拟发送完成脉冲
                                conbined_wave_reg = send_data_package[11];
                                analog_done_reg <= 1;
                            end
                            13: begin
                                conbined_wave_reg = 1; //停止位
                                transmit_state <= FEATURE;
                                analog_done_reg <= 0;
                            end
                        endcase
                    end  
                end
                FEATURE:begin
                    if(transmit_sig) begin
                        if(feature_cnt == 5) feature_cnt <= 0;
                        else feature_cnt <= feature_cnt + 1;
                        case(feature_cnt)
                            0: conbined_wave_reg <= 0; //起始位
                            1: conbined_wave_reg <= send_data_package[12];
                            2: conbined_wave_reg <= send_data_package[13];
                            3: conbined_wave_reg <= send_data_package[14];
                            4: begin 
                                conbined_wave_reg <= send_data_package[15]; 
                                feature_done_reg <= 1; 
                            end
                            5: begin 
                                conbined_wave_reg <= 1;//停止位
                                transmit_state <= DIGITAL;
                                feature_done_reg <= 0;
                            end
                        endcase
                    end     
                end
                DIGITAL:begin
                    if(transmit_sig) begin
                        if(digital_cnt == 15) digital_cnt <= 0;
                        else digital_cnt <= digital_cnt + 1;
                        case(digital_cnt)
                            0: conbined_wave_reg <= 0; //起始位
                            1: conbined_wave_reg <= send_data_package[16];
                            2: conbined_wave_reg <= send_data_package[17];
                            3: conbined_wave_reg <= send_data_package[18];
                            4: conbined_wave_reg <= send_data_package[19];
                            5: conbined_wave_reg <= send_data_package[20];
                            6: conbined_wave_reg <= send_data_package[21];
                            7: conbined_wave_reg <= send_data_package[22];
                            8: conbined_wave_reg <= send_data_package[23];
                            9: conbined_wave_reg <= send_data_package[24];
                            10: conbined_wave_reg <= send_data_package[25];
                            11: conbined_wave_reg <= send_data_package[26];
                            12: conbined_wave_reg <= send_data_package[27];
                            13: conbined_wave_reg <= send_data_package[28];
                            14: begin
                                conbined_wave_reg <= send_data_package[29];
                                digital_done_reg <= 1;
                            end
                            15: begin
                                conbined_wave_reg = 1; //停止位
                                transmit_state <= IDLE;
                                digital_done_reg <= 0;
                            end
                        endcase
                    end      
                end
            endcase
        end
    end
    




    wire m_axis_data_tvalid;
    wire [15:0] m_axis_data_tdata;
    wire [13:0] sin_data = m_axis_data_tdata[13:0] + 14'h2000;
    assign FM_wave = (conbined_wave_reg == 1) ? (sin_data) : (14'd8192); //转为无符号数发给DA
    dds_compiler_0 your_instance_name (
        .aclk(dds_clk_125m),                                // input wire aclk
        .s_axis_phase_tvalid(rst_n),  // input wire s_axis_phase_tvalid
        .s_axis_phase_tdata(freq_config_reg),    // input wire [23 : 0] s_axis_phase_tdata
        .m_axis_data_tvalid(m_axis_data_tvalid),    // output wire m_axis_data_tvalid
        .m_axis_data_tdata(m_axis_data_tdata)      // output wire [15 : 0] m_axis_data_tdata
    );








endmodule
