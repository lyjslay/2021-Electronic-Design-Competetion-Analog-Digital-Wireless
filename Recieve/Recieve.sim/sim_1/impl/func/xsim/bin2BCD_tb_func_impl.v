// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Nov  7 10:49:18 2021
// Host        : DESKTOP-I75IHQ5 running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               F:/DianSai/2021/Recieve/Recieve/Recieve.sim/sim_1/impl/func/xsim/bin2BCD_tb_func_impl.v
// Design      : bin2BCD
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tfgg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "80380267" *) 
(* NotValidForBitStream *)
module bin2BCD
   (bincode,
    seg_bit0,
    seg_bit1,
    seg_bit2,
    seg_bit3);
  input [13:0]bincode;
  output [3:0]seg_bit0;
  output [3:0]seg_bit1;
  output [3:0]seg_bit2;
  output [3:0]seg_bit3;

  wire [3:0]seg_bit0;
  wire [3:0]seg_bit1;
  wire [3:0]seg_bit2;
  wire [3:0]seg_bit3;

  OBUFT \seg_bit0_OBUF[0]_inst 
       (.I(1'b0),
        .O(seg_bit0[0]),
        .T(1'b1));
  OBUFT \seg_bit0_OBUF[1]_inst 
       (.I(1'b0),
        .O(seg_bit0[1]),
        .T(1'b1));
  OBUFT \seg_bit0_OBUF[2]_inst 
       (.I(1'b0),
        .O(seg_bit0[2]),
        .T(1'b1));
  OBUFT \seg_bit0_OBUF[3]_inst 
       (.I(1'b0),
        .O(seg_bit0[3]),
        .T(1'b1));
  OBUFT \seg_bit1_OBUF[0]_inst 
       (.I(1'b0),
        .O(seg_bit1[0]),
        .T(1'b1));
  OBUFT \seg_bit1_OBUF[1]_inst 
       (.I(1'b0),
        .O(seg_bit1[1]),
        .T(1'b1));
  OBUFT \seg_bit1_OBUF[2]_inst 
       (.I(1'b0),
        .O(seg_bit1[2]),
        .T(1'b1));
  OBUFT \seg_bit1_OBUF[3]_inst 
       (.I(1'b0),
        .O(seg_bit1[3]),
        .T(1'b1));
  OBUFT \seg_bit2_OBUF[0]_inst 
       (.I(1'b0),
        .O(seg_bit2[0]),
        .T(1'b1));
  OBUFT \seg_bit2_OBUF[1]_inst 
       (.I(1'b0),
        .O(seg_bit2[1]),
        .T(1'b1));
  OBUFT \seg_bit2_OBUF[2]_inst 
       (.I(1'b0),
        .O(seg_bit2[2]),
        .T(1'b1));
  OBUFT \seg_bit2_OBUF[3]_inst 
       (.I(1'b0),
        .O(seg_bit2[3]),
        .T(1'b1));
  OBUFT \seg_bit3_OBUF[0]_inst 
       (.I(1'b0),
        .O(seg_bit3[0]),
        .T(1'b1));
  OBUFT \seg_bit3_OBUF[1]_inst 
       (.I(1'b0),
        .O(seg_bit3[1]),
        .T(1'b1));
  OBUFT \seg_bit3_OBUF[2]_inst 
       (.I(1'b0),
        .O(seg_bit3[2]),
        .T(1'b1));
  OBUFT \seg_bit3_OBUF[3]_inst 
       (.I(1'b0),
        .O(seg_bit3[3]),
        .T(1'b1));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
