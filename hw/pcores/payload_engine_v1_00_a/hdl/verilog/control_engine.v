`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:47 09/13/2011 
// Design Name: 
// Module Name:    control_engine 
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
module control_engine(
	//signal <-> PMM interface
	input clk,
	input rst,
	input [7:0] payload_in,
	input payload_valid,// indicate data is valid to receive
	input start_of_packet,
	input end_of_packet,
	output filter_trigger,
	output [10:0] rule_id, // rule ID + control bit (rule ID or not)
	input enable_32byte_process,
	output reg end_of_packet_shift,
	output [11:0] addra,addrb,
	output [11:0] index,
	output [11:0] index_nocase,
	output [11:0] index_out1,
	output [11:0] index_out2,
	output [11:0] index_out3,
	output [10:0] patternID_out1,
	output [10:0] patternID_out3,
	output [10:0] patternID_out5,
	output [9:0] next_id,
	output  web_valid,
	output [55:0] ramT1_out,
	output valid_link,
	output  match,
	output [17:0] valid1,valid2,
	output  wea_valid,
	output web_valid1,web_valid2,wea_valid1,wea_valid2,
	output [17:0] din_valid1,din_valid2,
	output select,
	output [16:0] counter_flow,
	output reg [6:0] curPacketID,
	output  [10:0] out1,out2,out3,
	output [8:0] dout,
	output [9:0] patternID_out2,
	output [9:0] patternID_out4,
	output [9:0] patternID_out6,
	output we,
	output [8:0] din,
	//signal <-> match static interface
	output reg [9:0] preHash_T1,
	output reg [9:0] preHash_T2,
	output reg [159:0] fifo_in,
	output reg [159:0] fifo_in_nocase,
	output reg state,
	output reg endState_7,
	output reg endState_12,
	input [13:0] patternID,
	input [13:0] patternID_nocase,
	//signal <-> match pcre interface
	input [9:0] pcreID,
	input pcre_ready,
	//debug
	output reg [10:0] index_counter,
	output [10:0] clk_counter
    );
	 `include "src/PMM/constant.v"
	//register and net define value
	//reg [10:0] index_counter;
	reg [7:0] payload_in_buf;
	wire end_of_matching_shift_7,end_of_matching_shift_12;
	reg eop;
	reg [5:0] eop_counter;
	wire [10:0] patternID_out; //pattern with option check - index
	reg [10:0] pcre_ready_shift;
	reg combine_ready_shift;
	wire combine_ready;
	
	end_matching_shift em_shift (
		.d(end_of_packet), // Bus [0 : 0] 
		.clk(clk),
		.q(end_of_matching_shift_7)); // Bus [0 : 0] 
	
	end_matching_shift_12 em_shift_12 (
		.d(end_of_packet), // Bus [0 : 0] 
		.clk(clk),
		.q(end_of_matching_shift_12)); // Bus [0 : 0]
		
	initial begin
		preHash_T1 = PRE_HASH_T1;
		preHash_T2 = PRE_HASH_T2;
		fifo_in = 0;
		payload_in_buf =0;
		fifo_in_nocase = 0;
		state = 0;
		curPacketID = 1;
		index_counter = 0;
		payload_in_buf = 0;
		endState_7 = 1;
		endState_12 = 1;
		eop_counter = 0;
		eop = 0;
		pcre_ready_shift = 0;
		combine_ready_shift = 0;
	end
	//reg [10:0] operating = 0;
	//Assigment
	//assign end_of_packet_shift = (eop_counter >= 18 && combine_ready) ? 1 : 0;
	always@(posedge clk) begin
		//combine_ready_shift <= combine_ready;
		
		
	 end
	 
	/*
	end_signal_shift eop_shift (
		.d(end_of_packet), // Bus [0 : 0] 
		.clk(clk),
		.q(end_of_packet_shift)); // Bus [0 : 0] 
	*/
	
		
	option_process contents_process(index_counter,
												clk,
												rst,
												curPacketID,
												state,
												patternID,
												patternID_nocase,
												pcreID,
												filter_trigger,
												end_of_packet_shift, 
												enable_32byte_process,
												patternID_out1,
												patternID_out3,
												patternID_out5,
												index,
												index_nocase,
												clk_counter);
	
	combine_pcre combine_content_pcre(clk,
											curPacketID,state,end_of_packet_shift,patternID_out1,patternID_out3,patternID_out5,pcreID,rule_id,combine_ready);
	
	always@(negedge clk) begin
		//$display(" \n");
		//$strobe("[Control Engine] At time %0t fifo %h %h",$time,fifo_in,fifo_in_nocase);
		//$strobe("[Control Engine] At time %0t compare_out %b %b",$time,compare_out_buf,compare_out_nocase_buf);
		//$strobe("[Control Engine] At time %0t addr_out_portA_nocase_buf[1]11 %d state_nocase_buf %d",$time,addr_out_portA_nocase_buf[1][98:90],state_nocase_buf);
		//$strobe("[Control Engine] At time %0t raw_id %b %b",$time,raw_patternID[1],raw_patternID_nocase[1]);
		//$strobe("[Control Engine] At time %0t pattern_ID %b %b",$time,patternID,patternID_nocase);
		//$strobe("[Control Engine] At time %0t rule_id %d",$time,rule_id);
	end
	
	//Behavior 
	
	
	// processing control
	always@(posedge end_of_packet_shift) begin
		curPacketID = curPacketID + 7'b1;
	end
	
	always@(posedge clk) begin
		if (start_of_packet)begin
			state = 1;
			endState_7 = 0;
			endState_12 = 0;
		end
		if (end_of_matching_shift_7) begin
			endState_7 = 1;
		end
		if (end_of_matching_shift_12) begin
			endState_12 = 1;
		end
		if (end_of_packet) eop <= 1;
				
		
			
		if ((eop_counter >= 19) && pcre_ready_shift[4] && combine_ready) begin
			end_of_packet_shift <= 1;
			eop <= 0;
			eop_counter = 0;
			state = 0;
		end
		else begin
			if (eop && eop_counter < 2047)
				eop_counter = eop_counter + 1;
			end_of_packet_shift <= 0;
		end
		
		payload_in_buf <= payload_in;
		
		if ((payload_in_buf>=65) && (payload_in_buf <=90))
			fifo_in_nocase <= {fifo_in_nocase[151:0], payload_in_buf+8'd32};
		else 
			fifo_in_nocase <= {fifo_in_nocase[151:0], payload_in_buf};
		fifo_in <= {fifo_in[151:0], payload_in_buf};
		
		case(state)
			0: begin
				initialState;
			end
			1: begin
				index_counter <= index_counter + 1;
				pcre_ready_shift <= (pcre_ready_shift << 1'b1) + pcre_ready;
			end
		endcase
	end
	//task and function
	task initialState;
		begin
			//fifo_in <= 0;
			//fifo_in_nocase <= 0;
			index_counter <= 0;
			//eop <= 0;
			//eop_counter <= 0;
			pcre_ready_shift <= 0;
		end
	endtask
	
	
endmodule
