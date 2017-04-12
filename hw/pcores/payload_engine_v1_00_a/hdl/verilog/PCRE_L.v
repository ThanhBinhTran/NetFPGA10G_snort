`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:45 11/21/2011 
// Design Name: 
// Module Name:    PCRE_L 
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
module PCRE_L #(parameter MAX = 15,MAX_B = 3,BASE = 0) (
    input clk,
	 input r_permission,
    input [MAX:0] vector,
	 input eop,
	 output s_permission,
    output reg [9:0] ID
    );
	 reg [MAX:0] data_get;
	 reg [MAX:0] temp;
	 
	 reg [MAX_B:0] counter[1:0];
	 wire triger;
	 
	 initial begin
		data_get = 0;
		temp = 0;
		ID = 0;
		counter[0] = 0;
		counter[1] = 1;
	 end
	 
	 assign triger = (data_get == 0) ? 0 : 1;
	 assign s_permission = ~triger && r_permission;
	 
	 always@(posedge clk) begin
		ID = 0;
		if (eop) begin
			data_get  = 0;
			temp = 0;
		end
		else begin
			if (r_permission) begin
				if (data_get[0]) begin 
					ID = 1 + BASE;
					temp[0] = 1;
				end
				else if (data_get[1]) begin 
					ID = 2 + BASE;
					temp[1] = 1;
				end
				else if (data_get[2]) begin 
					ID = 3 + BASE;
					temp[2] = 1;
				end
				else if (data_get[3]) begin 
					ID = 4 + BASE;
					temp[3] = 1;
				end
				else if (data_get[4]) begin 
					ID = 5 + BASE;
					temp[4] = 1;
				end
				else if (data_get[5]) begin 
					ID = 6 + BASE;
					temp[5] = 1;
				end
				else if (data_get[6]) begin 
					ID = 7 + BASE;
					temp[6] = 1;
				end
				else if (data_get[7]) begin 
					ID = 8 + BASE;
					temp[7] = 1;
				end
				else if (data_get[8]) begin 
					ID = 9 + BASE;
					temp[8] = 1;
				end
				else if (data_get[9]) begin 
					ID = 10 + BASE;
					temp[9] = 1;
				end
				else if (data_get[10]) begin 
					ID = 11 + BASE;
					temp[10] = 1;
				end
				else if (data_get[11]) begin 
					ID = 12 + BASE;
					temp[11] = 1;
				end
				else if (data_get[12]) begin 
					ID = 13 + BASE;
					temp[12] = 1;
				end
				else if (data_get[13]) begin 
					ID = 14 + BASE;
					temp[13] = 1;
				end
				else if (data_get[14]) begin 
					ID = 15 + BASE;
					temp[14] = 1;
				end
				else if (data_get[15]) begin 
					ID = 16 + BASE;
					temp[15] = 1;
				end
			end
			data_get = temp ^ vector;
		end
	 end
	 
	 
endmodule
