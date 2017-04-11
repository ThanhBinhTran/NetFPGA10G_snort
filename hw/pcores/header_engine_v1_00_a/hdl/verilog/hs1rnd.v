module hash(
	input [15:0] key,
	input [15:0] h,
	output [7:0] outp
	);
	
	wire [15:0] c1,c2;
	wire [7:0] h1, h2;
	
	assign c1 = key[7:0];
	assign c2 = key[15:8];
	assign h1 = h[7:0];
	assign h2 = h[15:8];
	
	assign outp = (c2^h2) + (c1^h1);
endmodule
