`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:51 05/25/2011 
// Design Name: 
// Module Name:    process_type2 
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
// latency 2
//////////////////////////////////////////////////////////////////////////////////
module process_type4(
    input clk,
	input [10:0] index_counter,
	input [9:0] index_in,
	input enable_32byte_process,
	input [6:0] curPacketID,
    output reg [10:0] index_out, //la sid cua rule lun
	input end_of_packet_shift
    );
	//debug
	wire [17:0] valid1,valid2;
	wire [9:0] next_id;
	reg web_valid;
	wire [55:0] ramT1_out;
	wire valid_link;
	reg match;
	reg wea_valid;
	wire web_valid1,web_valid2,wea_valid1,wea_valid2;
	wire [17:0] din_valid1,din_valid2;
	reg select;
	reg [16:0] counter_packet;
	
	wire [10:0] ramT2_out;
	wire [10:0] offset,depth,within,distance;
	
	wire [10:0] clk_offset;
	wire [6:0] packetID;
	wire [9:0] addr_inT2_portB1;
	wire [9:0] addr_inT2_portB2;
	wire end_rule;
	wire first_rule;
	//wire web_valid1,web_valid2,wea_valid1,wea_valid2;
	
	
	wire [9:0] addr_inT2_portB;

	reg [10:0] index_counter_buf_1;
	reg [10:0] index_counter_buf_2;
	
	reg [55:0] option;
	reg  we_enT2_portB;
	reg  we_enT2_portA;
	reg [9:0] index_in_buf;
	reg [9:0] counter1;

	initial begin
		select = 0;
		counter_packet = 0;
		counter1 = 0;
		index_in_buf = 0;
		index_out = 0;
		index_counter_buf_2 = 0;
		index_counter_buf_1 = 0;
	end
	
	always@(negedge clk) begin
		//$strobe("[Process Type 4] At time %0t index_in %d clk_counter %d clk_offset %d ramT2_out %d",$time,index_in,clk_counter,clk_offset,ramT2_out);
		//$strobe("[Process Type 4] At time %0t first_rule %b valid2 %b addr_inT2_portB2 %0d" ,$time,first_rule ,valid_link, addr_inT2_portB2);
		//$strobe("[Process Type 4] At time %0t we_enT2_portB %0d web_valid2 %b din_valid2 %b",$time,we_enT2_portB,web_valid2,din_valid2);
		//$strobe("[Process Type 4] At time %0t depth %d offset %d distance %d within %d",$time,depth,offset,distance,within);
	end
	
	
	
	assign depth = option[43:33];
	assign offset = option[32:22];
	assign distance = option[21:11];
	assign within = option[10:0];
	
	assign next_id = option[53:44];
	assign end_rule = option[54];
	assign first_rule = option[55];
	
	assign valid_link = (select == 1 ? valid1[17] : valid2[17]) || first_rule;
	assign packetID = (select == 1) ? valid1[6:0] : valid2[6:0];
	
	//assign addr_inT2_portB1 = select == 1 ? sequential == 1 ? 0 : next_id : counter1;
	//assign addr_inT2_portB2 = select == 0 ? sequential == 1 ? 0 : next_id : counter1;
	
	assign addr_inT2_portB1 = (select == 1) ? next_id : counter1;
	assign addr_inT2_portB2 = (select == 0) ? next_id : counter1;
	
	assign din_valid1 = (select == 1) ? {1'b1,10'b0,curPacketID} : 0;
	assign din_valid2 = (select == 0) ? {1'b1,10'b0,curPacketID} : 0;
	
	assign web_valid1 = (select == 1) ? web_valid : 1;
	assign web_valid2 = (select == 0) ? web_valid : 1;
	
	assign wea_valid1 = (select == 1) ? wea_valid : 0;
	assign wea_valid2 = (select == 0) ? wea_valid : 0;
	
	assign clk_offset = index_counter_buf_2 - ramT2_out;
	
	//assign addr_inT2_portB = sequential == 1 ? 0 : next_id;
	assign addr_inT2_portB = next_id;
	
	ram_type4_T1 ramT1 (
		.clka(clk),
		.addra(index_in), // Bus [9 : 0] 
		.douta(ramT1_out)); // Bus [55 : 0] 
	
	ram_type4_T2 ramT2 (
		.clka(clk),
		.dina(index_counter_buf_2), // Bus [21 : 0] 
		.addra(index_in_buf), // Bus [9 : 0] 
		.wea(we_enT2_portA), // Bus [0 : 0] 
		.douta(ramT2_out), // Bus [21 : 0] 
		.clkb(clk),
		.dinb(index_counter_buf_2), // Bus [21 : 0] 
		.addrb(addr_inT2_portB), // Bus [9 : 0] 
		.web(we_enT2_portB), // Bus [0 : 0] 
		.doutb()); // Bus [21 : 0] 
	
	
	fifo_valid fifo_valid1 (
		.clka(clk),
		.dina(din_valid1), // Bus [17 : 0] 
		.addra(index_in_buf), // Bus [9 : 0] 
		.wea(wea_valid1), // Bus [0 : 0] 
		.douta(valid1), // Bus [17 : 0] 
		.clkb(clk),
		.dinb(din_valid1), // Bus [17 : 0] 
		.addrb(addr_inT2_portB1), // Bus [9 : 0] 
		.web(web_valid1), // Bus [0 : 0] 
		.doutb()); // Bus [17 : 0] 

	fifo_valid fifo_valid2 (
		.clka(clk),
		.dina(din_valid2), // Bus [17 : 0] 
		.addra(index_in_buf), // Bus [9 : 0] 
		.wea(wea_valid2), // Bus [0 : 0] 
		.douta(valid2), // Bus [17 : 0] 
		.clkb(clk),
		.dinb(din_valid2), // Bus [17 : 0] 
		.addrb(addr_inT2_portB2), // Bus [9 : 0] 
		.web(web_valid2), // Bus [0 : 0] 
		.doutb()); // Bus [17 : 0] 
		
	always@(posedge end_of_packet_shift) begin
		counter_packet = counter_packet + 17'b1;
		if (counter_packet == 17'b0)	
			select = select^1'b1;
		else
			select = select;
	end	
	
//	always@(*) begin
//		web_valid = 0;
//		wea_valid = 0;
//		we_enT2_portB = 0;
//		we_enT2_portA = 0;
//		match = 0;
//		if (valid_link && (packetID == 0 || packetID[6:0] == curPacketID))
//				if ((index_counter_buf_2<=32)||((index_counter_buf_2 <= (depth + 32)) && (index_counter_buf_2 >= (offset + 32))))
//					if  (((ramT2_out==0)&&(clk_offset <= within+32)&&(clk_offset >= distance+32))||(clk_offset <= within && clk_offset >= distance))
//					begin
//						if (end_rule) begin	//last content
//							match = 1;
//							end
//						else if (next_id == index_in_buf) begin //middle contents
//							we_enT2_portA = 1;
//							wea_valid = 1;
//						end
//						else begin				//first content
//							web_valid = 1;
//							we_enT2_portB = 1;
//						end
//					end
//	end

//	always@(*) begin
//		web_valid = 0;
//		wea_valid = 0;
//		we_enT2_portB = 0;
//		we_enT2_portA = 0;
//		match = 0;
//		if (valid_link && (packetID == 0 || packetID[6:0] == curPacketID))
//				if (((index_counter_buf_2 <= (depth)) && (index_counter_buf_2 >= (offset))))
//					if (clk_offset <= within && clk_offset >= distance)
//					begin
//						if (end_rule) begin	//last content
//							match = 1;
//							end
//						else if (next_id == index_in_buf) begin //middle contents
//							we_enT2_portA = 1;
//							wea_valid = 1;
//						end
//						else begin				//first content
//							web_valid = 1;
//							we_enT2_portB = 1;
//						end
//					end
//	end
	
	always@(*) begin
		web_valid = 0;
		wea_valid = 0;
		we_enT2_portB = 0;
		we_enT2_portA = 0;
		match = 0;
		if (valid_link && (packetID == 0 || packetID[6:0] == curPacketID))
		begin
				if ((enable_32byte_process==1'b1)&&((index_counter_buf_2<=32)||((index_counter_buf_2 <= (depth + 32)) && (index_counter_buf_2 >= (offset + 32)))))
				begin
					if  (((ramT2_out==0)&&(index_counter_buf_2 <= within+32)&&(index_counter_buf_2 >= distance+32))||(clk_offset <= within && clk_offset >= distance))
					begin
						if (end_rule) begin	//last content
							match = 1;
							end
						else if (next_id == index_in_buf) begin //middle contents
							we_enT2_portA = 1;
							wea_valid = 1;
						end
						else begin				//first content
							web_valid = 1;
							we_enT2_portB = 1;
						end
					end
				end else if ((enable_32byte_process==1'b0)&&(((index_counter_buf_2 <= (depth)) && (index_counter_buf_2 >= (offset)))))
				begin
					if (clk_offset <= within && clk_offset >= distance)
					begin
						if (end_rule) begin	//last content
							match = 1;
							end
						else if (next_id == index_in_buf) begin //middle contents
							we_enT2_portA = 1;
							wea_valid = 1;
						end
						else begin				//first content
							web_valid = 1;
							we_enT2_portB = 1;
						end
					end
				end
		end
	end
	
	always@(posedge clk) begin
		index_out = 0;
		if (match == 1) begin
			index_out = {1'b0,next_id};
		end
		counter1 = counter1 + 10'b1;
		index_in_buf <= index_in;
		option <= ramT1_out;
		index_counter_buf_1 <= index_counter + 'd1; // + 1 because index_counter is calculated for latency 1
		index_counter_buf_2 <= index_counter_buf_1;
	end

	

endmodule
