////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: K.39
//  \   \         Application: netgen
//  /   /         Filename: end_matching_shift.v
// /___/   /\     Timestamp: Wed Jul 10 08:20:55 2013
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -w -sim -ofmt verilog /home/heckarim/work/ise/7.thesis/1.DynamicEngine/ips/PMM/tmp/_cg/end_matching_shift.ngc /home/heckarim/work/ise/7.thesis/1.DynamicEngine/ips/PMM/tmp/_cg/end_matching_shift.v 
// Device	: 2vp50ff1152-7
// Input file	: /home/heckarim/work/ise/7.thesis/1.DynamicEngine/ips/PMM/tmp/_cg/end_matching_shift.ngc
// Output file	: /home/heckarim/work/ise/7.thesis/1.DynamicEngine/ips/PMM/tmp/_cg/end_matching_shift.v
// # of Modules	: 1
// Design Name	: end_matching_shift
// Xilinx        : /opt/Xilinx/10.1/ISE
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Development System Reference Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module end_matching_shift (
  clk, d, q
);
  input clk;
  input [0 : 0] d;
  output [0 : 0] q;
  
  // synthesis translate_off
  
  wire \BU2/sclr ;
  wire \BU2/sset ;
  wire \BU2/sinit ;
  wire \BU2/ainit ;
  wire \BU2/aclr ;
  wire \BU2/ce ;
  wire \BU2/aset ;
  wire \BU2/U0/Mshreg_q_0_5 ;
  wire \BU2/U0/N1 ;
  wire \BU2/U0/N0 ;
  wire NLW_VCC_P_UNCONNECTED;
  wire NLW_GND_G_UNCONNECTED;
  wire [0 : 0] d_2;
  wire [0 : 0] q_3;
  wire [3 : 0] \BU2/a ;
  assign
    d_2[0] = d[0],
    q[0] = q_3[0];
  VCC   VCC_0 (
    .P(NLW_VCC_P_UNCONNECTED)
  );
  GND   GND_1 (
    .G(NLW_GND_G_UNCONNECTED)
  );
  FD #(
    .INIT ( 1'b0 ))
  \BU2/U0/q_0  (
    .C(clk),
    .D(\BU2/U0/Mshreg_q_0_5 ),
    .Q(q_3[0])
  );
  SRL16 #(
    .INIT ( 16'h0000 ))
  \BU2/U0/Mshreg_q_0  (
    .A0(\BU2/U0/N1 ),
    .A1(\BU2/U0/N0 ),
    .A2(\BU2/U0/N1 ),
    .A3(\BU2/U0/N0 ),
    .CLK(clk),
    .D(d_2[0]),
    .Q(\BU2/U0/Mshreg_q_0_5 )
  );
  VCC   \BU2/U0/XST_VCC  (
    .P(\BU2/U0/N1 )
  );
  GND   \BU2/U0/XST_GND  (
    .G(\BU2/U0/N0 )
  );

// synthesis translate_on

endmodule

// synthesis translate_off

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

    wire GSR;
    wire GTS;
    wire PRLD;

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

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
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

// synthesis translate_on
