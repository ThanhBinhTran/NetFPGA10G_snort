`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:01:46 09/26/2011 
// Design Name: 
// Module Name:    match_pcre_engine 
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
module match_pcre_engine_new(
	input clk,
	input rst,
	input [7:0] fifo_in,
	input [6:0] flow_in,
	input start_of_packet,
	input end_of_packet,
	input payload_valid,
	output reg ready,
	output [9:0] pcre_rule_ID,
	//debug
	output pcre_ID_vld,
	output [9:0] pcre_ID,
	output pcre_ID_empty
	);
	integer i;
	
	//decode_8bit();
	wire [97:0] raw_ID;
	//wire [9:0] pcre_ID;
	reg [9:0] eod_shift = 0;
	reg state = 0;
	reg start_of_packet_buf;
	reg [20:0] end_of_packet_buf;

	wire pcre_ID_ren;
	//wire pcre_ID_empty;
	wire pcre_rule_ID_vld;
	wire [9:0] pcre_ID_format;
	
	assign pcre_ID_format = pcre_ID_vld?pcre_ID:'d0;
	process_pcre pp(
		.clk(clk),
		.index_in(pcre_ID_format),
		.index_out(pcre_rule_ID),
		.end_of_packet_shift(1'b0),
		.flow_in(flow_in));
	
	always@(posedge clk) begin
		if(rst)begin
			end_of_packet_buf <= 'd0;

		end
		else begin
			end_of_packet_buf <= {end_of_packet_buf[19:0],end_of_packet};

		end
	end
	
	//Read enable and valid control
	//since first word fall through fifo, there is no delay.
	assign pcre_ID_ren = ~pcre_ID_empty;
	//assign pcre_rule_ID_vld = pcre_ID_ren;
	assign pcre_ID_vld = pcre_ID_ren;
	//control ready signal
	
	reg wait_fin;
	always@(posedge clk) begin
		if(rst) begin
			ready <= 1;
			wait_fin <= 0;
		end
		else begin
			if(start_of_packet)
				wait_fin <= 1'b0;
			else if(end_of_packet_buf[14])
				wait_fin <= 1'b1;
			if(end_of_packet)
				ready <= 1'b0;
			else if(wait_fin && pcre_ID_empty) begin // at state wait for finish and there is no pcreID remain in fifo.
				ready <= 1'b1;
			end
		end
	end
	
	Group_0 M(
			.out(raw_ID),
			.rst(rst),
			.clk(clk),
			.sod(start_of_packet),
			.en(payload_valid),
			.char(fifo_in),
			.eod(end_of_packet)
			);

	
	assign pcre_ID[9] = 0;
	indexer256 #(
		.VECTOR_SIZE(98)
	) get_pcre_id (
		.clk(clk),
		.rst(rst),

		.ld(end_of_packet_buf[9]), //bitvector should be valid after 5 clks.
		.rd_en(pcre_ID_ren),

		.i_din(raw_ID),
		.empty(pcre_ID_empty),

		.o_dout(pcre_ID[8:0])
    );
	
endmodule
