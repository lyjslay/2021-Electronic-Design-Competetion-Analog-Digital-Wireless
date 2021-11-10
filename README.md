# 2021-Electronic-Design-Competetion-Analog-Digital-Wireless
2021全国大学生电子设计大赛E题:数字-模拟信号混合传输收发机
# Dependece
- vivado 2018.3
- matlab r2017a
# Brief Intro
- 发送端(./CarrierWave)方案:
  - AD9226采集模拟信号,矩阵键盘输入数字信号,两路信号打包成36bit的数据包:{16bit数字量,6bit特征值,14bit模拟量}
  - 采用AM调制,通过高速DAC:DA9764发送调制信号
- 接收端(./Recieve)方案:
  - 先经过包络检波,再经过两级放大使信号达到Vpp约为2V,在经过比较器将信号转为方波
  - AD9226采集方波,解析数据,将模拟和数字信号分开并显示
