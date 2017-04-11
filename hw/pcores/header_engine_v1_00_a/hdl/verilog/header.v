module header 
		#(parameter BVSIZE = 211) 
				(
                  //Interface with Preprocessing Module
                  input [31:0] data,
                  input sa,
                  input da,
                  input sp_dp,
                  input prot,
                  input soh,
                  input eoh,
                  input rst,
                  input clk,
                  output hReady,
                  
                  //Interface with Management Module
                  input mReady,
                  output [BVSIZE-1 :0] dout,
                  output valid,
						output reg [9:0] vld_cnt,
						// fifo input
						input f1_rd_en,
						input f0_rd_en,
						// fifo output
						output f0_dout,
						output f0_empty,
						output f0_full,
						output f1_dout,
						output f1_empty,
						output f1_full	,
						output [3*BVSIZE -1: 0] db
              );
				  
		wire [103:0] cout;
		wire ce, pe;
		
		always @(posedge clk)
		begin
			if (rst == 1'b1) begin
				vld_cnt <= 10'b0;
			end
			if (valid == 1'b1)
				vld_cnt <= vld_cnt + 1;
			else vld_cnt <= vld_cnt;
		end
		
      consumer C  (
                    .data(data),
                    .sa(sa),
                    .da(da),
                    .sp_dp(sp_dp),
                    .prot(prot),
                    .soh(soh),
                    .eoh(eoh),
                    .rst(rst),
						  .clk(clk),
                    .odata(cout),
                    .valid(cvalid),
						  .f0_rd_en(f0_rd_en),
						  .f1_rd_en(f1_rd_en),
						  // fifo output
							.f0_dout(f0_dout),
							.f0_empty(f0_empty),
							.f0_full(f0_full),
							.f1_dout(f1_dout),
							.f1_empty(f1_empty),
							.f1_full(f1_full)
                  );

      processing #(.BVSIZE(BVSIZE)) P (
                    .idata(cout),
                    .ivalid(cvalid),
                    .enable(pe),
						  .rst(rst),
                    .clk(clk),
                    .pReady(pReady),
						  .dout(dout)
						  //, .db(db)
                  );

  assign pe = (mReady |(!pReady));
  assign hReady = pe;
  assign valid = pReady;
endmodule
