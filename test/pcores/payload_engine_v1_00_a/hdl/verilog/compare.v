`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:37:01 05/20/2010 
// Design Name: 
// Module Name:    compare 
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
module compare #(parameter WIDTH = 7)(clk,rst,dataA, dataB, inputCompare, out, suffix);
	input clk;
	input rst;
    input [WIDTH:0] dataA;
    input [WIDTH:0] dataB;
    input [WIDTH-2:0] inputCompare;
    output reg [1:0] out;
	output reg [1:0] suffix;
	 
	 always@ (posedge clk) begin
		//$display("At time %d Value of douta: %h doutb: %h inputCompare: %h",$time,dataA[WIDTH:2],dataB[WIDTH:2],inputCompare);
		if(rst) begin
			out <= 'd0;
			suffix <= 'd0;
		end
		else begin
			if ((dataA[WIDTH:2] == inputCompare)) begin
				out <= 1;
				suffix <= dataA[1:0];
			end
			else if ((dataB[WIDTH:2] == inputCompare))begin
				out <= 2;
				suffix <= dataB[1:0];
			end
			else begin
				out <= 0;
				suffix <= 0;
			end
		end
		//$strobe("xxxxxxxxxxxxxhxx %b",out);
	 end
	 

endmodule
