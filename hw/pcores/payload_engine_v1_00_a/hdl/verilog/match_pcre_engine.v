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
module match_pcre_engine(
   input clk,
	input rst,
   input [7:0] fifo_in,
	input [6:0] flow_in,
	input start_of_packet,
	input end_of_packet,
	input payload_valid,
	output ready,
   output [9:0] pcreID
    );
	integer i;
	
	//decode_8bit();
	wire [214:0] raw_ID;
	wire [9:0] pcre_ID;
	reg [9:0] eod_shift = 0;
	reg state = 0;
	reg start_of_packet_buf;
	reg [5:0] end_of_packet_buf;
	get_pcre get_pcre(
		.clk(clk),
		.rst(rst),
		.vector({9'b0,raw_ID}),
		.eop(~state&ready),
		.ready(ready),
		.ruleID(pcre_ID)
		);
	
	process_pcre pp(.clk(clk),
					.index_in(pcre_ID),
					.index_out(pcreID),
					.end_of_packet_shift(~state&ready),
					.flow_in(flow_in));
	
	always@(posedge clk) begin
		if(rst)begin
			start_of_packet_buf <= 'd0;
			state <= 'd0;
		end
		else begin
			end_of_packet_buf <= {end_of_packet_buf[4:0],end_of_packet};

			start_of_packet_buf <= start_of_packet;
			if (start_of_packet)begin
				state = 1;
			end
			if (end_of_packet) begin
				state = 0;
			end
		end
	 end
	
	Group_0 M(
			.out(raw_ID),
			.rst(rst),
			.clk(clk),
			.sod(start_of_packet_buf),
			.en(state),
			.char(fifo_in)//,
			//.eod_shift(~state&ready)
			);
	
	always@(posedge clk) begin
		//eod_shift <= (eod_shift << 1'b1) + end_of_packet;
	end
	
endmodule

module get_pcre(
    input clk,
	 input rst,
	 input [223:0] vector,
	 input eop,
	 output ready,
    output reg [9:0] ruleID
    );
	wire [9:0] rule[15:0];
	wire [15:0] s_permission;
	initial begin
		ruleID = 0;
	end
	integer i;
	assign ready = s_permission[13];
	PCRE_L #(15,3,0) P0(clk,1'b1,vector[15:0],eop,s_permission[0],rule[0]);
	PCRE_L #(15,3,16) P1(clk,s_permission[0],vector[31:16],eop,s_permission[1],rule[1]);
	PCRE_L #(15,3,32) P2(clk,s_permission[1],vector[47:32],eop,s_permission[2],rule[2]);
	PCRE_L #(15,3,48) P3(clk,s_permission[2],vector[63:48],eop,s_permission[3],rule[3]);
	PCRE_L #(15,3,64) P4(clk,s_permission[3],vector[79:64],eop,s_permission[4],rule[4]);
	PCRE_L #(15,3,80) P5(clk,s_permission[4],vector[95:80],eop,s_permission[5],rule[5]);
	PCRE_L #(15,3,96) P6(clk,s_permission[5],vector[111:96],eop,s_permission[6],rule[6]);
	PCRE_L #(15,3,112) P7(clk,s_permission[6],vector[127:112],eop,s_permission[7],rule[7]);
	PCRE_L #(15,3,128) P8(clk,s_permission[7],vector[143:128],eop,s_permission[8],rule[8]);
	PCRE_L #(15,3,144) P9(clk,s_permission[8],vector[159:144],eop,s_permission[9],rule[9]);
	PCRE_L #(15,3,160) P10(clk,s_permission[9],vector[175:160],eop,s_permission[10],rule[10]);
	PCRE_L #(15,3,176) P11(clk,s_permission[10],vector[191:176],eop,s_permission[11],rule[11]);
	PCRE_L #(15,3,192) P12(clk,s_permission[11],vector[207:192],eop,s_permission[12],rule[12]);
	PCRE_L #(15,3,208) P13(clk,s_permission[12],vector[223:208],eop,s_permission[13],rule[13]);
	//PCRE_L #(15,3,224) P14(clk,s_permission[13],vector[239:224],eop,s_permission[14],rule[14]);
	//PCRE_L #(15,3,240) P15(clk,s_permission[14],vector[255:240],eop,s_permission[15],rule[15]);
	
	always@(posedge clk) begin
		ruleID = 0;
		for (i=0;i<13;i=i+1) begin
			if (rule[i] != 0)
				ruleID = rule[i];
		end
		/*
		if (rule[0]) begin 
			ruleID = rule[0];
		end
		else if (rule[1]) begin 
			ruleID = rule[1];
		end
		else if (rule[2]) begin 
			ruleID = rule[2];
		end
		else if (rule[3]) begin 
			ruleID = rule[3];
		end
		else if (rule[4]) begin 
			ruleID = rule[4];
		end
		else if (rule[5]) begin 
			ruleID = rule[5];
		end
		else if (rule[6]) begin 
			ruleID = rule[6];
		end
		else if (rule[7]) begin 
			ruleID = rule[7];
		end
		else if (rule[8]) begin 
			ruleID = rule[8];
		end
		else if (rule[9]) begin 
			ruleID = rule[9];
		end
		else if (rule[10]) begin 
			ruleID = rule[10];
		end
		else if (rule[11]) begin 
			ruleID = rule[11];
		end
		else if (rule[12]) begin 
			ruleID = rule[12];
		end
		else if (rule[13]) begin 
			ruleID = rule[13];
		end
		else if (rule[14]) begin 
			ruleID = rule[14];
		end
		else if (rule[15]) begin 
			ruleID = rule[15];
		end
		*/
	end
	
endmodule