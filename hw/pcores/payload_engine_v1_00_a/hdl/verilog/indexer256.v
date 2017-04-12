`timescale 1ns / 1ps

module indexer256 #(
		parameter VECTOR_SIZE = 256
	)(
		input clk,
		input rst,

		input ld,
		input rd_en,

		input [VECTOR_SIZE-1:0] i_din,
		output empty,

		output [8:0] o_dout
    );

wire [255:0] din;

reg [8:0] dout;
wire dvld;

wire [31:0] din00;
wire [31:0] din01;
wire [31:0] din02;
wire [31:0] din03;
wire [31:0] din04;
wire [31:0] din05;
wire [31:0] din06;
wire [31:0] din07;


wire [4:0] dout00;
wire [4:0] dout01;
wire [4:0] dout02;
wire [4:0] dout03;
wire [4:0] dout04;
wire [4:0] dout05;
wire [4:0] dout06;
wire [4:0] dout07;


reg [4:0] dout00_bf;
reg [4:0] dout01_bf;
reg [4:0] dout02_bf;
reg [4:0] dout03_bf;
reg [4:0] dout04_bf;
reg [4:0] dout05_bf;
reg [4:0] dout06_bf;
reg [4:0] dout07_bf;

wire [7:0] lev0vld;

wire pse;
wire full;

wire [8:0] d_buf;



reg [7:0] match_reg;
wire [7:0] next_match;
reg [7:0] match_mask;

assign din = { {(256 - VECTOR_SIZE){'b0}},i_din};

assign pse = |(match_reg & match_mask);

assign {din07, din06, din05, din04, din03, din02, din01, din00} = din;

indexer32 u00(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din00), .dvld(lev0vld[00]), .dout(dout00));
indexer32 u01(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din01), .dvld(lev0vld[01]), .dout(dout01));
indexer32 u02(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din02), .dvld(lev0vld[02]), .dout(dout02));
indexer32 u03(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din03), .dvld(lev0vld[03]), .dout(dout03));
indexer32 u04(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din04), .dvld(lev0vld[04]), .dout(dout04));
indexer32 u05(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din05), .dvld(lev0vld[05]), .dout(dout05));
indexer32 u06(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din06), .dvld(lev0vld[06]), .dout(dout06));
indexer32 u07(.clk(clk), .rst(rst), .pse(pse), .ld(ld), .din(din07), .dvld(lev0vld[07]), .dout(dout07));

assign next_match = (rst == 1'b1) ? 8'h00 : (pse == 1'b0 && full == 1'b0) ? lev0vld : (match_reg & match_mask);

always @(posedge clk) begin
	if (rst)
		match_reg <= 8'h00;
	else
		match_reg <= next_match;	
end

assign dvld = (rst == 1'b1) ? 1'b0 : (ld == 1'b1) ? 1'b1 : (| match_reg);

always @(posedge clk) begin
	if(pse == 1'b0) begin
		dout00_bf <= dout00;
		dout01_bf <= dout01;
		dout02_bf <= dout02;
		dout03_bf <= dout03;
		dout04_bf <= dout04;
		dout05_bf <= dout05;
		dout06_bf <= dout06;
		dout07_bf <= dout07;

	end else begin
		dout00_bf <= dout00_bf;
		dout01_bf <= dout01_bf;
		dout02_bf <= dout02_bf;
		dout03_bf <= dout03_bf;
		dout04_bf <= dout04_bf;
		dout05_bf <= dout05_bf;
		dout06_bf <= dout06_bf;
		dout07_bf <= dout07_bf;
		
	end
end

always @(match_reg or
         dout00_bf or dout01_bf or dout02_bf or dout03_bf or dout04_bf or dout05_bf or dout06_bf or dout07_bf  
        ) begin
	casez(match_reg)
	
	8'b????_???1: begin
		match_mask = 8'b1111_1110;
		dout = {4'h00, dout00_bf};
	end
	8'b????_??10: begin
		match_mask = 8'b1111_1100;
		dout = {4'h01, dout01_bf};
		
	end
	8'b????_?100: begin
		match_mask = 8'b1111_1000;
		dout = {4'h02, dout02_bf};
		
	end
	8'b????_1000: begin
		match_mask = 8'b1111_0000;
		dout = {4'h03, dout03_bf};
		
	end
	8'b???1_0000: begin
		match_mask = 8'b1110_0000;
		dout = {4'h04, dout04_bf};
		
	end
	8'b??10_0000: begin
		match_mask = 8'b1100_0000;
		dout = {4'h05, dout05_bf};
		
	end
	8'b?100_0000: begin
		match_mask = 8'b1000_0000;
		dout = {4'h06, dout06_bf};
		
	end
	8'b1000_0000: begin
		match_mask = 8'b0000_0000;
		dout = {4'h07, dout07_bf};
		
	end
	8'b0000_0000: begin
		match_mask = 8'b0000_0000;
		dout = 9'h100;
	end
	
	default: begin
		match_mask = 8'b0000_0000;
		dout = 9'h000;
		
	end
	endcase
end

	assign d_buf = (dout != 9'h100) ? (dout + 1'b1) : 9'h000;

	main_fifo fifo (
	.clk(clk),
	.din(d_buf), // Bus [8 : 0] 
	.rd_en(rd_en),
	.rst(rst),
	.wr_en(dvld),
	.dout(o_dout), // Bus [8 : 0] 
	.empty(empty),
	.full(full)
	);



endmodule
