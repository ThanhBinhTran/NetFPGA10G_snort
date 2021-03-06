`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// University:     Ho Chi Minh City University of Technology
// Student:        Chau Tran (K11)
// 
// Create Date:    10:21:13 08/25/2015 
// Design Name:    Packet Decoder (nf10_packet_decoder)
// Module Name:    packet_pre_process 
// Project Name:   DDoS Defender on board NetFPGA10G
// Target Devices: Virtex 5 - vtx240tff1579-2
// Tool versions:  ISE 13.4
// Description:
//    + Storing raw packet in the fifo
//    + Create header packet from the ethernet packet with structure:
//        - [255:158] - Reserve
//        - [157:126] - ACK Number
//        - [125:118] - Flags: CWR, ECE, URG, ACK, PSH, RST, SYN, FIN
//        - [117:102] - Destination Port
//        - [101:86]  - Source Port
//        - [85:54]   - IP des
//        - [53:22]   - IP source
//        - [21:14]   - TTL
//        - [13:10]   - IHL
//        - [9:2]     - Protocol
//        - [1:0]     - ID packet
//     ++ The data in header packet need to be reversed BYTES 
//        and that will be done function CONVERSE_BYTES in the packet_decoder.v
//
// Dependencies: 
//
// Revision: update fifo 
// Revision 0.01 - File Created
// Revision 0.02 - Update Handshake
// Revision 0.03 - Add registers to debug
// Additional Comments: Recommend using XILINX GUI to open file 
//
//////////////////////////////////////////////////////////////////////////////////

module packet_pre_process #(
	parameter DATA_WIDTH    = 256,
	parameter AXI_WIDTH     = 32,
	parameter USER_WIDTH    = 128,
	parameter ID_WIDTH      = 2
	)
	(
	input wire 							            clk,
	input wire 							            rst_n,
	//NIC interface
	input wire [DATA_WIDTH-1:0] 	            pre_fi_nic_data,
	input wire [USER_WIDTH-1:0] 	            pre_fi_nic_user,
	input wire [DATA_WIDTH/8-1:0]             pre_fi_nic_strobe,
	input wire                                pre_fi_nic_valid,
	input wire                                pre_fi_nic_last,
	output reg                                pre_fo_nic_ready,
	//RAW_PACKET_FIFO interface
	input wire                                pre_fi_raw_fifo_almost_full,
	input wire                                pre_fi_raw_fifo_full,
	output reg                                pre_fo_raw_fifo_wr_en,
	output reg [(DATA_WIDTH+ID_WIDTH+DATA_WIDTH/8+USER_WIDTH):0]    pre_fo_raw_fifo_data,
  //HEADER_FIFO interface
   input wire                                pre_fi_header_fifo_almost_full,
   input wire                                pre_fi_header_fifo_full,
	output reg                                pre_fo_header_fifo_wr_en,
	output reg [(DATA_WIDTH-1):0]             pre_fo_header_fifo_data,
	
	
	output reg [255:0] payload_out,
	output reg [31:0]	ips_out,

  //PACKET counter
   output reg                                pkt_in,
   output reg [AXI_WIDTH/2-1 : 0]            byte_in
  );

  //Local parameter
  localparam FF_DLY         = 0;
  localparam BIT            = 3;
  localparam INIT           = 3'b000;
  localparam HEADER_1       = 3'b001;
  localparam HEADER_2       = 3'b010;
  localparam DATA           = 3'b011;
  localparam MAX_DEPTH_BITS = 10;

  localparam ENABLE         = 1'b1;
  localparam DISABLE        = 1'b0;
	
  localparam LENGTH_WIDTH  = 16;
  localparam TTL_WIDTH     = 8;
  localparam IP_WIDTH      = 32;

  localparam ZERO          = {(DATA_WIDTH+ID_WIDTH){1'b0}};

	//Internal variables
  reg [BIT-1:0]             		  state;
  reg [BIT-1:0]             		  next_state;
  reg [(DATA_WIDTH+ID_WIDTH+DATA_WIDTH/8 + USER_WIDTH):0] next_fifo_data;
  reg [(DATA_WIDTH-1):0]      	  next_header_fifo_data;
  reg                       		  next_header_fifo_wr_en;
  reg                       		  next_fifo_wr_en;
  
  
  reg [255:0] payload;
  reg [31:0] ips;
  
  reg [ID_WIDTH-1:0]               id;
  reg [ID_WIDTH-1:0]               next_id;

  wire                        	  transmit_valid;
  wire [DATA_WIDTH-1:0]            data;
  
  reg                              next_pkt_in;
  reg [AXI_WIDTH/2-1 : 0]          next_byte_in;

  assign transmit_valid = pre_fi_nic_valid && pre_fo_nic_ready && !(state == HEADER_1 && pre_fi_nic_last);
  
  //Get data from NIC
  assign data = data_out(pre_fi_nic_data, pre_fi_nic_strobe);
	
	//State control logic
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
	   state   <= #FF_DLY HEADER_1; 
		pkt_in  <= #FF_DLY DISABLE;
      byte_in <= #FF_DLY {(AXI_WIDTH/2){1'b0}}; 	
	 end
    else begin 
	   state   <= #FF_DLY next_state; 
		pkt_in  <= #FF_DLY next_pkt_in;
      byte_in <= #FF_DLY next_byte_in; 
	 end
  end
  
  always @(*) begin
    pre_fo_nic_ready = DISABLE;
    next_state = state;
	 next_pkt_in  = DISABLE;
	 next_byte_in = {(AXI_WIDTH/2){1'b0}};
    case (state)
      HEADER_1: begin
		  if(!pre_fi_raw_fifo_almost_full) begin
		    pre_fo_nic_ready = ENABLE;
          if(pre_fi_nic_valid) begin 
			   if(!pre_fi_nic_last) begin next_state = HEADER_2; end
			  next_pkt_in  = ENABLE;
			  next_byte_in = pre_fi_nic_user[15:0];
			 end
		  end
      end
      HEADER_2: begin
		  if(!pre_fi_raw_fifo_almost_full && !pre_fi_header_fifo_almost_full) begin
		    pre_fo_nic_ready = ENABLE;
          if(pre_fi_nic_valid) begin 
			   if(!pre_fi_nic_last) begin next_state = DATA; end
				else begin next_state = HEADER_1; end
			 end
		  end
      end
      DATA: begin
		  if(!pre_fi_raw_fifo_almost_full) begin
		    pre_fo_nic_ready = ENABLE;
          if(pre_fi_nic_valid && pre_fi_nic_last) begin next_state = HEADER_1; end
		  end
      end
		default: begin 
		  pre_fo_nic_ready = DISABLE;
		  next_state = HEADER_1;
		end
    endcase  
  end

  //Header fifo data
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin  
      pre_fo_header_fifo_data        <= #FF_DLY ZERO; 
      pre_fo_header_fifo_wr_en       <= #FF_DLY DISABLE;
		
		ips_out <= #FF_DLY ZERO;
		payload_out <= #FF_DLY ZERO;
		
		
    end
    else begin 
      pre_fo_header_fifo_data        <= #FF_DLY next_header_fifo_data;
      pre_fo_header_fifo_wr_en       <= #FF_DLY next_header_fifo_wr_en;
		
		ips_out <= #FF_DLY ips;
		payload_out <= #FF_DLY payload;
		
		
    end
  end

  always @(*) begin
    if(state == HEADER_1) begin
        next_header_fifo_data  = {{(170){1'b0}},         //[255:86] Zero
									       {(IP_WIDTH/2){1'b0}}, 	//[85:70]  Half IP destination - 16 bits zero
									       data[255:240], 	      //[69:54]  Half IP destination - 16 bits
											 data[239:208],	      //[53:22]  IP source           - 32 bits
											 data[183:176],	      //[21:14]  TTL                 - 8 bits
											 data[119:116],	      //[13:10]  IHL                 - 4 bits
											 data[191:184],			//[9:2]    Protocol            - 8 bits
											 id						   //[1:0]    ID packet           - 2 bits
									      };
        next_header_fifo_wr_en = DISABLE;
		  
		  ips = data[239:208];
		  payload = ZERO;
		  
		  
		  
		  
		  
		  
    end
    else if(state == HEADER_2) begin
	 
			payload[79:0] = data[255:176];
			
	     if(pre_fo_header_fifo_data[13:10] != 4'b0000         //If IHL > 5 (need to reverse first)
		       && pre_fo_header_fifo_data[13:10] != 4'b1000
		       && pre_fo_header_fifo_data[13:10] != 4'b0100
		       && pre_fo_header_fifo_data[13:10] != 4'b1100
		       && pre_fo_header_fifo_data[13:10] != 4'b0010 ) begin
          next_header_fifo_data  = pre_fo_header_fifo_data | 
		                             {{(98){1'b0}},                   // Reserve
											   data[143:112],                  // Acknowledgment number
										      data[159:152],                  // Flag: CWR, ECE, URG, ACK, PSH, RST, SYN, FIN
										      data[79:64],                    // Destination Port
										      data[63:48],                    // Source Port
										      data[15:0],                     // Half IP dest
												{(70){1'b0}}};                  // ID, Protocol, IHL, TTL, IP source, half IP des
		  end
		  else begin
		  
		  
		  
		    next_header_fifo_data  = pre_fo_header_fifo_data | 
		                             {{(98){1'b0}},                   // Reserve
											   data[111:80],                   // Acknowledgment number
										      data[127:120],                  // Flag: CWR, ECE, URG, ACK, PSH, RST, SYN, FIN
										      data[47:32],                    // Destination Port
										      data[31:16],                    // Source Port
										      data[15:0],                     // Half IP dest
												{(70){1'b0}}};                  // ID, Protocol, IHL, TTL, IP source, half IP des
		  end
		  if(transmit_valid) begin next_header_fifo_wr_en = ENABLE; end
		  else begin next_header_fifo_wr_en = DISABLE; end
    end 
    else begin
	 
			payload = {data[175:0],payload_out[79:0]};
		
        next_header_fifo_data  = ZERO;
        next_header_fifo_wr_en = DISABLE;
    end
  end

  //Fifo control data and logic
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
      pre_fo_raw_fifo_data  <= #FF_DLY ZERO;
      pre_fo_raw_fifo_wr_en <= #FF_DLY DISABLE; 
    end
    else       begin 
      pre_fo_raw_fifo_data  <= #FF_DLY next_fifo_data;
      pre_fo_raw_fifo_wr_en <= #FF_DLY next_fifo_wr_en; 
    end
  end

  //Add data to raw fifo
  always @(*) begin 
    if(transmit_valid) begin
      next_fifo_wr_en = ENABLE;
      next_fifo_data  = {pre_fi_nic_last, id, pre_fi_nic_user, pre_fi_nic_strobe, pre_fi_nic_data};
    end
	 else begin 
	   next_fifo_wr_en = DISABLE; 
	   next_fifo_data = {(419){1'b0}};
	 end
  end
  
  //ID controller
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin id <= #FF_DLY 2'b00; end
	 else        begin id <= #FF_DLY next_id; end
  end
  
  always @(*) begin
    next_id = id;
    if(pre_fi_nic_last && pre_fi_nic_valid) begin next_id = id + 2'b01; end
  end

  //Dealing with strobe
  function [DATA_WIDTH+ID_WIDTH-1:0]   data_out;    // Can only use when DATA_WIDTH = 256 bits
    input  [DATA_WIDTH-1:0]   data_in;
    input  [DATA_WIDTH/8-1:0] strobe;
    localparam BITS = 8;
    // Internal variable
    reg    [DATA_WIDTH-1:0]  data_temp;
	 reg    [DATA_WIDTH-1:0]  data_temp1;
    begin
      data_temp = { {(BITS){strobe[31]}}, {(BITS){strobe[30]}}, {(BITS){strobe[29]}}, {(BITS){strobe[28]}},
                    {(BITS){strobe[27]}}, {(BITS){strobe[26]}}, {(BITS){strobe[25]}}, {(BITS){strobe[24]}},
                    {(BITS){strobe[23]}}, {(BITS){strobe[22]}}, {(BITS){strobe[21]}}, {(BITS){strobe[20]}},
                    {(BITS){strobe[19]}}, {(BITS){strobe[18]}}, {(BITS){strobe[17]}}, {(BITS){strobe[16]}},
                    {(BITS){strobe[15]}}, {(BITS){strobe[14]}}, {(BITS){strobe[13]}}, {(BITS){strobe[12]}},
                    {(BITS){strobe[11]}}, {(BITS){strobe[10]}}, {(BITS){strobe[09]}}, {(BITS){strobe[08]}},
                    {(BITS){strobe[07]}}, {(BITS){strobe[06]}}, {(BITS){strobe[05]}}, {(BITS){strobe[04]}},
                    {(BITS){strobe[03]}}, {(BITS){strobe[02]}}, {(BITS){strobe[01]}}, {(BITS){strobe[00]}}
      };
      data_out = data_in & data_temp;
    end
  endfunction
endmodule

