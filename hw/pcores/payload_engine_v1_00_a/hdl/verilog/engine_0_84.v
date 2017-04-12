module engine_0_84(out,clk,sod,en, in_15, in_21, in_41, in_109);
//pcre: /.map/[^\n]*script[^\n]*script/i
//block char: a[0], p[0], M[0], .[7], 

	input clk,sod,en;

	input in_15, in_21, in_41, in_109;
	output out;

	assign w0 = 1'b1;
	state_0_84_1 BlockState_0_84_1 (w1,in_109,clk,en,sod,w0);
	state_0_84_2 BlockState_0_84_2 (w2,in_41,clk,en,sod,w1);
	state_0_84_3 BlockState_0_84_3 (w3,in_15,clk,en,sod,w2);
	state_0_84_4 BlockState_0_84_4 (w4,in_21,clk,en,sod,w3);
	End_state_0_84_5 BlockState_0_84_5 (out,clk,en,sod,w4);
endmodule

module state_0_84_1(out1,in_char,clk,en,rst,in0);
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

module state_0_84_2(out1,in_char,clk,en,rst,in0);
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

module state_0_84_3(out1,in_char,clk,en,rst,in0);
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

module state_0_84_4(out1,in_char,clk,en,rst,in0);
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

module End_state_0_84_5(out1,clk,en,rst,in0);
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

