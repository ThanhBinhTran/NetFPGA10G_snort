`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:14:19 04/06/2013
// Design Name: 
// Module Name:    Cuckoo_L2 
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
module Cuckoo_L2(
     // fixed I/O
	 input clk,
	 input rst,
	 input enable,
	 //case sensitive interface
	 input [9:0] preHash_T1,
	 input [9:0] preHash_T2,
	 output reg [9:0] addr_in_T1,
	 output reg [9:0] addr_in_T2,
	 input [159:0] fifo_in,
	 output [8:0] addr_in_portA,
	 output [8:0] addr_in_portB,
	 output [1:0] compare_out,
	 output [1:0] suffix,
	 //nocase interface
	 input [9:0] preHash_T1_nocase,
	 input [9:0] preHash_T2_nocase,
	 output reg [9:0] addr_in_T1_nocase,
	 output reg [9:0] addr_in_T2_nocase,
	 input [159:0] fifo_in_nocase,
	 output [8:0] addr_in_portA_nocase,
	 output [8:0] addr_in_portB_nocase,
	 output [1:0] compare_out_nocase,
	 output [1:0] suffix_nocase
    );
	 
	 //fixed parameter
	 wire [8:0] data_out_T1;
	 wire [8:0] data_out_T2;
	 wire [8:0] data_out_T1_nocase;
	 wire [8:0] data_out_T2_nocase;
	 
	 //varied parameter
	 wire [17:0] doutB;
	 wire [17:0] doutA;
	 wire [17:0] doutB_nocase;
	 wire [17:0] doutA_nocase;


	 
	 /*****Stage 1*****/
	 //hash module
	 always@(posedge clk) begin
		if(rst) begin
			addr_in_T1 <= 'd0;		
			addr_in_T2 <= 'd0;
			addr_in_T1_nocase <= 'd0;
			addr_in_T2_nocase <= 'd0;
		end
		else
		begin
			if(enable)
			begin
				addr_in_T1 <= (({preHash_T1[6:0],3'b000} + {3'b000,preHash_T1[9:3]} + fifo_in[7:0]) ^ preHash_T1); //varied code
				addr_in_T2 <= (({preHash_T2[6:0],3'b000} + {3'b000,preHash_T2[9:3]} + fifo_in[7:0]) ^ preHash_T2); //varied code
			
				addr_in_T1_nocase <= (({preHash_T1_nocase[6:0],3'b000} + {3'b000,preHash_T1_nocase[9:3]} + fifo_in_nocase[7:0]) ^ preHash_T1_nocase); //varied code
				addr_in_T2_nocase <= (({preHash_T2_nocase[6:0],3'b000} + {3'b000,preHash_T2_nocase[9:3]} + fifo_in_nocase[7:0]) ^ preHash_T2_nocase); //varied code
			end
			else 
			begin
				addr_in_T1 <= addr_in_T1;		
				addr_in_T2 <= addr_in_T2;
				addr_in_T1_nocase <= addr_in_T1_nocase;
				addr_in_T2_nocase <= addr_in_T2_nocase;
			end
		end
	 end
	 
	 
	 
	/*****Stage 2*****/ 
	//case
	ram_l2 ram_T12 (
		.clka(clk),
		.dina(9'b0), // Bus [8 : 0] 
		.addra({1'b0,addr_in_T1}), // Bus [10 : 0] 
		.wea(1'b0), // Bus [0 : 0] 
		.douta(data_out_T1), // Bus [8 : 0] 
		.clkb(clk),
		.dinb(9'b0), // Bus [8 : 0] 
		.addrb({1'b1,addr_in_T2}), // Bus [10 : 0] 
		.web(1'b0), // Bus [0 : 0] 
		.doutb(data_out_T2)); // Bus [8 : 0] 

	assign addr_in_portA = data_out_T1;
	assign addr_in_portB = data_out_T2;
		
	//nocase
	ram_l2_nocase ram_T12_nocase (
		.clka(clk),
		.dina(9'b0), // Bus [8 : 0] 
		.addra({1'b0,addr_in_T1_nocase}), // Bus [10 : 0] 
		.wea(1'b0), // Bus [0 : 0] 
		.douta(data_out_T1_nocase), // Bus [8 : 0] 
		.clkb(clk),
		.dinb(9'b0), // Bus [8 : 0] 
		.addrb({1'b1,addr_in_T2_nocase}), // Bus [10 : 0] 
		.web(1'b0), // Bus [0 : 0] 
		.doutb(data_out_T2_nocase)); // Bus [8 : 0] 	
		
	assign addr_in_portA_nocase = data_out_T1_nocase;
	assign addr_in_portB_nocase = data_out_T2_nocase;	
	
	/*****Stage 3*****/	
	//case
	ram_t3_l2 ram_T3 ( //varied ram
		.clka(clk),
		.dina(18'd0), // Bus [17:0]
		.addra(addr_in_portA), // Bus [8 : 0] 
		.wea(1'b0), // Bus [0 : 0] 
		.douta(doutA), // Bus [17 : 0] 
		.clkb(clk),
		.dinb(18'd0), // Bus [17 : 0] 
		.addrb(addr_in_portB), // Bus [8 : 0] 
		.web(1'b0), // Bus [0 : 0] 
		.doutb(doutB)); // Bus [17 : 0] 
	//no case
	ram_t3_l2_nocase ram_T3_nocase ( //varied ram
		.clka(clk),
		.dina(18'd0), // Bus [17 : 0]
		.addra(addr_in_portA_nocase), // Bus [8 : 0] 
		.wea(1'b0), // Bus [0 : 0] 
		.douta(doutA_nocase), // Bus [17 : 0] 
		.clkb(clk),
		.dinb(18'd0), // Bus [17 : 0] 
		.addrb(addr_in_portB_nocase), // Bus [8 : 0] 
		.web(1'b0), // Bus [0 : 0] 
		.doutb(doutB_nocase)); // Bus [17 : 0] 
		
	/*****Stage 4*****/
	//case
	compare #(17) comp(
					.clk(clk),
					.rst(rst),
					.dataA(doutA), 
					.dataB(doutB), 
					.inputCompare(fifo_in[47:32]), 
					.out(compare_out), 
					.suffix(suffix));
	//no case
	compare #(17) comp1(
					.clk(clk),
					.rst(rst),
					.dataA(doutA_nocase), 
					.dataB(doutB_nocase), 
					.inputCompare(fifo_in_nocase[47:32]), 
					.out(compare_out_nocase), 
					.suffix(suffix_nocase));
endmodule

