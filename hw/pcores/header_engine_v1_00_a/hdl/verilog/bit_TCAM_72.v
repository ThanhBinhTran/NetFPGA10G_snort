module bit_TCAM
	#(parameter WIDTH = 72)
	(compare_value, TCAM_value, TCAM_mask, match_bit);
	input [WIDTH-1 : 0] compare_value;
	input [WIDTH-1 : 0] TCAM_value;
	input [WIDTH-1 : 0] TCAM_mask;
	
	output wire match_bit;
	assign match_bit = &(~(TCAM_mask & (compare_value ^ TCAM_value)));
endmodule