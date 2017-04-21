module matching #(parameter BVSIZE = 256)(
	input [103:0] in,
	input clk, 
	input rst,
	output [BVSIZE -1 :0] finish,
	output [3*BVSIZE -1: 0] db);

	wire [BVSIZE -1:0] out_p, out_src, out_des;
	reg [BVSIZE -1:0] out_pro;
	assign db = {out_pro, out_src, out_des};
	always @(posedge clk)
	begin
		out_pro <= out_p;
	end
	Protocol_SA_DA #(.BVSIZE(BVSIZE))	pro	(
		.in(in[103:32]), 
		.outp(out_p));//72'h06_00000000_AC1C0000
		
	sourceport #(.BVSIZE(BVSIZE))			sour (
		.pattern(in[31:16]), 
		.clk(clk),
		.rst(rst),
		.out(out_src));//16'h0000
		
	destinationport #(.BVSIZE(BVSIZE))	dest(
		.pattern(in[15:0]), 
		.clk(clk),
		.rst(rst),
		.out(out_des));//16'h1d56
		
	assign finish = out_des & out_src & out_pro;
endmodule
