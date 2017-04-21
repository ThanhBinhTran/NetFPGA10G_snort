`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:38:20 10/02/2011 
// Design Name: 
// Module Name:    combine_pcre 
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
module combine_pcre(
    input clk,
	input [6:0] flow,
	input state,
	input end_of_packet_shift,
	input [10:0] patternID_out1,
	input [10:0] patternID_out3,
	input [10:0] patternID_out5,
	input [9:0] patternID_pcre,
	output reg [10:0]real_patternID,
	output reg combine_ready
	//output reg [10:0] out1,out2,out3,
	//output [8:0] dout,
	//output [9:0] patternID_out2,
	//output [9:0] patternID_out4,
	//output [9:0] patternID_out6,
	//output reg we
    );
	`include "src/payload/constant.v"
	//debug
	/*
	wire [8:0] dout
	reg [10:0] out1,out2,out3;
	wire [9:0] patternID_out2;
	wire [9:0] patternID_out4;
	wire [9:0] patternID_out6;
	*/
	reg [10:0] out1,out2,out3;
	wire [9:0] patternID_out2;
	wire [9:0] patternID_out4;
	wire [9:0] patternID_out6;
	reg [8:0] addra,addrb;
	reg [8:0] addra_buf,addrb_buf,din_fifo;
	reg wea,web;
	reg [9:0] din_buf;
	wire [8:0] dina1,dina2,dinb1,dinb2;
	
	wire wea1,wea2,web1,web2;
	wire [8:0] douta1,douta2,doutb1,doutb2;
	wire [8:0] douta,doutb;
	reg select;
	wire [7:0] counter;
	reg [7:0] counter_reset;
	wire [10:0] in_addra1,in_addra2,in_addrb1,in_addrb2;
	reg [9:0] real_pattern_temp1, real_pattern_temp2,real_pattern_temp3,real_pattern_temp4,real_pattern_temp5,real_pattern_temp6;
	initial begin
		out1 = 0;
		out2 = 0;
		out3 = 0;
		addra = 0;
		addrb = 0;
		addra_buf = 0;
		addrb_buf = 0;
		din_fifo = 0;
		din_buf = 0;
		web = 0;
		wea = 0;
		select = 0;
		real_patternID = 0;
		counter_reset = 0;
		combine_ready = 0;
	end
	
	assign patternID_out2 = (patternID_out1 > no_rule1) ? (patternID_out1 - no_rule1) : 0;
	assign patternID_out4 = (patternID_out3 > no_rule3) ? (patternID_out3 - no_rule3) : 0;
	assign patternID_out6 = (patternID_out5 > no_rule5) ? (patternID_out5 - no_rule5) : 0;
	
	
	assign douta = (select == 1) ? douta1 : douta2;
	assign doutb = (select == 1) ? doutb1 : doutb2;
	
	assign wea1 = (select == 1) ? wea : 0;
	assign web1 = (select == 1) ? web : 1;
	
	assign wea2 = (select == 0) ? wea : 0;
	assign web2 = (select == 0) ? web : 1;
	
	assign in_addra1 = (select == 1) ? addra : 0;
	assign in_addrb1 = (select == 1) ? addrb : counter_reset;
	
	assign in_addra2 = (select == 0) ? addra : 0;
	assign in_addrb2 = (select == 0) ? addrb : counter_reset;
	
	assign dina1 = (select == 1) ? {2'b10,flow} : 0;
	assign dinb1 = (select == 1) ? {2'b01,flow} : 0;
	
	assign dina2 = (select == 0) ? {2'b10,flow} : 0;
	assign dinb2 = (select == 0) ? {2'b01,flow} : 0;
	
	//port a for content
	//port b for pcre
	ram_combine c1 (
		.clka(clk),
		.dina(dina1), // Bus [8 : 0] 
		.addra(in_addra1), // Bus [10 : 0] 
		.wea(wea1), // Bus [0 : 0] 
		.douta(douta1),
		.clkb(clk),
		.dinb(dinb1), // Bus [8 : 0] 
		.addrb(in_addrb1), // Bus [10 : 0] 
		.web(web1), // Bus [0 : 0] 
		.doutb(doutb1)); // Bus [8 : 0] 

	ram_combine c2 (
		.clka(clk),
		.dina(dina2), // Bus [8 : 0] 
		.addra(in_addra2), // Bus [10 : 0] 
		.wea(wea2), // Bus [0 : 0] 
		.douta(douta2),
		.clkb(clk),
		.dinb(dinb2), // Bus [8 : 0] 
		.addrb(in_addrb2), // Bus [10 : 0] 
		.web(web2), // Bus [0 : 0] 
		.doutb(doutb2)); // Bus [8 : 0] 
	
	counter_fifo_cp counter_cp (
		.clk(end_of_packet_shift),
		.q(counter)); // Bus [7 : 0] 
    
	wire rd_en;
	reg wr_en;
	assign rd_en = !(wea || web);
	
	fifo_combine fifo_combine (
		.clk(clk),
		.din(din_fifo), // Bus [10 : 0] 
		.rd_en(rd_en),
		.wr_en(wr_en),
		.dout(fifo_out), // Bus [10 : 0] 
		.empty(empty),
		.full(full));



	always@(negedge clk) begin
		//$strobe("[Combine PCRE] At time %0t patternID_out3 %d patternID_out4 %d",$time,patternID_out3,patternID_out4);
		//$strobe("[Combine PCRE] At time %0t pcre %d ",$time,patternID_pcre);
		//$strobe("[Combine PCRE] At time %0t din %d we %d",$time,din,we);
		//$strobe("[Combine PCRE] At time %0t dout1 %b dout1 %b addr1 %b",$time,dout1,dout2,addr1);
	end
	
	
	always@(posedge end_of_packet_shift) begin
		if (counter == 17'b0)	
			select = select^1'b1;
		else
			select = select;
	end	
	reg simultaneous = 0;
	reg [1:0] simultaneous_buf = 0;
	reg [1:0] c_p,c_p_buf;
	
	always@(*) begin
		din_fifo = 0;
		if (addrb_buf <= no_rule2)
				din_fifo = addrb_buf + no_rule1;
			else if (addrb_buf <= no_rule2 + no_rule4)
				din_fifo = addrb_buf + ac_rule3 - no_rule2;
			else
				din_fifo = addrb_buf + ac_rule5 - no_rule2 - no_rule4;
	end
	
	always@(posedge clk) begin
		
		//real_patternID = 0;
		simultaneous_buf <= (simultaneous_buf << 1) + simultaneous;
		wr_en = 0;
		//combine_ready = 0;
		
		if (out1 != 0)
			real_patternID = out1;
		else if (out2 != 0)
			real_patternID = out2;
		else if (out3 != 0)
			real_patternID = out3;
		else if ((douta[8:7] == c_p_buf && flow == douta[6:0]) || simultaneous_buf[0]) begin
			if (addra_buf <= no_rule2)
				real_patternID = real_pattern_temp1;//addra_buf + no_rule1;
			else if (addra_buf <= no_rule2 + no_rule4)
				real_patternID = real_pattern_temp2;//addra_buf + ac_rule3 - no_rule2;
			else
				real_patternID = real_pattern_temp3;//addra_buf + ac_rule5 - no_rule2 - no_rule4;
			if ((doutb[8:7] == c_p_buf && flow == doutb[6:0]) && !simultaneous_buf[0]) begin
				wr_en = 1;
			end 
		end
		else if ((doutb[8:7] == c_p_buf && flow == doutb[6:0])) begin
			if (addrb_buf <= no_rule2)
				real_patternID = real_pattern_temp4;//addrb_buf + no_rule1;
			else if (addrb_buf <= no_rule2 + no_rule4)
				real_patternID = real_pattern_temp5;//addrb_buf + ac_rule3 - no_rule2;
			else
				real_patternID = real_pattern_temp6;//addrb_buf + ac_rule5 - no_rule2 - no_rule4;
		end 
		else begin 
			real_patternID = fifo_out;
		end
		
		counter_reset = counter_reset + 1;
		
		out1 = 0;
		out2 = 0;
		out3 = 0;		
		c_p_buf <= c_p;
		if (patternID_out1 <= no_rule1) begin
			out1 = patternID_out1;
			//combine_ready = 0;
		end
		if (patternID_out3 <= no_rule3 && patternID_out3!=0) begin
			out2 = patternID_out3 + ac_rule2;
			//combine_ready = 0;
		end
		if (patternID_out5 <= no_rule5 && patternID_out5!=0) begin
			out3 = patternID_out5 + ac_rule4;
			//combine_ready = 0;
		end


		addra_buf <= addra;
		addrb_buf <= addrb;
		real_pattern_temp1 <= addra + ac_rule1;
		real_pattern_temp2 <= addra + ac_rule3;
		real_pattern_temp3 <= addra + ac_rule5;
		real_pattern_temp4 <= addrb + ac_rule1;
		real_pattern_temp5 <= addrb + ac_rule3;
		real_pattern_temp6 <= addrb + ac_rule5;
		addra = 0;
		addrb = 0;
		wea = 0;
		web = 0;
		c_p = 2'b11;
		simultaneous = 0;
		
		if (state==1) begin
			c_p = 2'b11;
			if (patternID_pcre>=ac_rule5)
				addrb = patternID_pcre - ac_rule5;
			else if (patternID_pcre>=ac_rule3)
				addrb = patternID_pcre - ac_rule3;
			else
				addrb = patternID_pcre - ac_rule1;
				
				combine_ready = 1;
			
			if (patternID_out1!=0)
				combine_ready = 0;
			
			if (patternID_out3!=0)
				combine_ready = 0;
			
			if (patternID_out5!=0)
				combine_ready = 0;
				
			if (patternID_out2 != 0) begin
				combine_ready = 0;
				addra = patternID_out2;
				c_p = 2'b01;
				if (patternID_pcre == patternID_out2) begin
					simultaneous = 1;
				end
				else
					wea = 1;
			end
			
			if (patternID_out4 != 0) begin
				combine_ready = 0;
				addra = patternID_out4;
				c_p = 2'b01;
				if (patternID_pcre == patternID_out4) begin
					simultaneous = 1;
				end
				else
					wea = 1;
			end
			
			if (patternID_out6 != 0) begin
				combine_ready = 0;
				addra = patternID_out6;
				c_p = 2'b01;
				if (patternID_pcre == patternID_out6) begin
					simultaneous = 1;
				end
				else
					wea = 1;
			end
			
			if (patternID_pcre != 0) begin
				combine_ready = 0;
				web = 1;
				c_p = 2'b10;
			end
		end
		
		
		
	end
		
		/*
		if ((dout[8:7] != 0 && flow == dout[6:0]) || simultaneous_buf[1]) begin // dout[8] loai truog hop flow = 0
			if (addra_buf <= no_rule2)
				real_patternID = din_buf + no_rule1;
			else if (din_buf <= no_rule2 + no_rule4)
				real_patternID = din_buf + ac_rule3 - no_rule2;
			else
				real_patternID = din_buf + ac_rule5 - no_rule2 - no_rule4;
		end
		else if (out1 != 0)
			real_patternID = out1;
		else if (out2 != 0)
			real_patternID = out2;
		else if (out3 != 0)
			real_patternID = out3;
		else
			real_patternID = 0;
		*/
endmodule
