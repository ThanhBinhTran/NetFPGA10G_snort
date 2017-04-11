
/*
	compare 2 numbers inp1 and inp2
*/
module compare_h 
	#(
	parameter WIDTH=10
	)
	(
	input [WIDTH-1: 0] 	inp1,
	input [WIDTH-1: 0] 	inp2,
	output 					out
	);
	assign out = (inp1 == inp2)? 1'b1 : 1'b0;
endmodule
