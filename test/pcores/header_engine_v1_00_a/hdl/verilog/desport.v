module destinationport #(parameter BVSIZE = 160)(
	input [15:0] pattern,
	input rst,
	input clk,
	output [BVSIZE -1:0] out
	/*,output reg [9:0] index,
	output [7:0] h1,h2,
	output [15:0] p1,p2,
	output  [9:0] t1,t2*/
	);

	wire [9:0] t1,t2;
	wire [7:0] h1,h2;  //hash value
	
	wire [15:0] p1,p2;
	reg [9:0] index;
	reg [15:0] res1,res2;
	
	wire [BVSIZE-1:0] pvec;
	wire [141:0] p;
	wire match1,match2;
	
	
	
	hash has1(pattern, 16'd49135, h1);  // changed the hash function
	hash has2(pattern, 16'd14064, h2);
	
	//ramsp1 rsp1(h1, clk, 10'h0, t1, 1'b0);	
	/*ramsp1 rsp1(
		.addr(h1),
		.clk(clk),
		.dout(t1));*/
	
	assign out = pvec;
	always @(posedge clk)
	begin
		if (rst) begin 
			res1 <= 529'h0;
			res2 <= 529'h0;
		end
		else begin
			{res2,res1} <= {res1,pattern};
		end
	end
	//assign out = spvec;
	ramdp1 rdp1(
		.clka(clk),
		.dina(8'h0),
		.addra(h1),
		.wea(1'b0),
		.douta(t1));
	//ramsp2 rsp2(h2, clk, 10'h0, t2, 1'b0);
	/*ramsp2 rsp2(
		.addr(h2),
		.clk(clk),
		.dout(t2));*/
	ramdp2 rdp2(
		.clka(clk),
		.dina(8'h0),
		.addra(h2),
		.wea(1'b0),
		.douta(t2));
	//ramsp3 rsp3(t1,t2,clk,clk,16'h0,16'h0,p1,p2,1'b0,1'b0);
	/*ramsp3 rsp3(
		.addra(t1),
		.addrb(t2),
		.clka(clk),
		.clkb(clk),
		.douta(p1),
		.doutb(p2));*/
	ramdp3 rdp3(
		.clka(clk),
		.dina(16'h0),
		.addra(t1),
		.wea(1'b0),
		.douta(p1),
		.clkb(clk),
		.dinb(16'h0),
		.addrb(t2),
		.web(1'b0),
		.doutb(p2));
		
	compare_h #(.WIDTH(16)) cmp1(res2, p1, match1);
	compare_h #(.WIDTH(16)) cmp2(res2, p2, match2);
	
	always @(posedge clk)
	begin
		//$display("At time match1 index ");
		if (rst) begin
			index <= 0;
		end
		else begin
			if(match1 == 1'b1)
				index <= t1;
			else if(match2 == 1'b1)
				index <= t2;
			else
				index <= 10'd530; // not found
		end
	end
	


	/*ramsp4 indexlvl2 (
		.clka(clk),
		.dina(10'd0), // Bus [9 : 0] 
		.addra(index0), // Bus [3 : 0] 
		.wea(1'b1), // Bus [0 : 0] 
		.douta(index)); // Bus [9 : 0] 
		*/


	compare_h com0(index, 10'd0, p[0]);
	compare_h com1(index, 10'd1, p[1]);
	compare_h com2(index, 10'd2, p[2]);
	compare_h com3(index, 10'd3, p[3]);
	compare_h com4(index, 10'd4, p[4]);
	compare_h com5(index, 10'd5, p[5]);
	compare_h com6(index, 10'd6, p[6]);
	compare_h com7(index, 10'd7, p[7]);
	compare_h com8(index, 10'd8, p[8]);
	compare_h com9(index, 10'd9, p[9]);
	compare_h com10(index, 10'd10, p[10]);
	compare_h com11(index, 10'd11, p[11]);
	compare_h com12(index, 10'd12, p[12]);
	compare_h com13(index, 10'd13, p[13]);
	compare_h com14(index, 10'd14, p[14]);
	compare_h com15(index, 10'd15, p[15]);
	compare_h com16(index, 10'd16, p[16]);
	compare_h com17(index, 10'd17, p[17]);
	compare_h com18(index, 10'd18, p[18]);
	compare_h com19(index, 10'd19, p[19]);
	compare_h com20(index, 10'd20, p[20]);
	compare_h com21(index, 10'd21, p[21]);
	compare_h com22(index, 10'd22, p[22]);
	compare_h com23(index, 10'd23, p[23]);
	compare_h com24(index, 10'd24, p[24]);
	compare_h com25(index, 10'd25, p[25]);
	compare_h com26(index, 10'd26, p[26]);
	compare_h com27(index, 10'd27, p[27]);
	compare_h com28(index, 10'd28, p[28]);
	compare_h com29(index, 10'd29, p[29]);
	compare_h com30(index, 10'd30, p[30]);
	compare_h com31(index, 10'd31, p[31]);
	compare_h com32(index, 10'd32, p[32]);
	compare_h com33(index, 10'd33, p[33]);
	compare_h com34(index, 10'd34, p[34]);
	compare_h com35(index, 10'd35, p[35]);
	compare_h com36(index, 10'd36, p[36]);
	compare_h com37(index, 10'd37, p[37]);
	compare_h com38(index, 10'd38, p[38]);
	compare_h com39(index, 10'd39, p[39]);
	compare_h com40(index, 10'd40, p[40]);
	compare_h com41(index, 10'd41, p[41]);
	compare_h com42(index, 10'd42, p[42]);
	compare_h com43(index, 10'd43, p[43]);
	compare_h com44(index, 10'd44, p[44]);
	compare_h com45(index, 10'd45, p[45]);
	compare_h com46(index, 10'd46, p[46]);
	compare_h com47(index, 10'd47, p[47]);
	compare_h com48(index, 10'd48, p[48]);
	compare_h com49(index, 10'd49, p[49]);
	compare_h com50(index, 10'd50, p[50]);
	compare_h com51(index, 10'd51, p[51]);
	compare_h com52(index, 10'd52, p[52]);
	compare_h com53(index, 10'd53, p[53]);
	compare_h com54(index, 10'd54, p[54]);
	compare_h com55(index, 10'd55, p[55]);
	compare_h com56(index, 10'd56, p[56]);
	compare_h com57(index, 10'd57, p[57]);
	compare_h com58(index, 10'd58, p[58]);
	compare_h com59(index, 10'd59, p[59]);
	compare_h com60(index, 10'd60, p[60]);
	compare_h com61(index, 10'd61, p[61]);
	compare_h com62(index, 10'd62, p[62]);
	compare_h com63(index, 10'd63, p[63]);
	compare_h com64(index, 10'd64, p[64]);
	compare_h com65(index, 10'd65, p[65]);
	compare_h com66(index, 10'd66, p[66]);
	compare_h com67(index, 10'd67, p[67]);
	compare_h com68(index, 10'd68, p[68]);
	compare_h com69(index, 10'd69, p[69]);
	compare_h com70(index, 10'd70, p[70]);
	compare_h com71(index, 10'd71, p[71]);
	compare_h com72(index, 10'd72, p[72]);
	compare_h com73(index, 10'd73, p[73]);
	compare_h com74(index, 10'd74, p[74]);
	compare_h com75(index, 10'd75, p[75]);
	compare_h com76(index, 10'd76, p[76]);
	compare_h com77(index, 10'd77, p[77]);
	compare_h com78(index, 10'd78, p[78]);
	compare_h com79(index, 10'd79, p[79]);
	compare_h com80(index, 10'd80, p[80]);
	compare_h com81(index, 10'd81, p[81]);
	compare_h com82(index, 10'd82, p[82]);
	compare_h com83(index, 10'd83, p[83]);
	compare_h com84(index, 10'd84, p[84]);
	compare_h com85(index, 10'd85, p[85]);
	compare_h com86(index, 10'd86, p[86]);
	compare_h com87(index, 10'd87, p[87]);
	compare_h com88(index, 10'd88, p[88]);
	compare_h com89(index, 10'd89, p[89]);
	compare_h com90(index, 10'd90, p[90]);
	compare_h com91(index, 10'd91, p[91]);
	compare_h com92(index, 10'd92, p[92]);
	compare_h com93(index, 10'd93, p[93]);
	compare_h com94(index, 10'd94, p[94]);
	compare_h com95(index, 10'd95, p[95]);
	compare_h com96(index, 10'd96, p[96]);
	compare_h com97(index, 10'd97, p[97]);
	compare_h com98(index, 10'd98, p[98]);
	compare_h com99(index, 10'd99, p[99]);
	compare_h com100(index, 10'd100, p[100]);
	compare_h com101(index, 10'd101, p[101]);
	compare_h com102(index, 10'd102, p[102]);
	compare_h com103(index, 10'd103, p[103]);
	compare_h com104(index, 10'd104, p[104]);
	compare_h com105(index, 10'd105, p[105]);
	compare_h com106(index, 10'd106, p[106]);
	compare_h com107(index, 10'd107, p[107]);
	compare_h com108(index, 10'd108, p[108]);
	compare_h com109(index, 10'd109, p[109]);
	compare_h com110(index, 10'd110, p[110]);
	compare_h com111(index, 10'd111, p[111]);
	compare_h com112(index, 10'd112, p[112]);
	compare_h com113(index, 10'd113, p[113]);
	compare_h com114(index, 10'd114, p[114]);
	compare_h com115(index, 10'd115, p[115]);
	compare_h com116(index, 10'd116, p[116]);
	compare_h com117(index, 10'd117, p[117]);
	compare_h com118(index, 10'd118, p[118]);
	compare_h com119(index, 10'd119, p[119]);
	compare_h com120(index, 10'd120, p[120]);
	compare_h com121(index, 10'd121, p[121]);
	compare_h com122(index, 10'd122, p[122]);
	compare_h com123(index, 10'd123, p[123]);
	compare_h com124(index, 10'd124, p[124]);
	compare_h com125(index, 10'd125, p[125]);
	compare_h com126(index, 10'd126, p[126]);
	compare_h com127(index, 10'd127, p[127]);
	compare_h com128(index, 10'd128, p[128]);
	compare_h com129(index, 10'd129, p[129]);
	compare_h com130(index, 10'd130, p[130]);
	compare_h com131(index, 10'd131, p[131]);
	compare_h com132(index, 10'd132, p[132]);
	compare_h com133(index, 10'd133, p[133]);
	compare_h com134(index, 10'd134, p[134]);
	compare_h com135(index, 10'd135, p[135]);
	compare_h com136(index, 10'd136, p[136]);
	compare_h com137(index, 10'd137, p[137]);
	compare_h com138(index, 10'd138, p[138]);
	compare_h com139(index, 10'd139, p[139]);
	compare_h com140(index, 10'd140, p[140]);
	assign pvec[0] = 1;
	or (pvec[1], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15], p[16], p[17], p[18], p[19], p[20], p[21], p[22], p[23], p[24], p[25], p[26], p[27], p[28], p[29], p[30], p[31], p[32], p[33], p[34]);
	assign pvec[2] = p[35];
	or (pvec[3], p[1], p[36], p[35]);
	assign pvec[4] = p[37];
	assign pvec[5] = 1;
	assign pvec[6] = 1;
	assign pvec[7] = p[38];
	or (pvec[8], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15], p[16], p[17], p[18], p[19], p[20], p[21], p[22], p[23], p[24], p[25], p[26], p[27], p[28], p[29], p[30], p[31], p[32], p[33], p[34]);
	assign pvec[9] = 1;
	assign pvec[10] = 1;
	assign pvec[11] = p[39];
	assign pvec[12] = 1;
	assign pvec[13] = 1;
	assign pvec[14] = 1;
	assign pvec[15] = p[40];
	assign pvec[16] = p[41];
	assign pvec[17] = p[42];
	assign pvec[18] = p[43];
	assign pvec[19] = p[44];
	assign pvec[20] = 1;
	assign pvec[21] = p[45];
	assign pvec[22] = 1;
	assign pvec[23] = p[46];
	assign pvec[24] = p[47];
	assign pvec[25] = p[48];
	assign pvec[26] = p[49];
	assign pvec[27] = p[50];
	assign pvec[28] = 1;
	assign pvec[29] = p[51];
	assign pvec[30] = 1;
	assign pvec[31] = 1;
	assign pvec[32] = 1;
	assign pvec[33] = 1;
	assign pvec[34] = p[52];
	assign pvec[35] = 1;
	assign pvec[36] = p[16];
	assign pvec[37] = p[53];
	assign pvec[38] = p[54];
	assign pvec[39] = 1;
	assign pvec[40] = p[55];
	assign pvec[41] = 1;
	assign pvec[42] = p[56];
	assign pvec[43] = 1;
	assign pvec[44] = p[57];
	assign pvec[45] = 1;
	assign pvec[46] = p[58];
	assign pvec[47] = p[59];
	assign pvec[48] = 1;
	assign pvec[49] = p[60];
	assign pvec[50] = p[61];
	assign pvec[51] = 1;
	assign pvec[52] = 1;
	c_compare c_com53(pattern, 16'd1024, 16'd65535, pvec[53]);
	assign pvec[54] = p[62];
	assign pvec[55] = 1;
	or (pvec[56], p[63], p[64]);
	assign pvec[57] = 1;
	assign pvec[58] = 1;
	assign pvec[59] = p[65];
	assign pvec[60] = 1;
	assign pvec[61] = p[66];
	assign pvec[62] = p[67];
	assign pvec[63] = p[68];
	assign pvec[64] = 1;
	assign pvec[65] = 1;
	assign pvec[66] = 1;
	assign pvec[67] = 1;
	assign pvec[68] = p[69];
	assign pvec[69] = 1;
	assign pvec[70] = 1;
	assign pvec[71] = p[70];
	or (pvec[72], p[71], p[72]);
	assign pvec[73] = p[73];
	assign pvec[74] = 1;
	assign pvec[75] = 1;
	assign pvec[76] = p[74];
	assign pvec[77] = p[75];
	assign pvec[78] = 1;
	assign pvec[79] = 1;
	assign pvec[80] = 1;
	assign pvec[81] = p[76];
	assign pvec[82] = 1;
	assign pvec[83] = p[77];
	assign pvec[84] = p[78];
	assign pvec[85] = p[79];
	assign pvec[86] = p[80];
	c_compare c_com87(pattern, 16'd1024, 16'd65535, pvec[87]);
	assign pvec[88] = 1;
	assign pvec[89] = 1;
	assign pvec[90] = 1;
	assign pvec[91] = 1;
	assign pvec[92] = p[81];
	assign pvec[93] = p[82];
	assign pvec[94] = p[83];
	assign pvec[95] = 1;
	assign pvec[96] = 1;
	assign pvec[97] = p[84];
	assign pvec[98] = 1;
	assign pvec[99] = 1;
	assign pvec[100] = 1;
	assign pvec[101] = p[85];
	assign pvec[102] = 1;
	assign pvec[103] = p[86];
	assign pvec[104] = p[37];
	assign pvec[105] = 1;
	assign pvec[106] = p[87];
	or (pvec[107], p[44], p[37], p[1], p[36]);
	assign pvec[108] = p[88];
	assign pvec[109] = p[89];
	c_compare c_com110(pattern, 16'd1024, 16'd65535, pvec[110]);
	assign pvec[111] = p[90];
	assign pvec[112] = p[91];
	assign pvec[113] = p[92];
	assign pvec[114] = p[93];
	assign pvec[115] = 1;
	assign pvec[116] = p[94];
	assign pvec[117] = p[95];
	assign pvec[118] = p[29];
	assign pvec[119] = p[96];
	assign pvec[120] = p[97];
	assign pvec[121] = 1;
	assign pvec[122] = p[98];
	assign pvec[123] = p[99];
	assign pvec[124] = p[36];
	assign pvec[125] = p[100];
	assign pvec[126] = 1;
	or (pvec[127], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15], p[16], p[17], p[18], p[19], p[20], p[21], p[22], p[23], p[24], p[25], p[26], p[27], p[28], p[29], p[30], p[31], p[32], p[33], p[34]);
	assign pvec[128] = p[101];
	assign pvec[129] = p[102];
	assign pvec[130] = p[103];
	assign pvec[131] = p[104];
	assign pvec[132] = p[105];
	assign pvec[133] = 1;
	c_compare c_com134(pattern, 16'd3127, 16'd3199, pvec[134]);
	assign pvec[135] = p[106];
	assign pvec[136] = p[107];
	assign pvec[137] = p[108];
	assign pvec[138] = p[109];
	assign pvec[139] = p[110];
	assign pvec[140] = p[21];
	or (pvec[141], p[43], p[73]);
	assign pvec[142] = 1;
	or (pvec[143], p[111], p[21]);
	assign pvec[144] = p[86];
	assign pvec[145] = p[30];
	or (pvec[146], p[112], p[113], p[114], p[115], p[116], p[117], p[118], p[29]);
	assign pvec[147] = 1;
	assign pvec[148] = p[1];
	assign pvec[149] = p[86];
	c_compare c_com150(pattern, 16'd1024, 16'd65535, pvec[150]);
	assign pvec[151] = p[119];
	c_compare c_com152(pattern, 16'd6000, 16'd7000, pvec[152]);
	assign pvec[153] = p[120];
	assign pvec[154] = p[121];
	assign pvec[155] = p[122];
	assign pvec[156] = p[123];
	assign pvec[157] = 1;
	assign pvec[158] = 1;
	or (pvec[159], p[30], p[31]);
	assign pvec[160] = p[124];
	assign pvec[161] = 1;
	assign pvec[162] = p[125];
	assign pvec[163] = p[126];
	assign pvec[164] = p[127];
	or (pvec[165], p[43], p[73]);
	assign pvec[166] = p[128];
	assign pvec[167] = p[129];
	assign pvec[168] = 1;
	assign pvec[169] = p[1];
	c_compare c_com170(pattern, 16'd1024, 16'd65535, pvec[170]);
	assign pvec[171] = p[130];
	or (pvec[172], p[86], p[131]);
	c_compare c_com173(pattern, 16'd6664, 16'd6669, pvec[173]);
	assign pvec[174] = p[132];
	assign pvec[175] = p[133];
	c_compare c_com176(pattern, 16'd1024, 16'd65535, pvec[176]);
	or (pvec[177], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15], p[16], p[17], p[18], p[19], p[20], p[21], p[22], p[23], p[24], p[25], p[26], p[27], p[28], p[29], p[30], p[31], p[32], p[33], p[34]);
	assign pvec[178] = p[134];
	assign pvec[179] = p[135];
	assign pvec[180] = 1;
	assign pvec[181] = 1;
	assign pvec[182] = p[136];
	assign pvec[183] = 1;
	assign pvec[184] = p[137];
	assign pvec[185] = p[138];
	assign pvec[186] = 1;
	assign pvec[187] = 1;
	assign pvec[188] = p[139];
	assign pvec[189] = p[140];
	assign pvec[190] = p[41];
	assign pvec[191] = 1;
	assign pvec[192] = 1;
	assign pvec[193] = p[21];
	assign pvec[194] = 1;


	
endmodule
