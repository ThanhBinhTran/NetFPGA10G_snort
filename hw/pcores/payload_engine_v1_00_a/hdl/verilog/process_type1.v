`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:14:39 05/25/2011 
// Design Name: 
// Module Name:    process_type1 
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
// latancy 1 clk
//////////////////////////////////////////////////////////////////////////////////
module process_type1(
	input clk,
	input [10:0] index_counter, // cham mot nhip so voi index_in
	input [10:0] index_in,
	input enable_32byte_process,
    output reg [10:0] index_out
    );
	
	wire [11:0] depth;
	wire [11:0] offset;
	wire [23:0] douta;
	reg [10:0] index_counter_buf_1;
	
	reg valid = 0;
	reg [10:0] index_buffer;
	initial begin
		index_buffer = 0;
		index_out = 0;
		index_counter_buf_1 = 0;
	end
	ram_type1 ramt1 (
		.clka(clk),
		.dina(24'b0), // Bus [23 : 0] 
		.addra(index_in), // Bus [9 : 0] 
		.wea(1'b0), // Bus [0 : 0] 
		.douta(douta)); // Bus [23 : 0] 
	
	assign depth  = douta[23:12];
	assign offset  = douta[11:0];

//	always@(*) begin
//		valid = 0;
//		if (index_buffer != 0)begin
//			if (index_counter_buf_1 <= 32)begin
//				valid = 1;
//			end else if ((index_counter_buf_1 <= (depth + 32)) && (index_counter_buf_1 >= (offset + 32))) begin
//				valid = 1;
//			end
//		end
//	end

//	always@(*) begin
//		valid = 0;
//		if (index_buffer != 0)begin
//			if ((index_counter_buf_1 <= (depth)) && (index_counter_buf_1 >= (offset))) begin
//				valid = 1;
//			end
//		end
//	end

	always@(*) begin
		valid = 0;
		if (index_buffer != 0)begin
			if ((enable_32byte_process==1'b1)&&(index_counter_buf_1 <= 32))begin
				valid = 1;
			end else if ((enable_32byte_process==1'b1)&&(index_counter_buf_1 <= (depth + 32)) && (index_counter_buf_1 >= (offset + 32))) begin
				valid = 1;
			end else if ((enable_32byte_process==1'b0)&&(index_counter_buf_1 <= (depth)) && (index_counter_buf_1 >= (offset))) begin
				valid = 1;
			end
		end
	end

	always@(negedge clk) begin
		//$strobe("[Process Type 1] At time %0t index_in %b index_out",$time,index_in,index_out);
	end
	always@(posedge clk) begin
		index_buffer <= index_in;
		index_counter_buf_1 <= index_counter;
		index_out = 0;
		if (valid == 1) begin
			index_out = index_buffer[10:0];
		end
	end

endmodule
