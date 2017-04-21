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
//
//////////////////////////////////////////////////////////////////////////////////
module process_pcre(
    input clk,
	input [9:0] index_in,
    output reg [9:0] index_out, //la sid cua rule lun
	input end_of_packet_shift,
	input [6:0] flow_in
    );

	wire [4:0] ramT2_out;
	reg [4:0] ramT2_out1;
	wire [10:0] offset,depth;
	wire [17:0] ramT1_out;
	wire [9:0] next_id;
	wire [6:0] flow;
	wire [4:0] data_inT2_portA,data_inT2_portB;
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
	reg [17:0] option;
	reg  we_enT2_portB;
	reg  we_enT2_portA;
	reg wea_valid;
	reg web_valid;
	reg select;
	reg [16:0] counter_flow;
	reg [9:0] counter1;
	wire [3:0] ind,max;
	reg [4:0] encode_bit; 
	reg [3:0] i;
	
	assign next_id = option[17:8];
	assign max = option[7:4];
	assign ind = option[3:0];
	
	assign flow = select == 1 ? valid1[6:0] : valid2[6:0];
	
	//assign data_inT2_portA = sequential == 1 ? encode_bit | ramT2_out : ramT1_out[38:30];
	assign data_inT2_portA = encode_bit | ((flow == 0 || flow == flow_in) ? ramT2_out : 0);
	assign data_inT2_portB = encode_bit | ((flow == 0 || flow == flow_in) ? ramT2_out : 0);
	
	assign addr_inT2_portB1 = select == 1 ? next_id : counter1;
	assign addr_inT2_portB2 = select == 0 ? next_id : counter1;
	
	assign din_valid1 = select == 1 ? {1'b1,10'b0,flow_in} : 0;
	assign din_valid2 = select == 0 ? {1'b1,10'b0,flow_in} : 0;
	
	assign web_valid1 = select == 1 ? web_valid : 1;
	assign web_valid2 = select == 0 ? web_valid : 1;
	
	assign wea_valid1 = select == 1 ? wea_valid : 0;
	assign wea_valid2 = select == 0 ? wea_valid : 0;
	
	assign addr_inT2_portB = next_id;
	
	always@(*) begin
		encode_bit = 0;
		for (i = 0;i < 5;i=i+1)
			if ((i+1) == ind) encode_bit[i] = 1;
	end
	
	always@(*) begin
		end_rule = 1'b0;
		//bit_vector = ramT2_out | encode_bit;		
		if ((((1 << max_buf) == ramT2_out+1) || ((1 << max_buf) == ramT2_out1+1)) && max_buf != 0 )
			match = 1'b1;
		else
			match = 1'b0;
	end
	
	ram_pcre_T1 ramT1 (
		.clka(clk),
		.addra(index_in), // Bus [9 : 0] 
		.douta(ramT1_out)); // Bus [55 : 0] 


	
	ram_pcre_T2 ramT2 (
		.clka(clk),
		.dina(data_inT2_portA), // Bus [21 : 0] 
		.addra(ramT1_out[17:8]), // Bus [9 : 0] 
		.wea(we_enT2_portA), // Bus [0 : 0] 
		.douta(ramT2_out), // Bus [21 : 0] 
		.clkb(clk),
		.dinb(data_inT2_portB), // Bus [21 : 0] 
		.addrb(addr_inT2_portB), // Bus [9 : 0] 
		.web(we_enT2_portB), // Bus [0 : 0] 
		.doutb()); // Bus [21 : 0] 
	
	//fifo_valid store the coresponding flow with the rule id in ram_pcre_t1 [17:8]
	fifo_valid fifo_valid1 (
		.clka(clk),
		.dina(din_valid1), // Bus [17 : 0] 
		.addra(ramT1_out[17:8]), // Bus [9 : 0] 
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
		.addra(ramT1_out[17:8]), // Bus [9 : 0] 
		.wea(wea_valid2), // Bus [0 : 0] 
		.douta(valid2), // Bus [17 : 0] 
		.clkb(clk),
		.dinb(din_valid2), // Bus [17 : 0] 
		.addrb(addr_inT2_portB2), // Bus [9 : 0] 
		.web(web_valid2), // Bus [0 : 0] 
		.doutb()); // Bus [17 : 0] 
		
	
	always@(*) begin
		web_valid = 0;
		wea_valid = 0;
		we_enT2_portB = 0;
		we_enT2_portA = 0;
		if ((next_id == ramT1_out[17:8]) && (next_id != 0)) begin
			we_enT2_portA = 1;
			wea_valid = 1;
		end
		else if (next_id != 0) begin
			web_valid = 1;
			we_enT2_portB = 1;
		end
	end
	
	
	always@(posedge end_of_packet_shift) begin
		counter_flow = counter_flow + 17'b1;
		if (counter_flow == 17'b0)	
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
		if (match == 1) begin
			//$display("match %d",next_id_buf);
			index_out = next_id_buf ;
		end
		else 
			index_out = 0;
		
	end
	
endmodule
