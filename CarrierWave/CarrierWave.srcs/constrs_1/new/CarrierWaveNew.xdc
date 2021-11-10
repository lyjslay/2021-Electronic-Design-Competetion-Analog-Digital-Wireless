set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {AD_data[0]}]
set_property PACKAGE_PIN D3 [get_ports {AD_data[11]}]
set_property PACKAGE_PIN C1 [get_ports {AD_data[10]}]
set_property PACKAGE_PIN B1 [get_ports {AD_data[9]}]
set_property PACKAGE_PIN E1 [get_ports {AD_data[8]}]
set_property PACKAGE_PIN D1 [get_ports {AD_data[7]}]
set_property PACKAGE_PIN F2 [get_ports {AD_data[6]}]
set_property PACKAGE_PIN E2 [get_ports {AD_data[5]}]
set_property PACKAGE_PIN G2 [get_ports {AD_data[3]}]
set_property PACKAGE_PIN G1 [get_ports {AD_data[4]}]
set_property PACKAGE_PIN F3 [get_ports {AD_data[2]}]
set_property PACKAGE_PIN E3 [get_ports {AD_data[1]}]
set_property PACKAGE_PIN H9 [get_ports {AD_data[0]}]
set_property PACKAGE_PIN G9 [get_ports AD_clk]
set_property IOSTANDARD LVCMOS33 [get_ports AD_clk]




set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DA_data[0]}]
set_property PACKAGE_PIN V24 [get_ports {DA_data[13]}]
set_property PACKAGE_PIN W24 [get_ports {DA_data[12]}]
set_property PACKAGE_PIN W25 [get_ports {DA_data[11]}]
set_property PACKAGE_PIN Y26 [get_ports {DA_data[10]}]
set_property PACKAGE_PIN V26 [get_ports {DA_data[9]}]
set_property PACKAGE_PIN W26 [get_ports {DA_data[8]}]
set_property PACKAGE_PIN T24 [get_ports {DA_data[7]}]
set_property PACKAGE_PIN T25 [get_ports {DA_data[6]}]
set_property PACKAGE_PIN U26 [get_ports {DA_data[5]}]
set_property PACKAGE_PIN U25 [get_ports {DA_data[4]}]
set_property PACKAGE_PIN R25 [get_ports {DA_data[3]}]
set_property PACKAGE_PIN P25 [get_ports {DA_data[2]}]
set_property PACKAGE_PIN R26 [get_ports {DA_data[1]}]
set_property PACKAGE_PIN P26 [get_ports {DA_data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports DA_clk]
set_property PACKAGE_PIN M24 [get_ports DA_clk]



# 矩阵键盘
set_property IOSTANDARD LVCMOS33 [get_ports {col[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {col[0]}]
set_property PACKAGE_PIN A22 [get_ports {col[3]}]
set_property PACKAGE_PIN A23 [get_ports {col[2]}]
set_property PACKAGE_PIN A25 [get_ports {col[1]}]
set_property PACKAGE_PIN C23 [get_ports {col[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {row[0]}]
set_property PACKAGE_PIN B22 [get_ports {row[3]}]
set_property PACKAGE_PIN A24 [get_ports {row[2]}]
set_property PACKAGE_PIN B25 [get_ports {row[1]}]
set_property PACKAGE_PIN C22 [get_ports {row[0]}]

#底板上的LED
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN J24 [get_ports {led[3]}]
set_property PACKAGE_PIN H24 [get_ports {led[2]}]
set_property PACKAGE_PIN J25 [get_ports {led[1]}]
set_property PACKAGE_PIN G25 [get_ports {led[0]}]
# 核心板上的LED
set_property IOSTANDARD LVCMOS33 [get_ports core_led]
set_property PACKAGE_PIN A19 [get_ports core_led]
# 合成的数字模拟方波
set_property IOSTANDARD LVCMOS33 [get_ports conbined_wave]
set_property PACKAGE_PIN L24 [get_ports conbined_wave]
# 数码管
set_property IOSTANDARD LVCMOS33 [get_ports sclk]
set_property PACKAGE_PIN D24 [get_ports sclk]
set_property IOSTANDARD LVCMOS33 [get_ports rclk]
set_property PACKAGE_PIN B26 [get_ports rclk]
set_property IOSTANDARD LVCMOS33 [get_ports DIO]
set_property PACKAGE_PIN B24 [get_ports DIO]
# 地板上的按键
set_property IOSTANDARD LVCMOS33 [get_ports {key_input[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_input[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_input[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_input[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_input[0]}]
set_property PACKAGE_PIN U25 [get_ports {key_input[4]}]
set_property PACKAGE_PIN R25 [get_ports {key_input[3]}]
set_property PACKAGE_PIN P25 [get_ports {key_input[2]}]
set_property PACKAGE_PIN R26 [get_ports {key_input[1]}]
set_property PACKAGE_PIN P26 [get_ports {key_input[0]}]





set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN D18 [get_ports sys_clk]
set_property PACKAGE_PIN B20 [get_ports rst_n]


create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]

set_property PULLUP true [get_ports {col[3]}]
set_property PULLUP true [get_ports {col[2]}]
set_property PULLUP true [get_ports {col[1]}]
set_property PULLUP true [get_ports {col[0]}]