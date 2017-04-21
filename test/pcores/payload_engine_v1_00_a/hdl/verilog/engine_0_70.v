module engine_0_70(out,clk,sod,en, in_26, in_56);
//pcre: /2x/.*php/Ui
//block char: x[0], 2[0], 

	input clk,sod,en;

	input in_26, in_56;
	output out;

	assign w0 = 1'b1;
	state_0_70_1 BlockState_0_70_1 (w1,in_56,clk,en,sod,w0);
	state_0_70_2 BlockState_0_70_2 (w2,in_26,clk,en,sod,w1);
	End_state_0_70_3 BlockState_0_70_3 (out,clk,en,sod,w2);
endmodule

module state_0_70_1(out1,in_char,clk,en,rst,in0);
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

module state_0_70_2(out1,in_char,clk,en,rst,in0);
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

module End_state_0_70_3(out1,clk,en,rst,in0);
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

