 module PCRE_Engine_Matching
	#(
	parameter NO_PCRE = 97
	)
	(
	//input
	input clk, iEn, iSod, iEod,iRst,
	input [7:0] iData,
	//output
	output [NO_PCRE -1 : 0 ] oPcre
	);
	Group_0 group0(
	.clk(clk),
	.rst(iRst),
.sod(iSod),
.eod(iEod),
.en(iEn),
.char(iData),
.out(oPcre)
);
endmodule
