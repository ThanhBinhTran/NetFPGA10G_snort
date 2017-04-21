`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:59:59 05/12/2013
// Design Name:   match_static_engine
// Module Name:   /home/heckarim/work/ise/7.thesis/1.StaticEngine/tb_match_static_engine.v
// Project Name:  testStaticEngine
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: match_static_engine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_match_static_engine;

	// Inputs
	reg clk;
	reg [9:0] preHash_T1;
	reg [9:0] preHash_T2;
	reg [159:0] fifo_in;
	reg [159:0] fifo_in_nocase;
	reg endState_7;
	reg endState_12;
	reg [7:0] char_in;
	reg[30*8:0] str;
	reg rst;
	reg enable;

	// Outputs
	wire [13:0] patternID;
	wire [13:0] patternID_nocase;
	wire [13:0] debug_rawPatternID;
	wire [4:0] debug_state_buf;
	wire [13:0] debug_rawPatternID_nocase;
	wire [4:0] debug_state_buf_nocase;
	wire [31:0] t3match;
	wire [31:0] t3match_nocase;
	wire [143:0] addr_out_portA, addr_out_portB,addr_out_portA_nocase, addr_out_portB_nocase;
	wire [143:0] t3MatchIndex_nocase, t3MatchIndex;
	//wire [8:0] t3MatchL1,t3MatchL2,t3MatchL3,t3MatchL4,t3MatchL5,t3MatchL6,t3MatchL7,t3MatchL8,t3MatchL9,t3MatchL10,t3MatchL11,t3MatchL12,t3MatchL13,t3MatchL14,t3MatchL15,t3MatchL16;
	//wire [8:0] t3MatchL1_nocase, t3MatchL2_nocase, t3MatchL3_nocase, t3MatchL4_nocase, t3MatchL5_nocase, t3MatchL6_nocase, t3MatchL7_nocase, t3MatchL8_nocase, t3MatchL9_nocase, t3MatchL10_nocase, t3MatchL11_nocase, t3MatchL12_nocase, t3MatchL13_nocase, t3MatchL14_nocase, t3MatchL15_nocase, t3MatchL16_nocase;
	
	
	`include "constant.v"
	// Instantiate the Unit Under Test (UUT)
	match_static_engine uut (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.preHash_T1(preHash_T1), 
		.preHash_T2(preHash_T2), 
		.fifo_in(fifo_in), 
		.fifo_in_nocase(fifo_in_nocase), 
		.endState_7(endState_7), 
		.endState_12(endState_12), 
		.patternID(patternID), 
		.patternID_nocase(patternID_nocase), 
		.debug_rawPatternID(debug_rawPatternID), 
		.debug_state_buf(debug_state_buf), 
		.debug_rawPatternID_nocase(debug_rawPatternID_nocase), 
		.debug_state_buf_nocase(debug_state_buf_nocase),
		.t3match(t3match),
		.t3match_nocase(t3match_nocase),
		.addr_out_portA( addr_out_portA), 
		.addr_out_portB(addr_out_portB ),
		.addr_out_portA_nocase(addr_out_portA_nocase ), 
		.addr_out_portB_nocase(addr_out_portB_nocase )
	);
	
	T3MatchDecode decode(
	//decoding inputs
	.iCompareVector(t3match),
	.iCompareVector_nocase(t3match_nocase),
	.iAddr_portA(addr_out_portA), 
	.iAddr_portB(addr_out_portB), 
	.iAddr_portA_nocase(addr_out_portA_nocase), 
	.iAddr_portB_nocase(addr_out_portB_nocase),
	//decoded outputs
	.oIndex(t3MatchIndex),
	.oIndex_nocase(t3MatchIndex_nocase),
	//global
	.rst(rst),
	.clk(clk)
	);
	
	
	
	
	
	
	integer fin,r,status0, fout;	
	integer clk_count;
	
	initial begin
		fin=$fopen("data.tst","r");
		fout=$fopen("data.testresult","w");
		
	end
	
	
	
	
	initial begin
		// Initialize Inputs
		clk = 0;
		preHash_T1 = PRE_HASH_T1;
		preHash_T2 = PRE_HASH_T2;
		fifo_in = 0;
		fifo_in_nocase = 0;
		endState_7 = 0;
		endState_12 = 0;
		enable = 1'b1;
		rst = 1;
		#50;
		rst = 0;
		// Wait 100 ns for global reset to finish
		#50;
        
		// Add stimulus here
		while (1) begin
			@(negedge clk);
			fifo_in = {fifo_in[151:0],char_in};
			if ((char_in>=65) && (char_in <=90))
				fifo_in_nocase <= {fifo_in_nocase[151:0], char_in+8'd32};
			else
				fifo_in_nocase = {fifo_in_nocase[151:0],char_in};
		end

	end
	reg [8:0] indexT3A[0:15];
	reg [8:0] indexT3B[0:15];
	integer j;
	reg [10:0] globalIndex;
	initial begin
		#100;
		while ($fgets(str,fin))begin
			@(negedge clk);
			status0 = $sscanf(str,"%d-%h",globalIndex, char_in);
			//$fwrite(fout,"%b - %b\n", t3match, t3match_nocase);
			//for(j = 0; j<16; j=j+1)begin
			//	indexT3A[j] = addr_out_portA[8*(j+1)-1:8*j];
			//	indexT3B[j] = addr_out_portB[8*(j+1)-1:8*j];
			//end
			$display (" time %d str_in %h char_in %h %c ",$time, str, char_in, char_in);
		end
		#500;
		$fclose(fin);
		$fclose(fout);
		$stop;
		$finish;
	end

	initial begin
	    clk_count = 0;
		forever #10 clk = ~clk;
	end
	//dsfdsf
	reg [7:0] formatedchar;
	
	initial begin
		while(1) begin
			@(posedge clk);
			clk_count = clk_count + 1;
			//$fwrite(fout,"%c - %d - %b - %d - %d - %d - %d\n", char_in,clk_count, t3match_nocase, addr_out_portA_nocase[9*8-1:9*7], addr_out_portA_nocase[8*8-1:8*7], addr_out_portA[9*8-1:9*7], addr_out_portA[8*8-1:8*7]);
			if(char_in == 8'h2d) //-
				formatedchar = 32;
			else if(char_in< 127 && char_in >31)
				formatedchar = char_in;
			else 
				formatedchar = 32; //space
			$fwrite (fout,"%d-%c-%b-%h-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d\n", clk_count, formatedchar, t3match,patternID, t3MatchIndex[(0+1)*9-1:0*9], t3MatchIndex[(1+1)*9-1:1*9], t3MatchIndex[(2+1)*9-1:2*9], t3MatchIndex[(3+1)*9-1:3*9], t3MatchIndex[(4+1)*9-1:4*9], t3MatchIndex[(5+1)*9-1:5*9], t3MatchIndex[(6+1)*9-1:6*9], t3MatchIndex[(7+1)*9-1:7*9], t3MatchIndex[(8+1)*9-1:8*9], t3MatchIndex[(9+1)*9-1:9*9], t3MatchIndex[(10+1)*9-1:10*9], t3MatchIndex[(11+1)*9-1:11*9], t3MatchIndex[(12+1)*9-1:12*9], t3MatchIndex[(13+1)*9-1:13*9], t3MatchIndex[(14+1)*9-1:14*9], t3MatchIndex[(15+1)*9-1:15*9]);
		   $fwrite (fout,"%d-%c-%b-%h-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d\n", clk_count, formatedchar, t3match_nocase,patternID_nocase, t3MatchIndex_nocase[(0+1)*9-1:0*9], t3MatchIndex_nocase[(1+1)*9-1:1*9], t3MatchIndex_nocase[(2+1)*9-1:2*9], t3MatchIndex_nocase[(3+1)*9-1:3*9], t3MatchIndex_nocase[(4+1)*9-1:4*9], t3MatchIndex_nocase[(5+1)*9-1:5*9], t3MatchIndex_nocase[(6+1)*9-1:6*9], t3MatchIndex_nocase[(7+1)*9-1:7*9], t3MatchIndex_nocase[(8+1)*9-1:8*9], t3MatchIndex_nocase[(9+1)*9-1:9*9], t3MatchIndex_nocase[(10+1)*9-1:10*9], t3MatchIndex_nocase[(11+1)*9-1:11*9], t3MatchIndex_nocase[(12+1)*9-1:12*9], t3MatchIndex_nocase[(13+1)*9-1:13*9], t3MatchIndex_nocase[(14+1)*9-1:14*9], t3MatchIndex_nocase[(15+1)*9-1:15*9]);
		end
	end
	
	
      
endmodule

