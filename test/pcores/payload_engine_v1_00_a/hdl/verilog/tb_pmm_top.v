`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:57:32 06/12/2013
// Design Name:   PMM_top
// Module Name:   /home/heckarim/work/ise/7.thesis/1.StaticEngine/tb_pmm_top.v
// Project Name:  testStaticEngine
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PMM_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_pmm_top;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] payload_in;
	reg payload_valid;
	reg start_of_packet;
	reg end_of_packet;
	reg enable_32byte_process;
	
	reg [7:0] char_in;
	reg[30*8:0] str;

	// Outputs
	wire filter_trigger;
	wire [10:0] rule_id;
	wire end_of_packet_shift;
	wire [10:0] input_pmm_debug;
	wire [12:0] output_pmm_debug;
	wire [29:0] static_engine_debug;
	wire [16:0] pcre_engine_debug;
	wire [11:0] index;
	wire [11:0] index_nocase;
	wire [13:0] patternID;
	wire [10:0] clk_counter;
	wire [10:0] index_counter;
	wire [51:0] debug_matching;
	wire state;

	// Instantiate the Unit Under Test (UUT)
	PMM_top uut (
		.clk(clk), 
		.rst(rst),
		.payload_in(payload_in), 
		.payload_valid(payload_valid), 
		.start_of_packet(start_of_packet), 
		.end_of_packet(end_of_packet), 
		.filter_trigger(filter_trigger), 
		.rule_id(rule_id), 
		.end_of_packet_shift(end_of_packet_shift), 
		.enable_32byte_process(enable_32byte_process), 
		.input_pmm_debug(input_pmm_debug), 
		.output_pmm_debug(output_pmm_debug), 
		.static_engine_debug(static_engine_debug), 
		.pcre_engine_debug(pcre_engine_debug), 
		.index(index), 
		.index_nocase(index_nocase), 
		.patternID(patternID), 
		.clk_counter(clk_counter), 
		.index_counter(index_counter), 
		.debug_matching(debug_matching), 
		.state(state)
	);

		
	integer fin,r,status0, fout;	
	integer clk_count;
	reg stop ;
	
	initial begin
		fin=$fopen("rule.testcase","r");
		fout=$fopen("rule.testresult","w");
		
	end	

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		payload_in = 0;
		payload_valid = 0;
		start_of_packet = 0;
		end_of_packet = 0;
		enable_32byte_process = 0;
		stop =0;
		#40 rst = 1'b1;
		#20 rst = 1'b0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		while (1) begin
			@(negedge clk);
			payload_in = char_in;
			payload_valid = 1'b1;
			start_of_packet = sop;
			end_of_packet = eop;
		end
	end

	reg [8:0] indexT3A[0:15];
	reg [8:0] indexT3B[0:15];
	integer j;
	reg [10:0] globalIndex;
	reg sop;
	reg eop;
	initial begin
		sop = 0;
		eop = 0;
		char_in = 0;
		#200;
		while ($fgets(str,fin))begin
			@(negedge clk);
			if(eop)
			begin
				eop = 1'b0;
				#500; //wait 100 ns before reading.
			end
			status0 = $sscanf(str,"%d-%b-%b-%h",globalIndex, sop, eop, char_in);
			//$fwrite(fout,"%b - %b\n", t3match, t3match_nocase);
			//for(j = 0; j<16; j=j+1)begin
			//	indexT3A[j] = addr_out_portA[8*(j+1)-1:8*j];
			//	indexT3B[j] = addr_out_portB[8*(j+1)-1:8*j];
			//end
			$display (" time %d str_in %h sop %b eop %b char_in %h - %c",$time, str,sop, eop, char_in, char_in);
		end
		#500;
		$fclose(fin);
		$fclose(fout);
		$stop;
		$finish;
	end

	initial begin
	    clk_count = 0;
		forever #10 clk = ~clk;
	end
	//dsfdsf
	reg [7:0] formatedchar;
	
	initial begin
		while(1) begin
			@(posedge clk);
			clk_count = clk_count + 1;
			//$fwrite(fout,"%c - %d - %b - %d - %d - %d - %d\n", char_in,clk_count, t3match_nocase, addr_out_portA_nocase[9*8-1:9*7], addr_out_portA_nocase[8*8-1:8*7], addr_out_portA[9*8-1:9*7], addr_out_portA[8*8-1:8*7]);
			if(char_in == 8'h2d) //-
				formatedchar = 32;
			else if(char_in< 127 && char_in >31)
				formatedchar = char_in;
			else 
				formatedchar = 32; //space
		   //$fwrite (fout,"%d-%c-%b-%h-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d\n", clk_count, formatedchar, t3match,patternID, t3MatchIndex[(0+1)*9-1:0*9], t3MatchIndex[(1+1)*9-1:1*9], t3MatchIndex[(2+1)*9-1:2*9], t3MatchIndex[(3+1)*9-1:3*9], t3MatchIndex[(4+1)*9-1:4*9], t3MatchIndex[(5+1)*9-1:5*9], t3MatchIndex[(6+1)*9-1:6*9], t3MatchIndex[(7+1)*9-1:7*9], t3MatchIndex[(8+1)*9-1:8*9], t3MatchIndex[(9+1)*9-1:9*9], t3MatchIndex[(10+1)*9-1:10*9], t3MatchIndex[(11+1)*9-1:11*9], t3MatchIndex[(12+1)*9-1:12*9], t3MatchIndex[(13+1)*9-1:13*9], t3MatchIndex[(14+1)*9-1:14*9], t3MatchIndex[(15+1)*9-1:15*9]);
		   //$fwrite (fout,"%d-%c-%b-%h-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d-%d\n", clk_count, formatedchar, t3match_nocase,patternID_nocase, t3MatchIndex_nocase[(0+1)*9-1:0*9], t3MatchIndex_nocase[(1+1)*9-1:1*9], t3MatchIndex_nocase[(2+1)*9-1:2*9], t3MatchIndex_nocase[(3+1)*9-1:3*9], t3MatchIndex_nocase[(4+1)*9-1:4*9], t3MatchIndex_nocase[(5+1)*9-1:5*9], t3MatchIndex_nocase[(6+1)*9-1:6*9], t3MatchIndex_nocase[(7+1)*9-1:7*9], t3MatchIndex_nocase[(8+1)*9-1:8*9], t3MatchIndex_nocase[(9+1)*9-1:9*9], t3MatchIndex_nocase[(10+1)*9-1:10*9], t3MatchIndex_nocase[(11+1)*9-1:11*9], t3MatchIndex_nocase[(12+1)*9-1:12*9], t3MatchIndex_nocase[(13+1)*9-1:13*9], t3MatchIndex_nocase[(14+1)*9-1:14*9], t3MatchIndex_nocase[(15+1)*9-1:15*9]);
		   $fwrite (fout, "%d-%c-%d\n",clk_count,formatedchar,rule_id);
		end
	end



      
endmodule

