module engine_0_27(out,clk,sod,en, in_0, in_3, in_4, in_7, in_17, in_18, in_26, in_37, in_45);
//pcre: /^Conexion\x7c[^\r\n]*?\x7c[^\r\n]*?\x7c[^\r\n]*?\x7c/smi
//block char: ^[9], N[0], O[0], I[0], e[0], c[0], x[0], [^\r\n][2], \x7C[8], 

	input clk,sod,en;

	input in_0, in_3, in_4, in_7, in_17, in_18, in_26, in_37, in_45;
	output out;

	assign w0 = 1'b1;
	state_0_27_1 BlockState_0_27_1 (w1,in_0,clk,en,sod,w0);
	state_0_27_2 BlockState_0_27_2 (w2,in_18,clk,en,sod,w1);
	state_0_27_3 BlockState_0_27_3 (w3,in_4,clk,en,sod,w2);
	state_0_27_4 BlockState_0_27_4 (w4,in_3,clk,en,sod,w3);
	state_0_27_5 BlockState_0_27_5 (w5,in_17,clk,en,sod,w4);
	state_0_27_6 BlockState_0_27_6 (w6,in_26,clk,en,sod,w5);
	state_0_27_7 BlockState_0_27_7 (w7,in_7,clk,en,sod,w6);
	state_0_27_8 BlockState_0_27_8 (w8,in_4,clk,en,sod,w7);
	state_0_27_9 BlockState_0_27_9 (w9,in_3,clk,en,sod,w8);
	state_0_27_10 BlockState_0_27_10 (w10,in_45,clk,en,sod,w9);
	state_0_27_11 BlockState_0_27_11 (w11,in_37,clk,en,sod,w11,w10);
	state_0_27_12 BlockState_0_27_12 (w12,in_45,clk,en,sod,w10,w10,w11);
	state_0_27_13 BlockState_0_27_13 (w13,in_37,clk,en,sod,w13,w12);
	state_0_27_14 BlockState_0_27_14 (w14,in_45,clk,en,sod,w12,w12,w13);
	state_0_27_15 BlockState_0_27_15 (w15,in_37,clk,en,sod,w15,w14);
	state_0_27_16 BlockState_0_27_16 (w16,in_45,clk,en,sod,w14,w14,w15);
	End_state_0_27_17 BlockState_0_27_17 (out,clk,en,sod,w16);
endmodule

module state_0_27_1(out1,in_char,clk,en,rst,in0);
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

module state_0_27_2(out1,in_char,clk,en,rst,in0);
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

module state_0_27_3(out1,in_char,clk,en,rst,in0);
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

module state_0_27_4(out1,in_char,clk,en,rst,in0);
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

module state_0_27_5(out1,in_char,clk,en,rst,in0);
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

module state_0_27_6(out1,in_char,clk,en,rst,in0);
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

module state_0_27_7(out1,in_char,clk,en,rst,in0);
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

module state_0_27_8(out1,in_char,clk,en,rst,in0);
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

module state_0_27_9(out1,in_char,clk,en,rst,in0);
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

module state_0_27_10(out1,in_char,clk,en,rst,in0);
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

module state_0_27_11(out1,in_char,clk,en,rst,in0,in1);
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

module state_0_27_12(out1,in_char,clk,en,rst,in0,in1,in2);
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

module state_0_27_13(out1,in_char,clk,en,rst,in0,in1);
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

module state_0_27_14(out1,in_char,clk,en,rst,in0,in1,in2);
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

module state_0_27_15(out1,in_char,clk,en,rst,in0,in1);
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

module state_0_27_16(out1,in_char,clk,en,rst,in0,in1,in2);
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

module End_state_0_27_17(out1,clk,en,rst,in0);
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

