module engine_0_95(out,clk,sod,en, in_1, in_2, in_42, in_43);
//pcre: /\x28\s*\w+\s*\x29/R
//block char: \x20[8], \w[6], \x28[8], \x29[8], 

	input clk,sod,en;

	input in_1, in_2, in_42, in_43;
	output out;

	assign w0 = 1'b1;
	state_0_95_1 BlockState_0_95_1 (w1,in_42,clk,en,sod,w0);
	state_0_95_2 BlockState_0_95_2 (w2,in_1,clk,en,sod,w2,w1);
	state_0_95_3 BlockState_0_95_3 (w3,in_2,clk,en,sod,w3,w1,w2);
	state_0_95_4 BlockState_0_95_4 (w4,in_1,clk,en,sod,w4,w3);
	state_0_95_5 BlockState_0_95_5 (w5,in_43,clk,en,sod,w3,w4);
	End_state_0_95_6 BlockState_0_95_6 (out,clk,en,sod,w5);
endmodule

module state_0_95_1(out1,in_char,clk,en,rst,in0);
	input in_char,clk,en,rst,in0;
	output out1;
	wire w1,w2;
	assign w1 = in0; 
	and(w2,in_char,w1);
	FDCE #(.INIT(1'b0)) FDCE_inst (
		.Q(out1),
		.C(clk),
		.CE(en),
		.CLR(rst),
		.D(w2)
);
endmodule

module state_0_95_2(out1,in_char,clk,en,rst,in0,in1);
	input in_char,clk,en,rst,in0,in1;
	output out1;
	wire w1,w2;
	or(w1,in0,in1);
	and(w2,in_char,w1);
	FDCE #(.INIT(1'b0)) FDCE_inst (
		.Q(out1),
		.C(clk),
		.CE(en),
		.CLR(rst),
		.D(w2)
);
endmodule

module state_0_95_3(out1,in_char,clk,en,rst,in0,in1,in2);
	input in_char,clk,en,rst,in0,in1,in2;
	output out1;
	wire w1,w2;
	or(w1,in0,in1,in2);
	and(w2,in_char,w1);
	FDCE #(.INIT(1'b0)) FDCE_inst (
		.Q(out1),
		.C(clk),
		.CE(en),
		.CLR(rst),
		.D(w2)
);
endmodule

module state_0_95_4(out1,in_char,clk,en,rst,in0,in1);
	input in_char,clk,en,rst,in0,in1;
	output out1;
	wire w1,w2;
	or(w1,in0,in1);
	and(w2,in_char,w1);
	FDCE #(.INIT(1'b0)) FDCE_inst (
		.Q(out1),
		.C(clk),
		.CE(en),
		.CLR(rst),
		.D(w2)
);
endmodule

module state_0_95_5(out1,in_char,clk,en,rst,in0,in1);
	input in_char,clk,en,rst,in0,in1;
	output out1;
	wire w1,w2;
	or(w1,in0,in1);
	and(w2,in_char,w1);
	FDCE #(.INIT(1'b0)) FDCE_inst (
		.Q(out1),
		.C(clk),
		.CE(en),
		.CLR(rst),
		.D(w2)
);
endmodule

module End_state_0_95_6(out1,clk,en,rst,in0);
	input clk,rst,en,in0;
	output out1;
	wire w1;
	or(w1,out1,in0);
	FDCE #(.INIT(1'b0)) FDCE_inst (
		.Q(out1),
		.C(clk),
		.CE(en),
		.CLR(rst),
		.D(w1)
);
endmodule

