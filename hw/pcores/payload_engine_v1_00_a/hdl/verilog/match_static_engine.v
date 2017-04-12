`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:05:28 09/13/2011 
// Design Name: 
// Module Name:    match_static_engine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module match_static_engine(
    //signal <-> control interface
	input [9:0] preHash_T1,
	input [9:0] preHash_T2,
	input [159:0] fifo_in,
	input [159:0] fifo_in_nocase,
	input endState_7,
	input endState_12,
	output [13:0] patternID,
	output [13:0] patternID_nocase,
	//global
	input clk,
	input rst,
	//control,
	input enable,
	//debug
	output [13:0] debug_rawPatternID,
	output [4:0]  debug_state_buf,
	output [13:0] debug_rawPatternID_nocase,
	output [4:0]  debug_state_buf_nocase,
	output [31:0] t3match,
	output [31:0] t3match_nocase,
	output [143:0] addr_out_portA, addr_out_portB,addr_out_portA_nocase, addr_out_portB_nocase
	);
	wire [13:0] patternID_out,patternID_nocase_out;
	//wire [143:0] addr_out_portA, addr_out_portB,addr_out_portA_nocase, addr_out_portB_nocase;
	wire [31:0] compare_out,compare_out_nocase;
	wire [31:0] suffix, suffix_nocase;
	
	
	wire [12:0] addr_in_T4;
	wire [12:0] addr_in_T4_nocase;
	
	
	reg [31:0] compare_out_buf = 0,compare_out_nocase_buf = 0;
	reg [4:0] Clk_Count = 0;
	reg [143:0] addr_out_portA_buf[2:0];
	reg [143:0] addr_out_portB_buf[2:0];
	reg [143:0] addr_out_portA_nocase_buf[2:0];
	reg [143:0] addr_out_portB_nocase_buf[2:0];
	reg [4:0] state_buf = 0,state_nocase_buf = 0;
	reg [13:0] raw_patternID[1:0];
	reg [31:0] suffix_buf[1:0];
	reg [1:0]  extracted_suffix = 0, extracted_suffix_nocase = 0;
	reg [13:0] raw_patternID_nocase[1:0];
	reg [31:0] suffix_nocase_buf[1:0];
	
	wire [9:0]  posT1_hash1, posT2_hash1;
	wire [9:0]  posT1_hash2, posT2_hash2;
	wire [9:0]  posT1_hash3, posT2_hash3;
	wire [9:0]  posT1_hash4, posT2_hash4;
	wire [9:0]  posT1_hash5, posT2_hash5;
	wire [9:0]  posT1_hash6, posT2_hash6;
	wire [9:0]  posT1_hash7, posT2_hash7;
	wire [9:0]  posT1_hash8, posT2_hash8;
	wire [9:0]  posT1_hash9, posT2_hash9;
	wire [9:0]  posT1_hash10, posT2_hash10;
	wire [9:0]  posT1_hash11, posT2_hash11;
	wire [9:0]  posT1_hash12, posT2_hash12;
	wire [9:0]  posT1_hash13, posT2_hash13;
	wire [9:0]  posT1_hash14, posT2_hash14;
	wire [9:0]  posT1_hash15, posT2_hash15;
	wire [9:0]  posT1_hash16, posT2_hash16;

	wire [9:0]  preHash_T1_nocase, preHash_T2_nocase;
	wire [9:0]  posT1_hash1_nocase, posT2_hash1_nocase;
	wire [9:0]  posT1_hash2_nocase, posT2_hash2_nocase;
	wire [9:0]  posT1_hash3_nocase, posT2_hash3_nocase;
	wire [9:0]  posT1_hash4_nocase, posT2_hash4_nocase;
	wire [9:0]  posT1_hash5_nocase, posT2_hash5_nocase;
	wire [9:0]  posT1_hash6_nocase, posT2_hash6_nocase;
	wire [9:0]  posT1_hash7_nocase, posT2_hash7_nocase;
	wire [9:0]  posT1_hash8_nocase, posT2_hash8_nocase;
	wire [9:0]  posT1_hash9_nocase, posT2_hash9_nocase;
	wire [9:0]  posT1_hash10_nocase, posT2_hash10_nocase;
	wire [9:0]  posT1_hash11_nocase, posT2_hash11_nocase;
	wire [9:0]  posT1_hash12_nocase, posT2_hash12_nocase;
	wire [9:0]  posT1_hash13_nocase, posT2_hash13_nocase;
	wire [9:0]  posT1_hash14_nocase, posT2_hash14_nocase;
	wire [9:0]  posT1_hash15_nocase, posT2_hash15_nocase;
	wire [9:0]  posT1_hash16_nocase, posT2_hash16_nocase;
	 
	//debug
	assign t3match = compare_out;
	assign t3match_nocase = compare_out_nocase;
	 
	//debug
	assign debug_rawPatternID = raw_patternID[1];
	assign debug_state_buf = state_buf;
	assign debug_rawPatternID_nocase = raw_patternID_nocase[1];
	assign debug_state_buf_nocase = state_nocase_buf;	
	
	 
	initial begin
		raw_patternID[0] = 0;
		raw_patternID_nocase[0] = 0;
		raw_patternID[1] = 0;
		raw_patternID_nocase[1] = 0;
	end
	
	
	//debug only block
//	always@(negedge clk) begin
//		//$strobe("[Matching Static] At time %0t compare_out %b %b",$time,compare_out_buf,compare_out_nocase_buf);
//		//$strobe("[Control Engine] At time %0t addr_out_portA_nocase_buf[1]11 %d state_nocase_buf %d",$time,addr_out_portA_nocase_buf[1][98:90],state_nocase_buf);
//		//$strobe("[Matching Static] At time %0t raw_id %b %b",$time,raw_patternID[1],raw_patternID_nocase[1]);
//		//$strobe("[Matching Static] At time %0t pattern_ID %b %b",$time,patternID,patternID_nocase);
//		
//		//$strobe("[Matching Static] At time %0t preHash %b %b",$time,preHash_T1,preHash_T2);
//		//$strobe("[Matching Static] At time %0t fifo %h %h",$time,fifo_in,fifo_in_nocase);
//		//$strobe("[Matching Static] At time %0t compare_out %b %b",$time,compare_out,compare_out_nocase);
//		
//		/*
//		$strobe("[Matching Static] At time %0t pos_hash1_nocase %d %d",$time,posT1_hash1_nocase,posT2_hash1_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash2_nocase %d %d",$time,posT1_hash2_nocase,posT2_hash2_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash3_nocase %d %d",$time,posT1_hash3_nocase,posT2_hash3_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash4_nocase %d %d",$time,posT1_hash4_nocase,posT2_hash4_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash5_nocase %d %d",$time,posT1_hash5_nocase,posT2_hash5_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash6_nocase %d %d",$time,posT1_hash6_nocase,posT2_hash6_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash7_nocase %d %d",$time,posT1_hash7_nocase,posT2_hash7_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash8_nocase %d %d",$time,posT1_hash8_nocase,posT2_hash8_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash9_nocase %d %d",$time,posT1_hash9_nocase,posT2_hash9_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash10_nocase %d %d",$time,posT1_hash10_nocase,posT2_hash10_nocase);
//		$strobe("[Matching Static] At time %0t pos_hash11_nocase %d %d",$time,posT1_hash11_nocase,posT2_hash11_nocase);
//		*/
//		
//		
//	end
	
	//register and net define
	
	
	//assign net
	 assign preHash_T1_nocase = preHash_T1;
	 assign preHash_T2_nocase = preHash_T2;
	 
	 assign addr_in_T4 = (raw_patternID[1]==0) ? 0 : {raw_patternID[1][13:9]-1,raw_patternID[1][8:0]};
	 assign addr_in_T4_nocase = (raw_patternID_nocase[1]==0) ? 0 : {raw_patternID_nocase[1][13:9]-1,raw_patternID_nocase[1][8:0]};
	
	 assign patternID_out = (Clk_Count < 6) ? 0 : patternID;
	 assign patternID_nocase_out = (Clk_Count < 6) ? 0 : patternID_nocase;
	 
	 	 track_pattern tp(raw_patternID[1],extracted_suffix,addr_in_T4,clk,patternID);
	 track_pattern_nocase tp1(raw_patternID_nocase[1],extracted_suffix_nocase,addr_in_T4_nocase,clk,patternID_nocase);
	/*****Stage 1*****/
	/****  4 clks ****/
	//Cuckoo module Level 1
	Cuckoo_L1 CuckL1 (
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(preHash_T1),
	 .preHash_T2(preHash_T2),
	 .addr_in_T1(posT1_hash1),
	 .addr_in_T2(posT2_hash1),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[8:0]),
	 .addr_in_portB(addr_out_portB[8:0]),
	 .compare_out(compare_out[1:0]),
	 .suffix(suffix[1:0]),
	 //nocase signals
	 .preHash_T1_nocase(preHash_T1_nocase),
	 .preHash_T2_nocase(preHash_T2_nocase),
	 .addr_in_T1_nocase(posT1_hash1_nocase),
	 .addr_in_T2_nocase(posT2_hash1_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[8:0]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[8:0]),
	 .compare_out_nocase(compare_out_nocase[1:0]),
	 .suffix_nocase(suffix_nocase[1:0])
    );
	
	
		//Cuckoo module Level 2
	Cuckoo_L2 CuckL2(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash1),
	 .preHash_T2(posT2_hash1),
	 .addr_in_T1(posT1_hash2),
	 .addr_in_T2(posT2_hash2),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*1+8:9*1]),
	 .addr_in_portB(addr_out_portB[9*1+8:9*1]),
	 .compare_out(compare_out[2*1+1:2*1]),
	 .suffix(suffix[2*1+1:2*1]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash1_nocase),
	 .preHash_T2_nocase(posT2_hash1_nocase),
	 .addr_in_T1_nocase(posT1_hash2_nocase),
	 .addr_in_T2_nocase(posT2_hash2_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*1+8:9*1]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*1+8:9*1]),
	 .compare_out_nocase(compare_out_nocase[2*1+1:2*1]),
	 .suffix_nocase(suffix_nocase[2*1+1:2*1])
    );

	//Cuckoo module Level 3
	Cuckoo_L3 CuckL3(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash2),
	 .preHash_T2(posT2_hash2),
	 .addr_in_T1(posT1_hash3),
	 .addr_in_T2(posT2_hash3),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*2+8:9*2]),
	 .addr_in_portB(addr_out_portB[9*2+8:9*2]),
	 .compare_out(compare_out[2*2+1:2*2]),
	 .suffix(suffix[2*2+1:2*2]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash2_nocase),
	 .preHash_T2_nocase(posT2_hash2_nocase),
	 .addr_in_T1_nocase(posT1_hash3_nocase),
	 .addr_in_T2_nocase(posT2_hash3_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*2+8:9*2]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*2+8:9*2]),
	 .compare_out_nocase(compare_out_nocase[2*2+1:2*2]),
	 .suffix_nocase(suffix_nocase[2*2+1:2*2])
    );

	//Cuckoo module Level 4
	Cuckoo_L4 CuckL4(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash3),
	 .preHash_T2(posT2_hash3),
	 .addr_in_T1(posT1_hash4),
	 .addr_in_T2(posT2_hash4),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*3+8:9*3]),
	 .addr_in_portB(addr_out_portB[9*3+8:9*3]),
	 .compare_out(compare_out[2*3+1:2*3]),
	 .suffix(suffix[2*3+1:2*3]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash3_nocase),
	 .preHash_T2_nocase(posT2_hash3_nocase),
	 .addr_in_T1_nocase(posT1_hash4_nocase),
	 .addr_in_T2_nocase(posT2_hash4_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*3+8:9*3]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*3+8:9*3]),
	 .compare_out_nocase(compare_out_nocase[2*3+1:2*3]),
	 .suffix_nocase(suffix_nocase[2*3+1:2*3])
    );

	//Cuckoo module Level 5
	Cuckoo_L5 CuckL5(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash4),
	 .preHash_T2(posT2_hash4),
	 .addr_in_T1(posT1_hash5),
	 .addr_in_T2(posT2_hash5),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*4+8:9*4]),
	 .addr_in_portB(addr_out_portB[9*4+8:9*4]),
	 .compare_out(compare_out[2*4+1:2*4]),
	 .suffix(suffix[2*4+1:2*4]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash4_nocase),
	 .preHash_T2_nocase(posT2_hash4_nocase),
	 .addr_in_T1_nocase(posT1_hash5_nocase),
	 .addr_in_T2_nocase(posT2_hash5_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*4+8:9*4]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*4+8:9*4]),
	 .compare_out_nocase(compare_out_nocase[2*4+1:2*4]),
	 .suffix_nocase(suffix_nocase[2*4+1:2*4])
    );

	//Cuckoo module Level 6
	Cuckoo_L6 CuckL6(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash5),
	 .preHash_T2(posT2_hash5),
	 .addr_in_T1(posT1_hash6),
	 .addr_in_T2(posT2_hash6),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*5+8:9*5]),
	 .addr_in_portB(addr_out_portB[9*5+8:9*5]),
	 .compare_out(compare_out[2*5+1:2*5]),
	 .suffix(suffix[2*5+1:2*5]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash5_nocase),
	 .preHash_T2_nocase(posT2_hash5_nocase),
	 .addr_in_T1_nocase(posT1_hash6_nocase),
	 .addr_in_T2_nocase(posT2_hash6_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*5+8:9*5]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*5+8:9*5]),
	 .compare_out_nocase(compare_out_nocase[2*5+1:2*5]),
	 .suffix_nocase(suffix_nocase[2*5+1:2*5])
    );

	//Cuckoo module Level 7
	Cuckoo_L7 CuckL7(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash6),
	 .preHash_T2(posT2_hash6),
	 .addr_in_T1(posT1_hash7),
	 .addr_in_T2(posT2_hash7),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*6+8:9*6]),
	 .addr_in_portB(addr_out_portB[9*6+8:9*6]),
	 .compare_out(compare_out[2*6+1:2*6]),
	 .suffix(suffix[2*6+1:2*6]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash6_nocase),
	 .preHash_T2_nocase(posT2_hash6_nocase),
	 .addr_in_T1_nocase(posT1_hash7_nocase),
	 .addr_in_T2_nocase(posT2_hash7_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*6+8:9*6]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*6+8:9*6]),
	 .compare_out_nocase(compare_out_nocase[2*6+1:2*6]),
	 .suffix_nocase(suffix_nocase[2*6+1:2*6])
    );

	//Cuckoo module Level 8
	Cuckoo_L8 CuckL8(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash7),
	 .preHash_T2(posT2_hash7),
	 .addr_in_T1(posT1_hash8),
	 .addr_in_T2(posT2_hash8),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*7+8:9*7]),
	 .addr_in_portB(addr_out_portB[9*7+8:9*7]),
	 .compare_out(compare_out[2*7+1:2*7]),
	 .suffix(suffix[2*7+1:2*7]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash7_nocase),
	 .preHash_T2_nocase(posT2_hash7_nocase),
	 .addr_in_T1_nocase(posT1_hash8_nocase),
	 .addr_in_T2_nocase(posT2_hash8_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*7+8:9*7]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*7+8:9*7]),
	 .compare_out_nocase(compare_out_nocase[2*7+1:2*7]),
	 .suffix_nocase(suffix_nocase[2*7+1:2*7])
    );

	//Cuckoo module Level 9
	Cuckoo_L9 CuckL9(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash8),
	 .preHash_T2(posT2_hash8),
	 .addr_in_T1(posT1_hash9),
	 .addr_in_T2(posT2_hash9),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*8+8:9*8]),
	 .addr_in_portB(addr_out_portB[9*8+8:9*8]),
	 .compare_out(compare_out[2*8+1:2*8]),
	 .suffix(suffix[2*8+1:2*8]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash8_nocase),
	 .preHash_T2_nocase(posT2_hash8_nocase),
	 .addr_in_T1_nocase(posT1_hash9_nocase),
	 .addr_in_T2_nocase(posT2_hash9_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*8+8:9*8]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*8+8:9*8]),
	 .compare_out_nocase(compare_out_nocase[2*8+1:2*8]),
	 .suffix_nocase(suffix_nocase[2*8+1:2*8])
    );

	//Cuckoo module Level 10
	Cuckoo_L10 CuckL10(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash9),
	 .preHash_T2(posT2_hash9),
	 .addr_in_T1(posT1_hash10),
	 .addr_in_T2(posT2_hash10),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*9+8:9*9]),
	 .addr_in_portB(addr_out_portB[9*9+8:9*9]),
	 .compare_out(compare_out[2*9+1:2*9]),
	 .suffix(suffix[2*9+1:2*9]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash9_nocase),
	 .preHash_T2_nocase(posT2_hash9_nocase),
	 .addr_in_T1_nocase(posT1_hash10_nocase),
	 .addr_in_T2_nocase(posT2_hash10_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*9+8:9*9]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*9+8:9*9]),
	 .compare_out_nocase(compare_out_nocase[2*9+1:2*9]),
	 .suffix_nocase(suffix_nocase[2*9+1:2*9])
    );

	//Cuckoo module Level 11
	Cuckoo_L11 CuckL11(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash10),
	 .preHash_T2(posT2_hash10),
	 .addr_in_T1(posT1_hash11),
	 .addr_in_T2(posT2_hash11),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*10+8:9*10]),
	 .addr_in_portB(addr_out_portB[9*10+8:9*10]),
	 .compare_out(compare_out[2*10+1:2*10]),
	 .suffix(suffix[2*10+1:2*10]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash10_nocase),
	 .preHash_T2_nocase(posT2_hash10_nocase),
	 .addr_in_T1_nocase(posT1_hash11_nocase),
	 .addr_in_T2_nocase(posT2_hash11_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*10+8:9*10]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*10+8:9*10]),
	 .compare_out_nocase(compare_out_nocase[2*10+1:2*10]),
	 .suffix_nocase(suffix_nocase[2*10+1:2*10])
    );

	//Cuckoo module Level 12
	Cuckoo_L12 CuckL12(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash11),
	 .preHash_T2(posT2_hash11),
	 .addr_in_T1(posT1_hash12),
	 .addr_in_T2(posT2_hash12),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*11+8:9*11]),
	 .addr_in_portB(addr_out_portB[9*11+8:9*11]),
	 .compare_out(compare_out[2*11+1:2*11]),
	 .suffix(suffix[2*11+1:2*11]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash11_nocase),
	 .preHash_T2_nocase(posT2_hash11_nocase),
	 .addr_in_T1_nocase(posT1_hash12_nocase),
	 .addr_in_T2_nocase(posT2_hash12_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*11+8:9*11]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*11+8:9*11]),
	 .compare_out_nocase(compare_out_nocase[2*11+1:2*11]),
	 .suffix_nocase(suffix_nocase[2*11+1:2*11])
    );

	//Cuckoo module Level 13
	Cuckoo_L13 CuckL13(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash12),
	 .preHash_T2(posT2_hash12),
	 .addr_in_T1(posT1_hash13),
	 .addr_in_T2(posT2_hash13),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*12+8:9*12]),
	 .addr_in_portB(addr_out_portB[9*12+8:9*12]),
	 .compare_out(compare_out[2*12+1:2*12]),
	 .suffix(suffix[2*12+1:2*12]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash12_nocase),
	 .preHash_T2_nocase(posT2_hash12_nocase),
	 .addr_in_T1_nocase(posT1_hash13_nocase),
	 .addr_in_T2_nocase(posT2_hash13_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*12+8:9*12]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*12+8:9*12]),
	 .compare_out_nocase(compare_out_nocase[2*12+1:2*12]),
	 .suffix_nocase(suffix_nocase[2*12+1:2*12])
    );

	//Cuckoo module Level 14
	Cuckoo_L14 CuckL14(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash13),
	 .preHash_T2(posT2_hash13),
	 .addr_in_T1(posT1_hash14),
	 .addr_in_T2(posT2_hash14),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*13+8:9*13]),
	 .addr_in_portB(addr_out_portB[9*13+8:9*13]),
	 .compare_out(compare_out[2*13+1:2*13]),
	 .suffix(suffix[2*13+1:2*13]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash13_nocase),
	 .preHash_T2_nocase(posT2_hash13_nocase),
	 .addr_in_T1_nocase(posT1_hash14_nocase),
	 .addr_in_T2_nocase(posT2_hash14_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*13+8:9*13]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*13+8:9*13]),
	 .compare_out_nocase(compare_out_nocase[2*13+1:2*13]),
	 .suffix_nocase(suffix_nocase[2*13+1:2*13])
    );

	//Cuckoo module Level 15
	Cuckoo_L15 CuckL15(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash14),
	 .preHash_T2(posT2_hash14),
	 .addr_in_T1(posT1_hash15),
	 .addr_in_T2(posT2_hash15),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*14+8:9*14]),
	 .addr_in_portB(addr_out_portB[9*14+8:9*14]),
	 .compare_out(compare_out[2*14+1:2*14]),
	 .suffix(suffix[2*14+1:2*14]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash14_nocase),
	 .preHash_T2_nocase(posT2_hash14_nocase),
	 .addr_in_T1_nocase(posT1_hash15_nocase),
	 .addr_in_T2_nocase(posT2_hash15_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*14+8:9*14]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*14+8:9*14]),
	 .compare_out_nocase(compare_out_nocase[2*14+1:2*14]),
	 .suffix_nocase(suffix_nocase[2*14+1:2*14])
    );

	//Cuckoo module Level 16
	Cuckoo_L16 CuckL16(
	 //global
	 .clk(clk),
	 .rst(rst),
	 .enable(enable),
	 //case sensitive signals
	 .preHash_T1(posT1_hash15),
	 .preHash_T2(posT2_hash15),
	 .addr_in_T1(posT1_hash16),
	 .addr_in_T2(posT2_hash16),
	 .fifo_in(fifo_in),
	 .addr_in_portA(addr_out_portA[9*15+8:9*15]),
	 .addr_in_portB(addr_out_portB[9*15+8:9*15]),
	 .compare_out(compare_out[2*15+1:2*15]),
	 .suffix(suffix[2*15+1:2*15]),
	 //nocase signals
	 .preHash_T1_nocase(posT1_hash15_nocase),
	 .preHash_T2_nocase(posT2_hash15_nocase),
	 .addr_in_T1_nocase(posT1_hash16_nocase),
	 .addr_in_T2_nocase(posT2_hash16_nocase),
	 .fifo_in_nocase(fifo_in_nocase),
	 .addr_in_portA_nocase(addr_out_portA_nocase[9*15+8:9*15]),
	 .addr_in_portB_nocase(addr_out_portB_nocase[9*15+8:9*15]),
	 .compare_out_nocase(compare_out_nocase[2*15+1:2*15]),
	 .suffix_nocase(suffix_nocase[2*15+1:2*15])
    );

	/*****Stage 2*****/
	/****  x clks ****/
	 always@(posedge clk) begin
		if (!endState_12) begin
			if (Clk_Count <= 25)
						Clk_Count <= Clk_Count + 5'b1;
		end
		else
			Clk_Count <=0;
			
		if (!endState_7) begin
		addr_out_portA_buf[2] <= addr_out_portA_buf[1];
		addr_out_portB_buf[2] <= addr_out_portB_buf[1];
		addr_out_portA_nocase_buf[2] <= addr_out_portA_nocase_buf[1];
		addr_out_portB_nocase_buf[2] <= addr_out_portB_nocase_buf[1];		
		end
		else begin
			addr_out_portA_buf[2] <= 0;
			addr_out_portB_buf[2] <= 0;
			addr_out_portA_nocase_buf[2] <= 0;
			addr_out_portB_nocase_buf[2] <= 0;
		end
		
		raw_patternID[1] <= raw_patternID[0];
		raw_patternID_nocase[1] <= raw_patternID_nocase[0];
		addr_out_portA_buf[0] <= addr_out_portA;
		addr_out_portB_buf[0] <= addr_out_portB;
		addr_out_portA_nocase_buf[0] <= addr_out_portA_nocase;
		addr_out_portB_nocase_buf[0] <= addr_out_portB_nocase;
		
		compare_out_buf <= compare_out;
		compare_out_nocase_buf <= compare_out_nocase;
		
		addr_out_portA_buf[1] <= addr_out_portA_buf[0];
		addr_out_portB_buf[1] <= addr_out_portB_buf[0]; 
		addr_out_portA_nocase_buf[1] <= addr_out_portA_nocase_buf[0];
		addr_out_portB_nocase_buf[1] <= addr_out_portB_nocase_buf[0]; 
		
//		addr_out_portA_buf[2] <= addr_out_portA_buf[1];
//		addr_out_portB_buf[2] <= addr_out_portB_buf[1];
//		addr_out_portA_nocase_buf[2] <= addr_out_portA_nocase_buf[1];
//		addr_out_portB_nocase_buf[2] <= addr_out_portB_nocase_buf[1];
			
		state_buf <= state2Out(addr_out_portA_buf[1],addr_out_portB_buf[1],compare_out,Clk_Count);
//		raw_patternID[0] <= state2Out1(addr_out_portA_buf[2],addr_out_portB_buf[2],compare_out_buf,state_buf);
		
		raw_patternID[0][13:0] <= 0;
		if (state_buf == 16)begin
			if (compare_out_buf[31:30] == 1)begin 
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][143:135];
				if(addr_out_portA_buf[2][143:135]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][143:135];
				if(addr_out_portB_buf[2][143:135]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 15)	begin	
			if (compare_out_buf[29:28] == 1)begin 
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][134:126];
				if(addr_out_portA_buf[2][134:126]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][134:126];
				if(addr_out_portB_buf[2][134:126]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 14)begin			
			if (compare_out_buf[27:26] == 1)begin 
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][125:117];
				if(addr_out_portA_buf[2][125:117]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][125:117];	
				if(addr_out_portB_buf[2][125:117]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 13)begin			
			if (compare_out_buf[25:24] == 1)begin 
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][116:108];
				if(addr_out_portA_buf[2][116:108]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][116:108];
				if(addr_out_portB_buf[2][116:108]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 12)begin
			if (compare_out_buf[23:22] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][107:99];
				if(addr_out_portA_buf[2][107:99]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][107:99];
				if(addr_out_portB_buf[2][107:99]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 11)begin
			if (compare_out_buf[21:20] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][98:90];
				if(addr_out_portA_buf[2][98:90]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][98:90];
				if(addr_out_portB_buf[2][98:90]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 10)begin
			if (compare_out_buf[19:18] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][89:81];
				if(addr_out_portA_buf[2][89:81]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][89:81];
				if(addr_out_portB_buf[2][89:81]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 9)begin
			if (compare_out_buf[17:16] == 1)begin 
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][80:72];
				if(addr_out_portA_buf[2][80:72]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][80:72];
				if(addr_out_portB_buf[2][80:72]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 8)begin
			if (compare_out_buf[15:14] == 1)begin 
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][71:63];
				if(addr_out_portA_buf[2][71:63]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][71:63];
				if(addr_out_portB_buf[2][71:63]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 7)begin
			if (compare_out_buf[13:12] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][62:54];
				if(addr_out_portA_buf[2][62:54]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][62:54];
				if(addr_out_portB_buf[2][62:54]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 6)begin
			if (compare_out_buf[11:10] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][53:45];
				if(addr_out_portA_buf[2][53:45]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][53:45];
				if(addr_out_portB_buf[2][53:45]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 5)begin
			if (compare_out_buf[9:8] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][44:36];
				if(addr_out_portA_buf[2][44:36]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][44:36];
				if(addr_out_portB_buf[2][44:36]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 4)begin
			if (compare_out_buf[7:6] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][35:27];
				if(addr_out_portA_buf[2][35:27]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][35:27];
				if(addr_out_portB_buf[2][35:27]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 3)begin
			if (compare_out_buf[5:4] == 1)begin 
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][26:18];
				if(addr_out_portA_buf[2][26:18]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][26:18];
				if(addr_out_portB_buf[2][26:18]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 2)begin
			if (compare_out_buf[3:2] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][17:9];
				if(addr_out_portA_buf[2][17:9]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][17:9];	
				if(addr_out_portB_buf[2][17:9]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 1)	begin
			if (compare_out_buf[1:0] == 1) begin
				raw_patternID[0][8:0] <= addr_out_portA_buf[2][8:0];
				if(addr_out_portA_buf[2][8:0]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end else begin
				raw_patternID[0][8:0] <= addr_out_portB_buf[2][8:0];
				if(addr_out_portB_buf[2][8:0]==0) raw_patternID[0][13:9] <= 0;
				else raw_patternID[0][13:9] <= state_buf;
			end
		end else if (state_buf == 0)	begin
			raw_patternID[0][8:0] <= 0;
			raw_patternID[0][13:9] <= 0;
		end
		
		suffix_buf[0] <= suffix;
		suffix_buf[1] <= suffix_buf[0];
		
		getSuffix(suffix_buf[1],raw_patternID[0],extracted_suffix);
		
		state_nocase_buf <= state2Out(addr_out_portA_nocase_buf[1],addr_out_portB_nocase_buf[1],compare_out_nocase,Clk_Count);
//		raw_patternID_nocase[0] <= state2Out1(addr_out_portA_nocase_buf[2],addr_out_portB_nocase_buf[2],compare_out_nocase_buf,state_nocase_buf);
		
		raw_patternID_nocase[0][13:0] <= 0;
		if (state_nocase_buf == 16)begin
			if (compare_out_nocase_buf[31:30] == 1)begin 
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][143:135];
				if(addr_out_portA_nocase_buf[2][143:135]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][143:135];
				if(addr_out_portB_nocase_buf[2][143:135]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 15)	begin	
			if (compare_out_nocase_buf[29:28] == 1)begin 
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][134:126];
				if(addr_out_portA_nocase_buf[2][134:126]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][134:126];
				if(addr_out_portB_nocase_buf[2][134:126]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 14)begin			
			if (compare_out_nocase_buf[27:26] == 1)begin 
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][125:117];
				if(addr_out_portA_nocase_buf[2][125:117]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][125:117];	
				if(addr_out_portB_nocase_buf[2][125:117]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 13)begin			
			if (compare_out_nocase_buf[25:24] == 1)begin 
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][116:108];
				if(addr_out_portA_nocase_buf[2][116:108]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][116:108];
				if(addr_out_portB_nocase_buf[2][116:108]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 12)begin
			if (compare_out_nocase_buf[23:22] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][107:99];
				if(addr_out_portA_nocase_buf[2][107:99]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][107:99];
				if(addr_out_portB_nocase_buf[2][107:99]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 11)begin
			if (compare_out_nocase_buf[21:20] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][98:90];
				if(addr_out_portA_nocase_buf[2][98:90]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][98:90];
				if(addr_out_portB_nocase_buf[2][98:90]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 10)begin
			if (compare_out_nocase_buf[19:18] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][89:81];
				if(addr_out_portA_nocase_buf[2][89:81]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][89:81];
				if(addr_out_portB_nocase_buf[2][89:81]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 9)begin
			if (compare_out_nocase_buf[17:16] == 1)begin 
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][80:72];
				if(addr_out_portA_nocase_buf[2][80:72]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][80:72];
				if(addr_out_portB_nocase_buf[2][80:72]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 8)begin
			if (compare_out_nocase_buf[15:14] == 1)begin 
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][71:63];
				if(addr_out_portA_nocase_buf[2][71:63]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][71:63];
				if(addr_out_portB_nocase_buf[2][71:63]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 7)begin
			if (compare_out_nocase_buf[13:12] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][62:54];
				if(addr_out_portA_nocase_buf[2][62:54]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][62:54];
				if(addr_out_portB_nocase_buf[2][62:54]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 6)begin
			if (compare_out_nocase_buf[11:10] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][53:45];
				if(addr_out_portA_nocase_buf[2][53:45]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][53:45];
				if(addr_out_portB_nocase_buf[2][53:45]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 5)begin
			if (compare_out_nocase_buf[9:8] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][44:36];
				if(addr_out_portA_nocase_buf[2][44:36]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][44:36];
				if(addr_out_portB_nocase_buf[2][44:36]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 4)begin
			if (compare_out_nocase_buf[7:6] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][35:27];
				if(addr_out_portA_nocase_buf[2][35:27]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][35:27];
				if(addr_out_portB_nocase_buf[2][35:27]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 3)begin
			if (compare_out_nocase_buf[5:4] == 1)begin 
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][26:18];
				if(addr_out_portA_nocase_buf[2][26:18]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][26:18];
				if(addr_out_portB_nocase_buf[2][26:18]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 2)begin
			if (compare_out_nocase_buf[3:2] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][17:9];
				if(addr_out_portA_nocase_buf[2][17:9]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][17:9];	
				if(addr_out_portB_nocase_buf[2][17:9]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 1)	begin
			if (compare_out_nocase_buf[1:0] == 1) begin
				raw_patternID_nocase[0][8:0] <= addr_out_portA_nocase_buf[2][8:0];
				if(addr_out_portA_nocase_buf[2][8:0]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end else begin
				raw_patternID_nocase[0][8:0] <= addr_out_portB_nocase_buf[2][8:0];
				if(addr_out_portB_nocase_buf[2][8:0]==0) raw_patternID_nocase[0][13:9] <= 0;
				else raw_patternID_nocase[0][13:9] <= state_nocase_buf;
			end
		end else if (state_nocase_buf == 0)	begin
			raw_patternID_nocase[0][8:0] <= 0;
			raw_patternID_nocase[0][13:9] <= 0;
		end
		 

		
		suffix_nocase_buf[0] <= suffix_nocase;
		suffix_nocase_buf[1] <= suffix_nocase_buf[0];
		
		getSuffix(suffix_nocase_buf[1],raw_patternID_nocase[0],extracted_suffix_nocase);
	end
	
	task initialState;
		begin
			Clk_Count <= 0;
		end
	endtask
	
//	function [13:0] state2Out1(input [143:0] t1,t2 ,input [31:0] compare_check,input [4:0] state2Out);
//		begin
//		
//		if (state2Out == 16)
//			if (compare_check[31:30] == 1) 
//				state2Out1[8:0] = t1[143:135];
//			else
//				state2Out1[8:0] = t2[143:135];
//		if (state2Out == 15)		
//			if (compare_check[29:28] == 1) 
//				state2Out1[8:0] = t1[134:126];
//			else
//				state2Out1[8:0] = t2[134:126];
//		if (state2Out == 14)			
//			if (compare_check[27:26] == 1) 
//				state2Out1[8:0] = t1[125:117];
//			else
//				state2Out1[8:0] = t2[125:117];	
//		if (state2Out == 13)			
//			if (compare_check[25:24] == 1) 
//				state2Out1[8:0] = t1[116:108];
//			else
//				state2Out1[8:0] = t2[116:108];
//		if (state2Out == 12)
//			if (compare_check[23:22] == 1) 
//				state2Out1[8:0] = t1[107:99];
//			else
//				state2Out1[8:0] = t2[107:99];
//		if (state2Out == 11)
//			if (compare_check[21:20] == 1) 
//				state2Out1[8:0] = t1[98:90];
//			else
//				state2Out1[8:0] = t2[98:90];
//		if (state2Out == 10)
//			if (compare_check[19:18] == 1) 
//				state2Out1[8:0] = t1[89:81];
//			else
//				state2Out1[8:0] = t2[89:81];
//		if (state2Out == 9)
//			if (compare_check[17:16] == 1) 
//				state2Out1[8:0] = t1[80:72];
//			else
//				state2Out1[8:0] = t2[80:72];
//		if (state2Out == 8)
//			if (compare_check[15:14] == 1) 
//				state2Out1[8:0] = t1[71:63];
//			else
//				state2Out1[8:0] = t2[71:63];
//		if (state2Out == 7)
//				if (compare_check[13:12] == 1) 
//				state2Out1[8:0] = t1[62:54];
//			else
//				state2Out1[8:0] = t2[62:54];
//		if (state2Out == 6)
//			if (compare_check[11:10] == 1) 
//				state2Out1[8:0] = t1[53:45];
//			else
//				state2Out1[8:0] = t2[53:45];
//		if (state2Out == 5)
//			if (compare_check[9:8] == 1) 
//				state2Out1[8:0] = t1[44:36];
//			else
//				state2Out1[8:0] = t2[44:36];
//		if (state2Out == 4)
//			if (compare_check[7:6] == 1) 
//				state2Out1[8:0] = t1[35:27];
//			else
//				state2Out1[8:0] = t2[35:27];
//		if (state2Out == 3)
//			if (compare_check[5:4] == 1) 
//				state2Out1[8:0] = t1[26:18];
//			else
//				state2Out1[8:0] = t2[26:18];
//		if (state2Out == 2)
//			if (compare_check[3:2] == 1) 
//				state2Out1[8:0] = t1[17:9];
//			else
//				state2Out1[8:0] = t2[17:9];	
//		if (state2Out == 1)	
//			if (compare_check[1:0] == 1) 
//				state2Out1[8:0] = t1[8:0];
//			else
//				state2Out1[8:0] = t2[8:0];
//		if (state2Out == 0)	
//			state2Out1 = 0;
//		if (state2Out1[8:0] == 0)					
//			state2Out1[13:9] = 0;	
//		else
//			state2Out1[13:9] = state2Out; 
//		end
//	endfunction
	function [4:0]state2Out( input [143:0] t1,t2 ,input [31:0] compare_check,input [4:0] Clk_Count);
		begin
		state2Out = 0;
		if (compare_check[31:0] != 0) begin
			if ((compare_check[31:30] != 0) && (Clk_Count >=21)) begin
				state2Out = 16;
			end
			else if ((compare_check[29:28] != 0) && (Clk_Count >=20)) begin
				state2Out = 15;
				
			end
			else if ((compare_check[27:26] != 0) && (Clk_Count >=19)) begin
				state2Out = 14;
				
			end
			else if ((compare_check[25:24] != 0) && (Clk_Count >=18)) begin
				state2Out = 13;
				
			end
			else if ((compare_check[23:22] != 0) && (Clk_Count >=17)) begin
				state2Out = 12;
				
			end
			else if ((compare_check[21:20] != 0) && (Clk_Count >=16)) begin
				state2Out = 11;
				
			end
			else if ((compare_check[19:18] != 0) && (Clk_Count >=15)) begin
				state2Out = 10;
				
			end
			else if ((compare_check[17:16] != 0) && (Clk_Count >=14)) begin
				state2Out = 9;
				
			end
			else if ((compare_check[15:14] != 0) && (Clk_Count >=13)) begin
				state2Out = 8;
				
			end
			else if ((compare_check[13:12] != 0) && (Clk_Count >=12)) begin
				state2Out = 7;
				
			end
			else if ((compare_check[11:10] != 0) && (Clk_Count >=11)) begin
				state2Out = 6;
				
			end
			else if ((compare_check[9:8] != 0) && (Clk_Count >=10)) begin
				state2Out = 5;
				
			end
			else if ((compare_check[7:6] != 0) && (Clk_Count >=9)) begin
				state2Out = 4;
				
			end
			else if ((compare_check[5:4] != 0) && (Clk_Count >=8)) begin
				state2Out = 3;
				
			end
			else if ((compare_check[3:2] != 0) && (Clk_Count >=7)) begin
				state2Out = 2;
				
			end
			else if ((compare_check[1:0] != 0) && (Clk_Count >=6)) begin
				state2Out = 1;
			end
		end
	end	
	endfunction
	
	
	task getSuffix;
		input [31:0] su;
		input [13:0] pattern;
		output[1:0] te_su;
		
		begin
			te_su = 0;
			if (pattern[13:9] == 1)
				te_su = su[1:0];
			if (pattern[13:9] == 2)
				te_su = su[3:2];
			if (pattern[13:9] == 3)
				te_su = su[5:4];
			if (pattern[13:9] == 4)
				te_su = su[7:6];
			if (pattern[13:9] == 5)
				te_su = su[9:8];
			if (pattern[13:9] == 6)
				te_su = su[11:10];
			if (pattern[13:9] == 7)
				te_su = su[13:12];
			if (pattern[13:9] == 8)
				te_su = su[15:14];
			if (pattern[13:9] == 9)
				te_su = su[17:16];
			if (pattern[13:9] == 10)
				te_su = su[19:18];
			if (pattern[13:9] == 11)
				te_su = su[21:20];
			if (pattern[13:9] == 12)
				te_su = su[23:22];
			if (pattern[13:9] == 13)
				te_su = su[25:24];
			if (pattern[13:9] == 14)
				te_su = su[27:26];
			if (pattern[13:9] == 15)
				te_su = su[29:28];
			if (pattern[13:9] == 16)
				te_su = su[31:30];
			
		end
		endtask
endmodule
