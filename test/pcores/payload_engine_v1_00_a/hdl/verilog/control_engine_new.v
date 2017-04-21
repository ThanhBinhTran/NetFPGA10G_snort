`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:22:47 06/13/2013
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
module control_engine_new(
	//signal <-> PMM interface
	input clk,
	input rst,
	input [7:0] payload_in,
	input payload_valid,// indicate data is valid to receive
	input start_of_packet,
	input end_of_packet,
	output reg pmm_ready,

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
	 `include "src/payload/constant.v"
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
	
/*
	localparam INITIAL = 3'd0;
	localparam SCANNING = 3'd1;
	localparam WAITING = 3'd2;
	localparam STALLING = 3'd3;

	reg [2:0] state;
	reg [2:0] next_state;
	reg matching_ready

	always@(posedge clk)
	begin
		if(rst)
			state <= INITIAL;
		else
			state <= next_state;
	end

	always@(*)
	begin
		case(state)
			INITIAL: begin
				if(payload_valid == 1'b1)
					next_state = SCANNING;
				else
					next_state = WAITING;
			end
			SCANNING: begin
				if(payload_valid == 1'b0)
					next_state = WAITING;
				else
					next_state = SCANNING;
			end
			WAITING: begin
			end
			STALLING: begin

			end
			default: begin
				next_state = INITIAL;
			end
		endcase
	end
*/

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
	 
	/*
	end_signal_shift eop_shift (
		.d(end_of_packet), // Bus [0 : 0] 
		.clk(clk),
		.q(end_of_packet_shift)); // Bus [0 : 0] 
	*/
	
		
	option_process contents_process(
		.index_counter(index_counter),
		.clk(clk),
		.rst(rst),
		.curPacketID(curPacketID),
		.state(state),
		.patternID_in(patternID),
		.patternID_in_nocase(patternID_nocase),
		.pcreID(pcreID),
		.filter_trigger(filter_trigger),
		.end_of_packet_shift(end_of_packet_shift), 
		.enable_32byte_process(enable_32byte_process),
		//debug signals.
		.patternID_out1(patternID_out1),
		.patternID_out3(patternID_out3),
		.patternID_out5(patternID_out5),
		.index(index),
		.index_nocase(index_nocase),
		.clk_counter0(clk_counter)
		);
	
	combine_pcre combine_content_pcre(
		.clk(clk),
		.flow(curPacketID),
		.state(state),
		.end_of_packet_shift(end_of_packet_shift),
		.patternID_out1(patternID_out1),
		.patternID_out3(patternID_out3),
		.patternID_out5(patternID_out5),
		.patternID_pcre(pcreID),
		.real_patternID(rule_id),
		.combine_ready(combine_ready)
		);

	//Behavior 
	
	
	// processing control
	always@(posedge end_of_packet_shift) begin
		curPacketID = curPacketID + 7'b1;
	end
	
	reg wait_fin;

	always@(posedge clk) begin
		if(rst) begin
			state <= 0;
			endState_7 <= 0;
			endState_12 <= 0;
			eop <= 0;
			eop_counter <= 0;
			end_of_packet_shift <= 0;
			payload_in_buf <= 0;
			pmm_ready <= 1'b1;
			wait_fin <= 1'b0;

		end
		else begin
			if(end_of_packet)begin
				wait_fin <= 1'b1;
				pmm_ready <= 1'b0;
			end

			if(wait_fin && end_of_packet_shift)begin
				wait_fin <= 1'b0;
				pmm_ready <= 1'b1;
			end



			if (start_of_packet)begin
				endState_7 <= 0;
				endState_12 <= 0;
			end 
			else begin
				if (end_of_matching_shift_7) begin
					endState_7 <= 1;
				end
				if (end_of_matching_shift_12) begin
					endState_12 <= 1;
				end
			end

			if (end_of_packet) 
				eop <= 1;
					
			if ((eop_counter >= 24) && pcre_ready_shift[4] && combine_ready) begin
				end_of_packet_shift <= 1;
				eop <= 0;
				eop_counter <= 0;
				state <= 0;
			end
			else begin
				if (eop && eop_counter < 2047)
					eop_counter <= eop_counter + 1;
				end_of_packet_shift <= 0;
				if (start_of_packet)
					state <= 1;
			end
			
			//payload in 
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
