`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:34 09/13/2011 
// Design Name: 
// Module Name:    PMM_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Revision 0.02 - 20/9
// 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PMM_top(
		input clk,
		input rst,
		output pmm_ready,
		input [7:0] payload_in,
		input payload_valid,// indicate data is valid to receive
		input start_of_packet,
		input end_of_packet,
		output filter_trigger,
		output [10:0] rule_id, // rule ID + control bit (rule ID or not)
		output end_of_packet_shift,
		input enable_32byte_process,
		//cpci interface
		output reg udp_reg_ack,
		output reg [31:0] udp_reg_rd_data,

    	input  udp_reg_req,
    	input  udp_reg_rd_wr_L,
    	input  [19 :0] udp_reg_addr,
		input  [31:0] udp_reg_wr_data,
		//debug
		output [10:0] input_pmm_debug,
		output [12:0] output_pmm_debug,
		output [29:0] static_engine_debug,
		output [16:0] pcre_engine_debug,
		output [11:0] index,
		output [11:0] index_nocase,
		output [13:0] patternID,
		output [10:0] clk_counter,
		output [10:0] index_counter,
		output [51:0] debug_matching,
		output state
		); 
	//wire [13:0] patternID,patternID_nocase;
	//wire [13:0] patternID;
	wire [13:0] patternID_nocase;
	wire [6:0] curPacketID;
	wire [9:0] pcreID;
	wire [9:0] preHash_T1;
	wire [9:0] preHash_T2;
	wire [159:0] fifo_in;
	wire [159:0] fifo_in_nocase;
	wire endState_7,endState_12;
	wire pcre_ready;
	//assign pcre_ready =1;
	
	//debug
	wire [13:0] debug_rawPatternID;
	wire [4:0]  debug_state_buf;
	wire [13:0] debug_rawPatternID_nocase;
	wire [4:0]  debug_state_buf_nocase;
	
	assign input_pmm_debug = {payload_in,payload_valid,start_of_packet,end_of_packet};//8+1+1+1
	assign output_pmm_debug = {rule_id,filter_trigger,end_of_packet_shift};//11+1+1
	
	assign static_engine_debug = {state,endState_12,patternID,patternID_nocase};//1+1+14+14
	assign pcre_engine_debug = {pcreID,curPacketID}; //10+7
	
//	//debug
//	fifo_in,debug_rawPatternID, debug_state_buf, patternID
//	fifo_in_nocase, debug_rawPatternID_nocase, debug_state_buf_nocase, patternID_nocase
//	
	/*
	wire [13:0] patternID;
	wire [13:0] patternID_nocase;
	*/
	
	assign debug_matching = {debug_rawPatternID, debug_rawPatternID_nocase, index, index_nocase};
	
	always@(negedge clk) begin
		//$strobe("[PMM Top] At time %0t compare_out %b %b",$time,compare_out,compare_out_nocase);
	end 
	
	match_static_engine match_static_engine(
		.clk(clk),
		.rst(rst),
		.enable(1'b1),
		.preHash_T1(preHash_T1),
		.preHash_T2(preHash_T2),
		.fifo_in(fifo_in),
		.fifo_in_nocase(fifo_in_nocase),
		.patternID(patternID),
		.patternID_nocase(patternID_nocase),
		.endState_7(endState_7),
		.endState_12(endState_12),
		.debug_rawPatternID(debug_rawPatternID),
		.debug_state_buf(debug_state_buf),
		.debug_rawPatternID_nocase(debug_rawPatternID_nocase),
		.debug_state_buf_nocase(debug_state_buf_nocase)
	);
	
	assign pmm_ready = 1'b1;
	control_engine_new control_engine (
		//signal from and to PMM interface
		.clk(clk),
		.rst(rst),
		//.pmm_ready(pmm_ready),
		.payload_in(payload_in),
		.payload_valid(payload_valid),
		.start_of_packet(start_of_packet),
		.end_of_packet(end_of_packet),
		.end_of_packet_shift(end_of_packet_shift),
		.filter_trigger(filter_trigger),
		.rule_id(rule_id),
		.enable_32byte_process(enable_32byte_process),
		//signal from and to static engine
		.preHash_T1(preHash_T1),
		.preHash_T2(preHash_T2),
		.fifo_in(fifo_in),
		.fifo_in_nocase(fifo_in_nocase),
		.state(state),
		.patternID(patternID),
		.patternID_nocase(patternID_nocase),
		.endState_7(endState_7),
		.endState_12(endState_12),
		//signal from and to pcre engine
		.pcreID(pcreID),
		.curPacketID(curPacketID),
		.pcre_ready(pcre_ready),
		//debug
		.index(index),
		.index_nocase(index_nocase),
		.clk_counter(clk_counter),
		.index_counter(index_counter)
		
	);
	
//	
	//assign pcre_ready = 1;
	//assign pcreID = 0;
	/*
	match_pcre_engine match_pcre_engine(
		.clk(clk),
		.fifo_in(fifo_in),
		.pcreID(pcreID),
		.start_of_packet(start_of_packet),
		.end_of_packet(end_of_packet_shift),
		.payload_valid(payload_valid),
		.flow_in(curPacketID),
		.ready(pcre_ready)
	);*/
	wire [9:0] debug_pcre_ID;
	wire debug_pcre_ID_vld;
	match_pcre_engine_new match_pcre_engine(
		.clk(clk),
		.rst(rst),
		.fifo_in(payload_in),
		.flow_in(curPacketID),
		.start_of_packet(start_of_packet),
		.end_of_packet(end_of_packet),
		.payload_valid(payload_valid),
		.ready(pcre_ready),
		.pcre_rule_ID(pcreID),//indeed this is rule ID.
		//debug
		.pcre_ID_vld(debug_pcre_ID_vld),
		.pcre_ID(debug_pcre_ID)
		);
	




	/*** CPCI signal handle ****/
	//registers
	reg [31:0] no_RuleID;
	reg [10:0] last_RuleID;
	reg [9:0] last_PCREID, last_pcre_ruleID;
	reg [16:0] no_PCREID;
	reg [16:0] no_patternID, no_patternID_nocase;
	reg [10:0] last_patternID, last_patternID_nocase;

	reg [31:0] debug_chars;
	always@(posedge clk)
	begin
		if(rst)begin
			no_RuleID <= 'd0;
			last_RuleID <= 'd0;

			no_patternID <= 'd0;
			no_patternID_nocase <= 'd0;

			last_patternID <= 'd0;
			last_patternID_nocase <= 'd0;
			
			last_PCREID <= 'd0;
			no_PCREID <= 'd0;

			last_pcre_ruleID <='d0;

			debug_chars <= 'd0;
		end
		else begin
			last_RuleID <= last_RuleID;
			no_RuleID <= no_RuleID;
			no_patternID_nocase <= no_patternID_nocase;
			no_patternID <= no_patternID;
			last_patternID <= last_patternID;
			last_patternID_nocase <= last_patternID_nocase;
			if(rule_id != 'd0)
			begin
				last_RuleID <= rule_id;
				no_RuleID <= no_RuleID + 'd1;
			end
			if(patternID != 'd0)
			begin
				last_patternID <= patternID;
				no_patternID <= no_patternID + 'd1;
			end
			if(patternID_nocase != 'd0)
			begin
				last_patternID_nocase <= patternID_nocase;
				no_patternID_nocase <= no_patternID_nocase + 'd1;
			end

			if(debug_pcre_ID_vld != 1'b0)
			begin
				last_PCREID <= debug_pcre_ID;
				no_PCREID <= no_PCREID + 1'b1;
			end

			if(pcreID != 'd0)
				last_pcre_ruleID <= pcreID;

			//start_of_packet_buf <= start_of_packet;
			if(start_of_packet)
				debug_chars[7:0] <= payload_in;

			if(end_of_packet)
				debug_chars[15:8] <= payload_in;


		end
	end


	//interconnect
	always @(posedge clk)
	begin
		if(rst) begin
			udp_reg_ack <= 1'b0;
			udp_reg_rd_data <= 32'hfeedfeed;
		end
		else begin
			if(udp_reg_req) begin 
				udp_reg_ack <= 1'b1;
				if(udp_reg_rd_wr_L) begin //request read
					case(udp_reg_addr[4:0])	//--> 0x03c00000 + x shift move 2
					5'h00: udp_reg_rd_data <= 32'haaaaaaaa;
					5'h01: udp_reg_rd_data <= no_RuleID;
					5'h02: udp_reg_rd_data <= last_RuleID;
					5'h03: udp_reg_rd_data <= no_PCREID;
					5'h04: udp_reg_rd_data <= last_PCREID;
					5'h05: udp_reg_rd_data <= last_pcre_ruleID;
					5'h06: udp_reg_rd_data <= debug_chars;
					
					default: udp_reg_rd_data <= 32'hdeaddead;
					endcase
				end
				else begin //request write.
					case(udp_reg_addr[4:0])	//--> 0x03c0000x + x shift move 2
					5'h00: begin
					end
					
					default: udp_reg_rd_data <= 32'hbeefbeef;
					endcase
				end
			end
			else begin
				udp_reg_ack <= 1'b0;
				udp_reg_rd_data <= 32'hd00dd00d;
			end
		end
	end
	
	
endmodule
