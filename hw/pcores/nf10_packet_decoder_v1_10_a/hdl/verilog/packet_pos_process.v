`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University:     Ho Chi Minh City University of Technology (HCMUT) 
// Student:        Chau Tran (K11)
// 
// Create Date:    09:59:19 08/28/2015 
// Design Name:    Packet Decoder (nf10_packet_decoder)
// Module Name:    packet_pos_process 
// Project Name:   DDoS Defender on board NetFPGA10G
// Target Devices: Virtex 5 - vtx240tff1759-2
// Tool versions:  ISE 13.4
// Description:    Receive the decision from outside (filters)
//                 Output packet to nic (or any other receivers)
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Revision 0.02 - Update Handshake
// Revision 0.03 - Update register file for debug
// Additional Comments: Recommend using XILINX GUI to open file 
//
//////////////////////////////////////////////////////////////////////////////////
module packet_pos_process #(
     parameter DATA_WIDTH   = 256,
	  parameter AXI_WIDTH    = 32,
	  parameter USER_WIDTH   = 128,
	  parameter ID_WIDTH     = 2
    )
    (
    input wire                     		    	            clk,
    input wire                     				            rst_n,
	 input wire                     				            pos_fi_mode_debug,
	 //Raw packet fifo interface
    input wire  [(DATA_WIDTH+ID_WIDTH+DATA_WIDTH/8+USER_WIDTH):0]   pos_fi_fifo_data,
    input wire  [ID_WIDTH-1:0] 				               pos_fi_packet_id,
	 input wire  [ID_WIDTH-1:0] 				               pos_fi_header_from_filter_id,
	 input wire  [ID_WIDTH-1:0] 				               pos_fi_header_from_pre_id,
    input wire                     	      		         pos_fi_fifo_almost_empty,
    input wire                     	      		         pos_fi_fifo_empty,
	 output wire                    	     			         pos_fo_fifo_rd,
	 //Decision maker interface
    input wire                     	     			         pos_fi_decision,
    input wire                    	     			         pos_fi_decision_valid,
	 output wire                   				            pos_fo_ready,
	 //NIC interface
    input wire                    	    			         pos_fi_nic_ready,
    output reg  [DATA_WIDTH-1:0]         			         pos_fo_nic_data,
	 output reg  [DATA_WIDTH/8-1:0]         	            pos_fo_nic_strobe,
    output reg                     	    			         pos_fo_nic_valid,
	 output reg                     	    			         pos_fo_nic_last,
	 output reg  [USER_WIDTH-1:0]                        	pos_fo_nic_user,
	 // NIC output lookup port
	 input wire [7:0]                                     tuser_drop,
	 input wire [7:0]                                     tuser_nic0,
	 input wire [7:0]                                     tuser_nic1,
	 input wire [7:0]                                     tuser_nic2,
	 input wire [7:0]                                     tuser_nic3,
	 input wire [7:0]                                     tuser_cpu0,
	 input wire [7:0]                                     tuser_cpu1,
	 input wire [7:0]                                     tuser_cpu2,
	 input wire [7:0]                                     tuser_cpu3,
	 //PACKET counter
    output reg                                           pkt_out,
    output reg [AXI_WIDTH/2-1 : 0]                       byte_out,
	 output reg                                           pkt_pass,
    output reg [AXI_WIDTH/2-1 : 0]                       byte_pass,
	 output reg                                           pkt_drop,
    output reg [AXI_WIDTH/2-1 : 0]                       byte_drop
    );

    //Local parameter
    localparam FF_DLY       = 0;
    localparam BITS         = 2;
    localparam WAIT         = 2'b00;
    localparam PASS         = 2'b01;
    localparam DROP         = 2'b10;

    localparam DISABLE      = 1'b0;
    localparam ENABLE       = 1'b1;
    localparam MASK_DATA    = {(DATA_WIDTH){1'b0}};
	 localparam MASK_STROBE  = {(DATA_WIDTH/8){1'b0}};
	 localparam MASK_USER    = {(USER_WIDTH){1'b0}};

    //Internal variables
    reg [BITS-1:0]                   state;
    reg [BITS-1:0]                   next_state;
	 reg                              next_pkt_out;
    reg [AXI_WIDTH/2-1 : 0]          next_byte_out;
	 reg                              next_pkt_pass;
    reg [AXI_WIDTH/2-1 : 0]          next_byte_pass;
	 reg                              next_pkt_drop;
    reg [AXI_WIDTH/2-1 : 0]          next_byte_drop;
    
    assign pos_fo_ready   = (state == WAIT && !pos_fi_fifo_empty) ? ENABLE : DISABLE; //Ready when the fifo is not empty and the pos doesn't work.
	 assign pos_fo_fifo_rd = ((state == PASS && !pos_fi_fifo_empty && pos_fi_nic_ready) 
	                       || (pos_fi_mode_debug && state == DROP && !pos_fi_fifo_empty && pos_fi_nic_ready)
								  || (!pos_fi_mode_debug && state == DROP && !pos_fi_fifo_empty)) 
									  ? ENABLE : DISABLE;

    //State control logic
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin 
		  state     <= #FF_DLY WAIT;
		  pkt_out   <= #FF_DLY DISABLE;
		  byte_out  <= #FF_DLY {(AXI_WIDTH/2){1'b0}};
		  pkt_pass  <= #FF_DLY DISABLE;
		  byte_pass <= #FF_DLY {(AXI_WIDTH/2){1'b0}};
		  pkt_drop  <= #FF_DLY DISABLE;
		  byte_drop <= #FF_DLY {(AXI_WIDTH/2){1'b0}};
		end
      else begin 
		  state     <= #FF_DLY next_state; 
		  pkt_out   <= #FF_DLY next_pkt_out;
		  byte_out  <= #FF_DLY next_byte_out;
		  pkt_pass   <= #FF_DLY next_pkt_pass;
		  byte_pass  <= #FF_DLY next_byte_pass;
		  pkt_drop   <= #FF_DLY next_pkt_drop;
		  byte_drop  <= #FF_DLY next_byte_drop;
		end		
    end
    always @(*) begin
	   next_state     = state;
	   next_pkt_out   = DISABLE;
		next_byte_out  = {(AXI_WIDTH/2){1'b0}};
		next_pkt_pass  = DISABLE;
		next_byte_pass = {(AXI_WIDTH/2){1'b0}};
		next_pkt_drop  = DISABLE;
		next_byte_drop = {(AXI_WIDTH/2){1'b0}};
      case (state)
        WAIT: begin
          if(!pos_fi_fifo_empty && pos_fi_decision_valid) begin
				next_pkt_out     = ENABLE;
				next_byte_out    = pos_fi_fifo_data[303:288];
            if(pos_fi_decision)   begin 
				  next_state     = DROP; 
				  next_pkt_drop  = ENABLE;
				  next_byte_drop = pos_fi_fifo_data[303:288];
				end
            else begin 
				  next_state = PASS; 
				  next_pkt_pass  = ENABLE;
				  next_byte_pass = pos_fi_fifo_data[303:288];
				end
          end
        end
        PASS: begin if (pos_fi_fifo_data[418] == 1'b1 && pos_fo_fifo_rd) next_state = WAIT; end
        DROP: begin if (pos_fi_fifo_data[418] == 1'b1 && pos_fo_fifo_rd) next_state = WAIT; end
        default: begin next_state = WAIT; end
      endcase
    end
    
    //NIC interface
	 always @(*) begin
	   if(!rst_n) begin 
	     pos_fo_nic_data   = MASK_DATA;
	  	  pos_fo_nic_strobe = MASK_STROBE;
		  pos_fo_nic_valid  = DISABLE;
		  pos_fo_nic_last   = DISABLE;
        pos_fo_nic_user   = MASK_USER;
		end
		else begin
		  if(state == PASS) begin
			 pos_fo_nic_data   = pos_fi_fifo_data[255:0];
          pos_fo_nic_strobe = pos_fi_fifo_data[287:256];
			 if(!pos_fi_fifo_empty) begin pos_fo_nic_valid  = ENABLE; end
          pos_fo_nic_last   = pos_fi_fifo_data[418];
			 case (pos_fi_fifo_data[311:304])
			   8'h01: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_nic0, pos_fi_fifo_data[311:288]}; end
			   8'h04: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_nic1, pos_fi_fifo_data[311:288]}; end
			   8'h10: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_nic2, pos_fi_fifo_data[311:288]}; end
				8'h40: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_nic3, pos_fi_fifo_data[311:288]}; end
			   
			   8'h02: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_cpu0, pos_fi_fifo_data[311:288]}; end
			   8'h08: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_cpu1, pos_fi_fifo_data[311:288]}; end
				8'h20: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_cpu2, pos_fi_fifo_data[311:288]}; end
				8'h80: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], tuser_cpu3, pos_fi_fifo_data[311:288]}; end
				
				default: begin pos_fo_nic_user = {pos_fi_fifo_data[415:321], 8'h20, pos_fi_fifo_data[311:288]}; end
			 endcase
		  end
		  else if(state == DROP) begin
		              if(pos_fi_mode_debug) begin
			             pos_fo_nic_data   = pos_fi_fifo_data[255:0];
                      pos_fo_nic_strobe = pos_fi_fifo_data[287:256];
                      if(!pos_fi_fifo_empty) begin pos_fo_nic_valid  = ENABLE; end
                      pos_fo_nic_last   = pos_fi_fifo_data[418];
			             pos_fo_nic_user   = {pos_fi_fifo_data[415:321], 8'h80, pos_fi_fifo_data[311:288]};
			           end
			       else begin
			         pos_fo_nic_data   = pos_fi_fifo_data[255:0];
                  pos_fo_nic_strobe = pos_fi_fifo_data[287:256];
                  pos_fo_nic_valid  = DISABLE;
                  pos_fo_nic_last   = pos_fi_fifo_data[418];
			         pos_fo_nic_user   = {pos_fi_fifo_data[415:321], 8'h20, pos_fi_fifo_data[311:288]};
			       end
		       end
		  else begin
		    pos_fo_nic_data   = MASK_DATA;
	  	    pos_fo_nic_strobe = MASK_STROBE;
		    pos_fo_nic_valid  = DISABLE;
		    pos_fo_nic_last   = DISABLE;
          pos_fo_nic_user   = MASK_USER;
		  end
		end
	 end
endmodule
