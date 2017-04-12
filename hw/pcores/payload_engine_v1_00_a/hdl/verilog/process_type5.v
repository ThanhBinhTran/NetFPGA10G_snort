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
module process_type5(
   input             clk,
	input [10:0]      index_counter,
	input [9:0]       index_in,
	input             enable_32byte_process,
	input [6:0]       curPacketID,
   output reg [10:0] index_out, //la sid cua rule lun
	input             end_of_packet_shift
   );
	parameter PRE_HASH_T1 = 10'b1100001111; 
parameter PRE_HASH_T2 = 10'b0100111110; 
parameter no_type1 = 512; 
parameter no_type2 = 544; 
parameter no_type3 = 919; 
parameter no_type4 = 1005; 
parameter no_type5 = 1336; 
parameter no_type6 = 1411;
parameter no_type7 = 1411;
parameter stno1 = 2;
parameter stno2 = 21;
parameter stno3 = 45;
parameter stno4 = 87;
parameter stno5 = 60;
parameter stno6 = 74;
parameter stno7 = 48;
parameter stno8 = 58;
parameter stno9 = 53;
parameter stno10 = 51;
parameter stno11 = 47;
parameter stno12 = 41;
parameter stno13 = 37;
parameter stno14 = 35;
parameter stno15 = 26;
parameter stno16 = 44;
parameter sno1 = 2;
parameter sno2 = 23;
parameter sno3 = 68;
parameter sno4 = 155;
parameter sno5 = 215;
parameter sno6 = 289;
parameter sno7 = 337;
parameter sno8 = 395;
parameter sno9 = 448;
parameter sno10 = 499;
parameter sno11 = 546;
parameter sno12 = 587;
parameter sno13 = 624;
parameter sno14 = 659;
parameter sno15 = 685;
parameter sno16 = 729;
parameter sno1_nocase = 730;
parameter sno2_nocase = 744;
parameter sno3_nocase = 788;
parameter sno4_nocase = 844;
parameter sno5_nocase = 913;
parameter sno6_nocase = 991;
parameter sno7_nocase = 1065;
parameter sno8_nocase = 1126;
parameter sno9_nocase = 1178;
parameter sno10_nocase = 1227;
parameter sno11_nocase = 1270;
parameter sno12_nocase = 1306;
parameter sno13_nocase = 1341;
parameter sno14_nocase = 1365;
parameter sno15_nocase = 1389;
parameter sno16_nocase = 1411;
parameter no_rule1 = 512;
parameter no_rule2 = 32;
parameter no_rule3 = 128;
parameter no_rule4 = 32;
parameter no_rule5 = 128;
parameter no_rule6 = 32;
parameter no_rule7 = 0;
parameter ac_rule1 = 512;
parameter ac_rule2 = 544;
parameter ac_rule3 = 672;
parameter ac_rule4 = 704;
parameter ac_rule5 = 832;
parameter ac_rule6 = 864;
parameter ac_rule7 = 864;
parameter rule_type123 = 0;

	//`include "src/payload/constant.v"

	wire [14:0] ramT2_out;
	reg  [14:0] ramT2_out1;
	wire [10:0] offset,depth;
	wire [38:0] ramT1_out;
	wire [9:0] next_id;
	wire [6:0] packetID;
	wire [14:0] data_inT2_portA,data_inT2_portB;
	wire [9:0] addr_inT2_portB1;
	wire [9:0] addr_inT2_portB2;
	wire web_valid1,web_valid2,wea_valid1,wea_valid2;
	wire [17:0] valid1,valid2;
	wire [17:0] din_valid1,din_valid2;
	wire [9:0] addr_inT2_portB;
	reg end_rule;
	
	reg [9:0] next_id_buf;
	reg match;
	reg [3:0] max_buf;
	reg [38:0] option;
	reg  we_enT2_portB;
	reg  we_enT2_portA;
	reg wea_valid;
	reg web_valid;
	reg select;
	reg [16:0] counter_packet;
	reg [9:0] counter1;
	wire [3:0] ind,max;
	reg [14:0] encode_bit; 
	reg [3:0] i;
	
	reg [14:0] data_inT2_portA_buf_valid;
	reg [6:0] packetID_buf_valid;
	reg		  isContinuedPacket;
	//New modification
	reg [10:0] index_counter_buf_1; //delay indexcounter 1 clk
	reg [10:0] index_counter_buf_2;
	always@(posedge clk)begin
		index_counter_buf_1 <= index_counter + 11'd1;
		index_counter_buf_2 <= index_counter_buf_1;
	end
	
	initial begin
		select = 0;
		counter_packet = 0;
		next_id_buf = 0;
		counter1 = 0;
		match = 0;
		index_out = 0;
		index_counter_buf_2 = 0;
		index_counter_buf_1 = 0;
		data_inT2_portA_buf_valid = 0;
		packetID_buf_valid = 0;
		isContinuedPacket = 0;
	end
	always@(negedge clk) begin
		//$strobe("[Process Type 5] At time %0t index_in %d index_counter %d  ind %b max %b option %h",$time,index_in,index_counter,ind,max,option);
		//$strobe("[Process Type 5] At time %0t addr_inT2_portB %d data_inT2_portB %d" ,$time, addr_inT2_portB,data_inT2_portB);
		//$strobe("[Process Type 5] At time %0t addr_inT2_portA %d data_inT2_portA %d" ,$time, ramT1_out[38:30],data_inT2_portA);
		//$strobe("[Process Type 5] At time %0t we_enT2_portB %0d we_enT2_portA ",$time,we_enT2_portB,we_enT2_portA);
		//$strobe("[Process Type 5] At time %0t packetID  %d curPacketID  %d ramT2_out1 %b match %b",$time,packetID ,curPacketID,ramT2_out1,match);
		//$strobe("[Process Type 5] At time %0t index_out  %d match %b",$time,index_out,match);
	end
	
	
	
	assign depth = option[21:11];
	assign offset = option[10:0];
	
	assign next_id = {1'b0,option[38:30]};
	assign max = option[29:26];
	assign ind = option[25:22];
	
	assign packetID = select == 1 ? valid1[6:0] : valid2[6:0];
	
	//assign data_inT2_portA = sequential == 1 ? encode_bit | ramT2_out : ramT1_out[38:30];
	//Change datainT2 depend on packetID, always write if valid
//	assign data_inT2_portA = encode_bit | ramT2_out;
//	assign data_inT2_portB = encode_bit | ramT2_out;
//	assign data_inT2_portA = (packetID_buf_valid[6:0] == curPacketID)?(encode_bit | data_inT2_portA_buf_valid):encode_bit;
//	assign data_inT2_portB = (packetID[6:0] == curPacketID)?(encode_bit | ramT2_out):encode_bit;
	assign data_inT2_portA = isContinuedPacket?((packetID_buf_valid[6:0] == curPacketID)?(encode_bit | data_inT2_portA_buf_valid):encode_bit):((packetID[6:0] == curPacketID)?(encode_bit | ramT2_out):encode_bit);
	assign data_inT2_portB = isContinuedPacket?((packetID_buf_valid[6:0] == curPacketID)?(encode_bit | data_inT2_portA_buf_valid):encode_bit):((packetID[6:0] == curPacketID)?(encode_bit | ramT2_out):encode_bit);
	//isContinuedPacket
	
	assign addr_inT2_portB1 = select == 1 ? next_id : counter1;
	assign addr_inT2_portB2 = select == 0 ? next_id : counter1;
	
	assign din_valid1 = select == 1 ? {1'b1,10'b0,curPacketID} : 0;
	assign din_valid2 = select == 0 ? {1'b1,10'b0,curPacketID} : 0;
	
	assign web_valid1 = select == 1 ? web_valid : 1;
	assign web_valid2 = select == 0 ? web_valid : 1;
	
	assign wea_valid1 = select == 1 ? wea_valid : 0;
	assign wea_valid2 = select == 0 ? wea_valid : 0;
	
	assign addr_inT2_portB = next_id;
	
	always@(*) begin
		encode_bit = 0;
		for (i = 0;i < 15;i=i+1)
			if ((i+1) == ind) encode_bit[i] = 1;
	end
	
	always@(*) begin
		//end_rule = 1'b0;
		//bit_vector = ramT2_out | encode_bit;		
		if ((((1 << max_buf) == ramT2_out+1) || ((1 << max_buf) == ramT2_out1+1)) && max_buf != 0 )
			match = 1'b1;
		else
			match = 1'b0;
	end
	
	ram_type5_T1 ramT1 (
		.clka(clk),
		.dina(39'b0), // Bus [55 : 0] 
		.addra(index_in), // Bus [9 : 0] 
		.wea(1'b0), // Bus [0 : 0] 
		.douta(ramT1_out)); // Bus [55 : 0] 


	
	ram_type5_T2 ramT2 (
		.clka(clk),
		.dina(data_inT2_portA), // Bus [21 : 0] 
		.addra(ramT1_out[38:30]), // Bus [9 : 0] 
		.wea(we_enT2_portA), // Bus [0 : 0] 
		.douta(ramT2_out), // Bus [21 : 0] 
		.clkb(clk),
		.dinb(data_inT2_portB), // Bus [21 : 0] 
		.addrb(addr_inT2_portB), // Bus [9 : 0] 
		.web(we_enT2_portB), // Bus [0 : 0] 
		.doutb()); // Bus [21 : 0] 
	
	
	fifo_valid fifo_valid1 (
		.clka(clk),
		.dina(din_valid1), // Bus [17 : 0] 
		.addra({1'b0,ramT1_out[38:30]}), // Bus [9 : 0] 
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
		.addra({1'b0,ramT1_out[38:30]}), // Bus [9 : 0] 
		.wea(wea_valid2), // Bus [0 : 0] 
		.douta(valid2), // Bus [17 : 0] 
		.clkb(clk),
		.dinb(din_valid2), // Bus [17 : 0] 
		.addrb(addr_inT2_portB2), // Bus [9 : 0] 
		.web(web_valid2), // Bus [0 : 0] 
		.doutb()); // Bus [17 : 0] 
		
	always@(negedge clk) begin
		//$strobe("[Process Type 5] At time %0t index_in %d",$time,index_in);
		//$strobe("[Process Type 5] At time %0t wea_valid %d",$time,wea_valid,f);
	end
	
//	always@(*) begin
//		web_valid = 0;
//		wea_valid = 0;
//		we_enT2_portB = 0;
//		we_enT2_portA = 0;
//		//command if (packetID...) --> always write, but data is reset if packetID is different
//		//if (packetID == 0 || packetID[6:0] == curPacketID) begin 
//				if ((index_counter_buf_2 <= 32)||((index_counter_buf_2 <= (depth + 32)) && (index_counter_buf_2 >= (offset + 32))))
//					begin
//						if ((next_id == ramT1_out[38:30]) && (next_id != 0)) begin
//							we_enT2_portA = 1;
//							wea_valid = 1;
//						end
//						else if (next_id != 0) begin
//							web_valid = 1;
//							we_enT2_portB = 1;
//						end
//					end
//		//		end
//	end

//		always@(*) begin
//		web_valid = 0;
//		wea_valid = 0;
//		we_enT2_portB = 0;
//		we_enT2_portA = 0;
//		//command if (packetID...) --> always write, but data is reset if packetID is different
//		//if (packetID == 0 || packetID[6:0] == curPacketID) begin 
//				if (((index_counter_buf_2 <= (depth )) && (index_counter_buf_2 >= (offset))))
//					begin
//						if ((next_id == ramT1_out[38:30]) && (next_id != 0)) begin
//							we_enT2_portA = 1;
//							wea_valid = 1;
//						end
//						else if (next_id != 0) begin
//							web_valid = 1;
//							we_enT2_portB = 1;
//						end
//					end
//		//		end
//	end

	always@(*) begin
		web_valid = 0;
		wea_valid = 0;
		we_enT2_portB = 0;
		we_enT2_portA = 0;
		//command if (packetID...) --> always write, but data is reset if packetID is different
		if ((enable_32byte_process==1'b1)&&((index_counter_buf_2 <= 32)||((index_counter_buf_2 <= (depth + 32)) && (index_counter_buf_2 >= (offset + 32)))))
		begin
			if ((next_id == ramT1_out[38:30]) && (next_id != 0)) begin
				we_enT2_portA = 1;
				wea_valid = 1;
			end
			else if (next_id != 0) begin
				web_valid = 1;
				we_enT2_portB = 1;
			end
		end else if ((enable_32byte_process==1'b0)&&(((index_counter_buf_2 <= (depth )) && (index_counter_buf_2 >= (offset)))))
		begin
			if ((next_id == ramT1_out[38:30]) && (next_id != 0)) begin
				we_enT2_portA = 1;
				wea_valid = 1;
			end
			else if (next_id != 0) begin
				web_valid = 1;
				we_enT2_portB = 1;
			end
		end
	end

	
	
	always@(posedge end_of_packet_shift) begin
		counter_packet = counter_packet + 17'b1;
		if (counter_packet == 17'b0)	
			select = select^1'b1;
		else
			select = select;
	end	
	
	always@(posedge clk) begin
		counter1 = counter1 + 1;
		option <= ramT1_out;
		max_buf <= max;
		next_id_buf <= next_id;
		ramT2_out1 <= data_inT2_portB;
		
	//	isContinuedPacket
		if(next_id == ramT1_out[38:30]) 	isContinuedPacket <= 1;
		else											isContinuedPacket <= 0;
	
		if(we_enT2_portA)begin
			if(select==1)begin
				packetID_buf_valid <= din_valid1[6:0];
			end else begin
				packetID_buf_valid <= din_valid2[6:0];
			end
			data_inT2_portA_buf_valid <= data_inT2_portA;
		end else if (we_enT2_portB)begin
			if(select==1)begin
				packetID_buf_valid <= din_valid1[6:0];
			end else begin
				packetID_buf_valid <= din_valid2[6:0];
			end
			data_inT2_portA_buf_valid <= data_inT2_portB;
		end
		
		if (match == 1) begin
			//$display("match %d",next_id_buf);
			index_out = {1'b0,next_id_buf} ;
		end
		else 
			index_out = 0;
		
	end


endmodule
