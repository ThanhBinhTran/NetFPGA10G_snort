module processing #(parameter BVSIZE = 160) (
  input [103:0] idata,
  input ivalid,
  input rst,
  input enable,
  input clk,
  output reg pReady,
  output reg [BVSIZE-1 : 0] dout
	//,output [3*BVSIZE -1: 0] db
  );

	reg [3:0] cnt; 
	reg [103 : 0] BVin;
	wire [BVSIZE-1: 0] out_;
		matching #(.BVSIZE(BVSIZE)) M  (
						.in(BVin),
						.clk(clk),
						.rst(rst),
						.finish(out_)
						//,.db(db)
						);
		//Wait for pReady
		always @(posedge clk)
			begin
			BVin <= BVin;
			cnt <= cnt;
			dout <= 'h0;
			pReady <= 1'b0;
			if (rst == 1'b1) begin
				cnt <= 0;
				BVin <= 'h0;
				dout <= 'h0;
				pReady <= 1'b0;
			 end
			else if (enable == 1'b1) 
			  begin
				 if (ivalid == 1'b1) begin
					BVin <= idata;
					cnt <= 4'h5;
				end else if (cnt != 4'h0) begin
					cnt <= cnt -1;
					if (cnt == 4'h1) begin
						dout <= out_;
						pReady <= 1;
						$display("%h", out_);
					end
				 end
			  end
		 end
endmodule



