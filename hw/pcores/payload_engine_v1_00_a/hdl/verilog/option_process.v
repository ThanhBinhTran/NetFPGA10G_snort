`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:59:39 03/19/2011 
// Design Name: 
// Module Name:    option_process 
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
module option_process(
	input [10:0]index_counter,//counter for handle options.
	//global
	input clk,
	input rst,
	//
	input [6:0] curPacketID,
	input state,
	input [13:0] patternID_in, //patternID without option check - index 
	input [13:0] patternID_in_nocase, //patternID without option check - index 
	input [9:0] pcreID,
	output reg filter_trigger,
	
	input end_of_packet_shift,
	input enable_32byte_process,
	
	
	//debug
	output [10:0] patternID_out1,
	output [10:0] patternID_out3,
	output [10:0] patternID_out5,
	output [11:0] index,
	output [11:0] index_nocase,
	output reg [10:0] clk_counter0,
	output reg [10:0] clk_counter1,
	output reg [10:0] clk_counter2
    );
	`include "src/payload/constant.v"
	/*
	
	wire [10:0] patternID_out1;
	wire [10:0] patternID_out3;
	wire [10:0] patternID_out5;
	
	
	wire [11:0] index;
	wire [11:0] index_nocase;
	reg [10:0] clk_counter;
	
	*/
	reg [11:0] index_out[2:0];
	reg [11:0] indexFilterForSim;
		
	reg [11:0] addra;
	reg [11:0] addrb;
	wire [13:0] sel;
	
	localparam BYTE_ADJUST = 11'd13;
	
	
/*	
	initial begin
		index_out[0] = 0;
		index_out[1] = 0;
		index_out[2] = 0;
		filter_trigger = 0;
		addra = 0;addrb = 0;
		clk_counter0 = 0;
		clk_counter1 = 0;
		clk_counter2 = 0;
	end
*/	
	always@(*)begin
		//$strobe("[Option Process] At time %0t addrb %d",$time,addrb);
		addra = get_index(patternID_in[13:9],patternID_in[8:0]);
		addrb = get_index_nocase(patternID_in_nocase[13:9],patternID_in_nocase[8:0]);
	end
	
	
	
	//ramT5 => tra bang ra index trong bang excel
	ramT5 ram_T5 (
		.clka(clk),
		.addra(addra), // Bus [11 : 0] 
		.douta(index), // Bus [11 : 0] 
		.clkb(clk),
		.addrb(addrb), // Bus [11 : 0] 
		.doutb(index_nocase)); // Bus [11 : 0] 

// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file ramT5.v when simulating
// the core, ramT5. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".


	//assign sel = select(index,index_nocase);
	
	
	
	process_type1 pt1(clk,clk_counter0,index_out[0][10:0], enable_32byte_process, patternID_out1); //0->n2;
	process_type4 pt4(clk,clk_counter1,index_out[1][9:0], enable_32byte_process, curPacketID,patternID_out3,end_of_packet_shift);//n2->n4
	process_type5 pt5(clk,clk_counter2,index_out[2][9:0], enable_32byte_process, curPacketID,patternID_out5,end_of_packet_shift);//n4->n6

	
	
//	always@(negedge clk) begin
//		if ((index && index <= 350) || (index_nocase && index_nocase <= 350))
//			$strobe("[Option Process] At time %0t index %d %d",$time,index,index_nocase);
		//$strobe("[Option Process] At time %0t index_out[0] %d",$time,index_out[0]);
		//$strobe("[Option Process] At time %0t index_out[1] %d",$time,index_out[1]);
		//$strobe("[Option Process] At time %0t index_out[2] %d",$time,index_out[2]);
		//$strobe("[Option Process] At time %0t patternID_out3 %d",$time,patternID_out3);
//	end
	
	wire [21:0] 	index0_din;
	reg				index0_rd_en;
	wire			index0_wr_en;
	wire	[8:0]	index0_data_count;
	wire	[21:0]	index0_dout;
	wire			index0_empty;
	wire			index0_full;
	wire			index0_valid;
	
	wire [21:0] 	index0_din_nocase;
	reg				index0_rd_en_nocase;
	wire				index0_wr_en_nocase;
	wire	[8:0]	index0_data_count_nocase;
	wire	[21:0]	index0_dout_nocase;
	wire				index0_empty_nocase;
	wire				index0_full_nocase;
	wire				index0_valid_nocase;
	
	wire [21:0] 	index1_din;
	reg				index1_rd_en;
	wire				index1_wr_en;
	wire	[8:0]	index1_data_count;
	wire	[21:0]	index1_dout;
	wire				index1_empty;
	wire				index1_full;
	wire				index1_valid;
	
	wire [21:0] 	index1_din_nocase;
	reg				index1_rd_en_nocase;
	wire				index1_wr_en_nocase;
	wire	[8:0]	index1_data_count_nocase;
	wire	[21:0]	index1_dout_nocase;
	wire				index1_empty_nocase;
	wire				index1_full_nocase;
	wire				index1_valid_nocase;
	
	wire [21:0] 	index2_din;
	reg				index2_rd_en;
	wire				index2_wr_en;
	wire	[8:0]	index2_data_count;
	wire	[21:0]	index2_dout;
	wire				index2_empty;
	wire				index2_full;
	wire				index2_valid;
	
	wire [21:0] 	index2_din_nocase;
	reg				index2_rd_en_nocase;
	wire				index2_wr_en_nocase;
	wire	[8:0]	index2_data_count_nocase;
	wire	[21:0]	index2_dout_nocase;
	wire				index2_empty_nocase;
	wire				index2_full_nocase;
	wire				index2_valid_nocase;
	
		
	wire index_valid_0;
	wire index_valid_1;
	wire index_valid_2;
	wire index_valid_0_nocase;
	wire index_valid_1_nocase;
	wire index_valid_2_nocase;
	reg roundRobin0;
	reg roundRobin1;
	reg roundRobin2;
	
	assign index_valid_0 = (index!=0)&&(index <= no_type2);
	assign index_valid_1 = (index!=0)&&(index <= no_type4)&&(index > no_type2);
	assign index_valid_2 = (index!=0)&&(index <= no_type6)&&(index > no_type4);
	assign index_valid_0_nocase = (index_nocase!=0)&&(index_nocase <= no_type2);
	assign index_valid_1_nocase = (index_nocase!=0)&&(index_nocase <= no_type4)&&(index_nocase > no_type2);
	assign index_valid_2_nocase = (index_nocase!=0)&&(index_nocase <= no_type6)&&(index_nocase > no_type4);
	
	initial begin
			index0_rd_en = 0;
			index0_rd_en_nocase = 0;
			roundRobin0 = 0;
			index1_rd_en = 0;
			index1_rd_en_nocase = 0;
			roundRobin1 = 0;
			index2_rd_en = 0;
			index2_rd_en_nocase = 0;
			roundRobin2 = 0;
	end
	
	indexBuffer index0 (
	.clk(clk),
	.din(index0_din), // Bus [21 : 0] 
	.rd_en(index0_rd_en),
	.rst(rst),
	.wr_en(index0_wr_en),
	.data_count(index0_data_count), // Bus [8 : 0] 
	.dout(index0_dout), // Bus [21 : 0] 
	.empty(index0_empty),
	.full(index0_full),
	.valid(index0_valid));
	
	indexBuffer index0_nocase (
	.clk(clk),
	.din(index0_din_nocase), // Bus [21 : 0] 
	.rd_en(index0_rd_en_nocase),
	.rst(rst),
	.wr_en(index0_wr_en_nocase),
	.data_count(index0_data_count_nocase), // Bus [8 : 0] 
	.dout(index0_dout_nocase), // Bus [21 : 0] 
	.empty(index0_empty_nocase),
	.full(index0_full_nocase),
	.valid(index0_valid_nocase));
	
	indexBuffer index1 (
	.clk(clk),
	.din(index1_din), // Bus [21 : 0] 
	.rd_en(index1_rd_en),
	.rst(rst),
	.wr_en(index1_wr_en),
	.data_count(index1_data_count), // Bus [8 : 0] 
	.dout(index1_dout), // Bus [21 : 0] 
	.empty(index1_empty),
	.full(index1_full),
	.valid(index1_valid));
	
	indexBuffer index1_nocase (
	.clk(clk),
	.din(index1_din_nocase), // Bus [21 : 0] 
	.rd_en(index1_rd_en_nocase),
	.rst(rst),
	.wr_en(index1_wr_en_nocase),
	.data_count(index1_data_count_nocase), // Bus [8 : 0] 
	.dout(index1_dout_nocase), // Bus [21 : 0] 
	.empty(index1_empty_nocase),
	.full(index1_full_nocase),
	.valid(index1_valid_nocase));
	
	indexBuffer index2 (
	.clk(clk),
	.din(index2_din), // Bus [21 : 0] 
	.rd_en(index2_rd_en),
	.rst(rst),
	.wr_en(index2_wr_en),
	.data_count(index2_data_count), // Bus [8 : 0] 
	.dout(index2_dout), // Bus [21 : 0] 
	.empty(index2_empty),
	.full(index2_full),
	.valid(index2_valid));
		
	indexBuffer index2_nocase (
	.clk(clk),
	.din(index2_din_nocase), // Bus [21 : 0] 
	.rd_en(index2_rd_en_nocase),
	.rst(rst),
	.wr_en(index2_wr_en_nocase),
	.data_count(index2_data_count_nocase), // Bus [8 : 0] 
	.dout(index2_dout_nocase), // Bus [21 : 0] 
	.empty(index2_empty_nocase),
	.full(index2_full_nocase),
	.valid(index2_valid_nocase));

	assign index0_din = {index, (index_counter - BYTE_ADJUST)};
	assign index0_wr_en = index_valid_0;
	assign index0_din_nocase = {index_nocase, (index_counter - BYTE_ADJUST)};
	assign index0_wr_en_nocase = index_valid_0_nocase;
	
	always@(*)begin
		index0_rd_en  	= 0;
		index0_rd_en_nocase = 0;
		if(((!index0_empty)&&(index0_empty_nocase))
						|| ((!index0_empty)&&(!index0_empty_nocase)&&(index0_dout_nocase[10:0]>index0_dout[10:0])) 
						|| ((!index0_empty)&&(!index0_empty_nocase)&&((index0_dout_nocase[10:0]==index0_dout[10:0]))&&roundRobin0))begin
			index0_rd_en = 1;
		end else if(((index0_empty)&&(!index0_empty_nocase))
						|| ((!index0_empty)&&(!index0_empty_nocase)&&(index0_dout_nocase[10:0]<index0_dout[10:0]))
						|| ((!index0_empty)&&(!index0_empty_nocase)&&((index0_dout_nocase[10:0]==index0_dout[10:0]))&&(!roundRobin0)))begin
			index0_rd_en_nocase = 1;
		end 
	end
	
	always@(posedge clk)begin
		if(rst)begin
			clk_counter0 <= 0;
			index_out[0] <= 0;
			roundRobin0  <= 0;
		end
		else begin
			index_out[0] 	<= 0;
			if(index0_rd_en)begin
				index_out[0] <= index0_dout[21:11];
				clk_counter0 <= index0_dout[10:0] + 11'd1;
				roundRobin0  <= ~roundRobin0;
			end else if(index0_rd_en_nocase)begin
				index_out[0] <= index0_dout_nocase[21:11];
				clk_counter0 <= index0_dout_nocase[10:0] + 11'd1;
				roundRobin0  <= ~roundRobin0;
			end 
		end
	end
	
	assign index1_din = {index, (index_counter - BYTE_ADJUST)};
	assign index1_wr_en = index_valid_1;
	assign index1_din_nocase = {index_nocase, (index_counter - BYTE_ADJUST)};
	assign index1_wr_en_nocase = index_valid_1_nocase;
	
	always@(*)begin
		index1_rd_en  	= 0;
		index1_rd_en_nocase = 0;
		if(((!index1_empty)&&(index1_empty_nocase))
						|| ((!index1_empty)&&(!index1_empty_nocase)&&(index1_dout_nocase[10:0]>index1_dout[10:0])) 
						|| ((!index1_empty)&&(!index1_empty_nocase)&&((index1_dout_nocase[10:0]==index1_dout[10:0]))&&roundRobin1))begin
			index1_rd_en = 1;
		end else if(((index1_empty)&&(!index1_empty_nocase))
						|| ((!index1_empty)&&(!index1_empty_nocase)&&(index1_dout_nocase[10:0]<index1_dout[10:0]))
						|| ((!index1_empty)&&(!index1_empty_nocase)&&((index1_dout_nocase[10:0]==index1_dout[10:0]))&&(!roundRobin1)))begin
			index1_rd_en_nocase = 1;
		end 
	end
	
	always@(posedge clk)begin
		if(rst)begin
			clk_counter1 <= 0;
			index_out[1] <= 0;
			roundRobin1  <= 0;
		end
		else begin
			index_out[1] 	<= 0;
			if(index1_rd_en)begin
				index_out[1] <= index1_dout[21:11] - no_type2;
				clk_counter1 <= index1_dout[10:0];
				roundRobin1  <= ~roundRobin1;
			end else if(index1_rd_en_nocase)begin
				index_out[1] <= index1_dout_nocase[21:11] - no_type2;
				clk_counter1 <= index1_dout_nocase[10:0];
				roundRobin1  <= ~roundRobin1;
			end 
		end
	end
	
	assign index2_din = {index, (index_counter - BYTE_ADJUST)};
	assign index2_wr_en = index_valid_2;
	assign index2_din_nocase = {index_nocase, (index_counter - BYTE_ADJUST)};
	assign index2_wr_en_nocase = index_valid_2_nocase;
	
	always@(*)begin
		index2_rd_en  	= 0;
		index2_rd_en_nocase = 0;
		if(((!index2_empty)&&(index2_empty_nocase))
						|| ((!index2_empty)&&(!index2_empty_nocase)&&(index2_dout_nocase[10:0]>index2_dout[10:2])) 
						|| ((!index2_empty)&&(!index2_empty_nocase)&&((index2_dout_nocase[10:0]==index2_dout[10:2]))&&roundRobin2))begin
			index2_rd_en = 1;
		end else if(((index2_empty)&&(!index2_empty_nocase))
						|| ((!index2_empty)&&(!index2_empty_nocase)&&(index2_dout_nocase[10:0]<index2_dout[10:0]))
						|| ((!index2_empty)&&(!index2_empty_nocase)&&((index2_dout_nocase[10:0]==index2_dout[10:0]))&&(!roundRobin2)))begin
			index2_rd_en_nocase = 1;
		end 
	end
	
	always@(posedge clk)begin
		if(rst)begin
			clk_counter2 <= 0;
			index_out[2] <= 0;
			roundRobin2  <= 0;
		end
		else begin
			index_out[2] 	<= 0;
			if(index2_rd_en)begin
				index_out[2] <= index2_dout[21:11] - no_type4;
				clk_counter2 <= index2_dout[10:0];
				roundRobin2  <= ~roundRobin2;
			end else if(index2_rd_en_nocase)begin
				index_out[2] <= index2_dout_nocase[21:11] - no_type4;
				clk_counter2 <= index2_dout_nocase[10:0];
				roundRobin2  <= ~roundRobin2;
			end 
		end
	end
	
	always@(posedge clk)begin
		filter_trigger <= 0;
		indexFilterForSim <= 0;
		if ((index!=0)&&(index>no_type6)) begin
			filter_trigger <= 1;
			indexFilterForSim <= index;
		end
		if ((index_nocase!=0)&&(index_nocase>no_type6)) begin
			filter_trigger <= 1;
			indexFilterForSim <= index_nocase;
		end
	end
	
	function [11:0] get_index(input [4:0] module_match, input [8:0] addr_match);
		if (module_match == 0)
			get_index = 0;
		else if (module_match == 1)
			get_index = addr_match;
		else if (module_match == 2)
			get_index = sno1 + addr_match;
		else if (module_match == 3)
			get_index = sno2 +addr_match;
		else if (module_match == 4)
			get_index = sno3 +addr_match;
		else if (module_match == 5)
			get_index = sno4 +addr_match;
		else if (module_match == 6)
			get_index = sno5 +addr_match;
		else if (module_match == 7)
			get_index = sno6 +addr_match;
		else if (module_match == 8)
			get_index = sno7 +addr_match;
		else if (module_match == 9)
			get_index = sno8 +addr_match;
		else if (module_match == 10)
			get_index = sno9 +addr_match;
		else if (module_match == 11)
			get_index = sno10 +addr_match;
		else if (module_match == 12)
			get_index = sno11 +addr_match;
		else if (module_match == 13)
			get_index = sno12 +addr_match;
		else if (module_match == 14)
			get_index = sno13 +addr_match;
		else if (module_match == 15)
			get_index = sno14 +addr_match;
		else
			get_index = sno15 +addr_match;
	endfunction
		
		function [11:0] get_index_nocase(input [4:0] module_match, input [8:0] addr_match);
		if (module_match == 0) begin
			get_index_nocase = 0;
			
		end
		else if (module_match == 1)
			get_index_nocase = addr_match + sno16;
		else if (module_match == 2)
			get_index_nocase =  sno1_nocase + addr_match;
		else if (module_match == 3)
			get_index_nocase =  sno2_nocase +addr_match;
		else if (module_match == 4)
			get_index_nocase =  sno3_nocase +addr_match;
		else if (module_match == 5)
			get_index_nocase = sno4_nocase +addr_match;
		else if (module_match == 6)
			get_index_nocase = sno5_nocase +addr_match;
		else if (module_match == 7)
			get_index_nocase = sno6_nocase +addr_match;
		else if (module_match == 8)
			get_index_nocase = sno7_nocase +addr_match;
		else if (module_match == 9)
			get_index_nocase =   sno8_nocase +addr_match;
		else if (module_match == 10)
			get_index_nocase = sno9_nocase +addr_match;
		else if (module_match == 11)
			get_index_nocase = sno10_nocase +addr_match;
		else if (module_match == 12)
			get_index_nocase = sno11_nocase +addr_match;
		else if (module_match == 13)
			get_index_nocase = sno12_nocase +addr_match;
		else if (module_match == 14)
			get_index_nocase = sno13_nocase +addr_match;
		else if (module_match == 15)
			get_index_nocase = sno14_nocase +addr_match;
		else
			get_index_nocase = sno15_nocase +addr_match;
	endfunction
endmodule
