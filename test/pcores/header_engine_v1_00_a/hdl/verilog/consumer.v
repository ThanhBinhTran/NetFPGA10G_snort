module consumer (
                  input [31:0] data,
                  input sa,
                  input da,
                  input sp_dp,
                  input prot,
                  input soh,
                  input eoh,
						input f0_rd_en,
						input f1_rd_en,
                  input rst,
                  input clk,
                  output [103:0] odata,
                  output reg valid,
						// fifo output
						output f0_dout,
						output f0_empty,
						output f0_full,
						output f1_dout,
						output f1_empty,
						output f1_full
                );
  reg [31:0] sa_reg, da_reg;
  reg [15:0] sp_reg, dp_reg;
  reg [7:0] protl_reg;

  parameter IDLE = 2'h0,
            START = 2'h1,
            RUNNING = 2'h2;
  reg [1:0] state;
  reg wr_en;


	/*fifo F0 (
		.clk(clk),
		.din(data), // Bus [31 : 0] 
		.rd_en(f0_rd_en),
		.rst(rst),
		.wr_en(wr_en),
		.dout(f0_dout), // Bus [31 : 0] 
		.empty(f0_empty),
		.full(f0_full));

	fifo F1 (
		.clk(clk),
		.din(data), // Bus [31 : 0] 
		.rd_en(f1_rd_en),
		.rst(rst),
		.wr_en(wr_en),
		.dout(f1_dout), // Bus [31 : 0] 
		.empty(f1_empty),
		.full(f1_full));
*/
 always @(posedge clk)
  begin
    if (rst == 1'b1)
      begin
        state <= IDLE;
        sa_reg <= 32'h0;
        da_reg <= 32'h0;
        sp_reg <= 16'h0;
        dp_reg <= 16'h0;
        protl_reg <= 16'h0;
      end
    else 
        begin
        // Default value
        state <= state;
        sa_reg <= sa_reg;
        da_reg <= da_reg;
        sp_reg <= sp_reg;
        dp_reg <= dp_reg;
        protl_reg <= protl_reg;
		  valid <= valid;
			wr_en <= 0;
        case (state)
          IDLE:
				begin
					valid <= 1'b0;
					if (soh == 1'b1) 
              		state <= START; 
            end
          START:
            if (sa == 1'b1) begin
              sa_reg <= data[31:0];
				  wr_en <= 1;
				  end
            else if (da == 1'b1) begin
              da_reg <= data[31:0]; 
				  wr_en <= 1;
				  end
            else if (sp_dp == 1'b1) begin
              sp_reg <= data[31:16];
              dp_reg <= data[15:0];
				  wr_en <= 1;
            end else if (prot == 1'b1) begin
              protl_reg <= data[7:0];
				   wr_en <= 1;
				  end
            else if (eoh == 1'b1)
              begin
                state <= IDLE;
                valid <= 1'b1;
              end
          default:
				begin
				state <= IDLE;
				wr_en <= 0;
            $display("endcase in Consumer");
				end
        endcase
      end
  end // always @(posedge clk)
  assign odata = {protl_reg, sa_reg, da_reg, sp_reg, dp_reg};
endmodule

