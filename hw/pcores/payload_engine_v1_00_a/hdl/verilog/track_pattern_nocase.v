`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:42:32 03/15/2011 
// Design Name: 
// Module Name:    track_pattern 
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
module track_pattern_nocase(
    input [13:0] patternID,
    input [1:0]  suffix,
    input [12:0] addr_in_T4,
	 input clk,
	 output reg [13:0] pattern
    );
	 wire [13:0] data_out_T4;
	 reg [13:0] data_out_T4_buf = 0;
	 reg [13:0] pipeline_pattern = 0,pipeline_pattern_buf = 0;
	 reg [1:0]	 suffix_pipeline = 0, suffix_pipeline_buf = 0;
	 reg [12:0] pipeline_addr = 0;
	 reg [12:0] pipeline_addr1 = 0;
	 reg [4:0] i = 0;
	 reg [3:0] index_counter = 0;
	 reg [3:0] i_temp = 0;
	 reg [12:0] register[15:0];
	 reg [5:0] counter[15:0];
	 reg [15:0] check = 0;
	 
	 initial
		begin
			for (i = 0 ; i <= 15; i= i+1) begin
				counter[i] = 0;
				register[i] = 0;
			end
			pattern = 0;
		end
	
	 ram_t4_nocase ramT4 (
		.clka(clk),
		.addra(addr_in_T4), // Bus [12 : 0] 
		.douta(data_out_T4)); // Bus [13 : 0] //14 bit = 4 bit module (0-15), 9 bit address, 1 bit suf
		
	always@(posedge clk) begin
		//tu dong cap nhat counter va register
		for (i = 0; i <= 15; i=i+1) begin
			if (counter[i] != 0) begin
				counter[i] = counter[i] - 1;		
			end
			else begin
				register[i] = 0;
			end
		end
		//track
		///////////////////////////////////////
		pipeline_pattern <= patternID;
		suffix_pipeline <= suffix;
		pipeline_addr <= addr_in_T4;
		pipeline_addr1 <= pipeline_addr;
		
		pattern = 0;
		suffix_pipeline_buf <= suffix_pipeline;
		data_out_T4_buf <= data_out_T4;
		pipeline_pattern_buf <= pipeline_pattern;
		
		case (suffix_pipeline_buf) 
			0: begin
				pattern = pipeline_pattern_buf;
			end
			1:	begin
			end
			2: begin
				if (|check == 1)
					pattern = {data_out_T4_buf[13:10]+1,data_out_T4_buf[9:1]};
			end
			3: begin
				pattern = pipeline_pattern_buf;
			end
		endcase
		
		case (suffix_pipeline)
		1: begin
			index_counter <= index_counter + 1;
			register[index_counter] = data_out_T4[13:1];
			counter[index_counter] = data_out_T4[13:10]+1;
			//$display("At time %d prefix next: %b",$time,data_out_T4[13:1]);
		end
		2: begin
			check = 0;
			for (i = 0; i <= 15;i=i+1)begin
				if ((counter[i]==0)&&(register[i]==pipeline_addr))begin
					//$display("At time %d pipeline_addr: %b register[i] %b",$time,pipeline_addr,register[i]);
					if (data_out_T4[0] == 1) begin
						check[i] = 1;
					end
					else begin
						register[i] = data_out_T4[13:1];
						counter[i] = data_out_T4[13:10]+1;
					end
				end
			end	
		end
		0: begin
			//pattern = pipeline_pattern;
		end
		3: begin
			index_counter <= index_counter + 1;
			register[index_counter] = data_out_T4[13:1];
			counter[index_counter] = data_out_T4[13:10]+1;
		end
		endcase
	
		
	end
		
endmodule