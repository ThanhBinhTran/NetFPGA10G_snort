`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// University:     Ho Chi Minh City University of Technology
// Student:        Chau Tran (K11)
//
// Create Date:    16:58:45 08/22/2015
// Design Name:    Packet Decoder (nf10_packet_decoder)
// Module Name:    packet_decoder
// Project Name:   DDoS Defender on board NetFPGA10G
// Target Devices: Virtex 5 - vtx240tff1579-2
// Tool versions:  ISE 13.4
// Description:
//   + Top module
//   + CONVERSE_BYTES function to reorder the header
//
// Dependencies:
//
// Revision:
//   + Revision 1.00 - File Created
//   + Revision 1.10 - Update registers for debugging
//
// Additional Comments:
//   + 1/9 : Update handshake process
//   + 3/9 : Complete top module
//   + 12/9: Add AXI interfaces
//////////////////////////////////////////////////////////////////////////////////
//`define DEBUG
`define CONVERSE_BYTE

`uselib lib=unisims_ver
`uselib lib=proc_common_v3_00_a
`uselib lib=nf10_proc_common_v1_00_a

module nf10_packet_decoder #(
    parameter C_FAMILY              = "virtex5",
    parameter C_S_AXI_DATA_WIDTH    = 32,
    parameter C_S_AXI_ADDR_WIDTH    = 32,
    parameter C_USE_WSTRB           = 0,
    parameter C_DPHASE_TIMEOUT      = 0,
    parameter C_BASEADDR            = 32'hFFFFFFFF,
    parameter C_HIGHADDR            = 32'h00000000,
    parameter C_S_AXI_ACLK_FREQ_HZ  = 100,
    parameter C_M_AXIS_DATA_WIDTH	= 256,
    parameter C_S_AXIS_DATA_WIDTH	= 256,
    parameter C_M_AXIS_TUSER_WIDTH  = 128,
    parameter C_S_AXIS_TUSER_WIDTH  = 128,
	 parameter ID_WIDTH              = 2
  )
  (
	  // Misc
    input wire                                    axi_resetn,
    input wire                                    axi_aclk,

    // Slave Stream Port (Decoder is a slave and NIC is a master)
    input  wire [C_S_AXIS_DATA_WIDTH-1:0]         s_axis_tdata_0,
    input  wire [(C_S_AXIS_DATA_WIDTH/8)-1:0]     s_axis_tstrb_0,
    input  wire [C_S_AXIS_TUSER_WIDTH-1:0]        s_axis_tuser_0,
    input  wire                                   s_axis_tvalid_0,
    input  wire                                   s_axis_tlast_0,
    output wire                                   s_axis_tready_0,

    // Master Stream Port (Decoder is a master and filter is a slave)
    output reg[C_M_AXIS_DATA_WIDTH-1:0]           m_axis_tdata_0,
    output reg [(C_M_AXIS_DATA_WIDTH/8)-1:0]      m_axis_tstrb_0,
    output reg [C_M_AXIS_TUSER_WIDTH-1:0]         m_axis_tuser_0,
    output reg                                    m_axis_tvalid_0,
    output reg                                    m_axis_tlast_0,
    input  wire                                   m_axis_tready_0,

    // Slave Stream Port (Decoder is a slave and filter is a master)
    input  wire [C_S_AXIS_DATA_WIDTH-1:0]         s_axis_tdata_1,
    input  wire [(C_S_AXIS_DATA_WIDTH/8)-1:0]     s_axis_tstrb_1,
    input  wire [C_S_AXIS_TUSER_WIDTH-1:0]        s_axis_tuser_1,
    input  wire                                   s_axis_tvalid_1,
    input  wire                                   s_axis_tlast_1,
    output wire                                   s_axis_tready_1,

    // Master Stream Port (Decoder is a master and NIC is a slave)
    output wire [C_M_AXIS_DATA_WIDTH-1:0]         m_axis_tdata_1,
    output wire [C_M_AXIS_DATA_WIDTH/8-1:0]       m_axis_tstrb_1,
    output wire [C_M_AXIS_TUSER_WIDTH-1:0]        m_axis_tuser_1,
    output wire                                   m_axis_tlast_1,
    output wire                                   m_axis_tvalid_1,
    input  wire                                   m_axis_tready_1,

    // Slave AXI Ports
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]         S_AXI_AWADDR,
    input                                         S_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]         S_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]       S_AXI_WSTRB,
    input                                         S_AXI_WVALID,
    input                                         S_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]         S_AXI_ARADDR,
    input                                         S_AXI_ARVALID,
    input                                         S_AXI_RREADY,
    output                                        S_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]         S_AXI_RDATA,
    output     [1 : 0]                            S_AXI_RRESP,
    output                                        S_AXI_RVALID,
    output                                        S_AXI_WREADY,
    output     [1 :0]                             S_AXI_BRESP,
    output                                        S_AXI_BVALID,
    output                                        S_AXI_AWREADY
  );

  //local parameter
  localparam FF_DLY            = 0;
  localparam BIT               = 3;

  localparam ENABLE            = 1'b1;
  localparam DISABLE           = 1'b0;

  localparam NUM_RW_REGS       = 4;
  localparam NUM_RO_REGS       = 32 ;

  // Internal variables
  // Raw fifo interface
  wire [C_S_AXIS_DATA_WIDTH+ID_WIDTH+C_S_AXIS_DATA_WIDTH/8+C_S_AXIS_TUSER_WIDTH:0]      raw_fifo_data_in;
  wire [C_S_AXIS_DATA_WIDTH+ID_WIDTH+C_S_AXIS_DATA_WIDTH/8+C_S_AXIS_TUSER_WIDTH:0]      raw_fifo_data_out;
  wire                                            raw_fifo_write_en;
  wire                                            raw_fifo_read_en;
  wire                                            raw_fifo_full;
  wire                                            raw_fifo_almost_full;
  wire                                            raw_fifo_empty;
  wire                                            raw_fifo_almost_empty;

  // Header fifo interface
  wire [C_S_AXIS_DATA_WIDTH-1:0]                  header_fifo_data_in;
  wire [C_S_AXIS_DATA_WIDTH-1:0]                  header_fifo_data_out;
  wire                                            header_fifo_write_en;
  reg                                             header_fifo_read_en;
  wire                                            header_fifo_full;
  wire                                            header_fifo_almost_full;
  wire                                            header_fifo_empty;
  wire                                            header_fifo_alsmot_empty;

  // Temperature register for header data
  wire [C_S_AXIS_DATA_WIDTH-1:0]                  reg_filter_data;

  // AXI signal
  wire                                            Bus2IP_Clk;
  wire                                            Bus2IP_Resetn;
  wire     [C_S_AXI_ADDR_WIDTH-1 : 0]             Bus2IP_Addr;
  wire     [0:0]                                  Bus2IP_CS;
  wire                                            Bus2IP_RNW;
  wire     [C_S_AXI_DATA_WIDTH-1 : 0]             Bus2IP_Data;
  wire     [C_S_AXI_DATA_WIDTH/8-1 : 0]           Bus2IP_BE;
  wire     [C_S_AXI_DATA_WIDTH-1 : 0]             IP2Bus_Data;
  wire                                            IP2Bus_RdAck;
  wire                                            IP2Bus_WrAck;
  wire                                            IP2Bus_Error;

  wire                                            pkt_in;
  reg  [C_S_AXI_DATA_WIDTH-1 : 0]                 pkt_in_cntr;
  wire                                            pkt_out;
  reg  [C_S_AXI_DATA_WIDTH-1 : 0]                 pkt_out_cntr;
  wire                                            pkt_pass;
  reg  [C_S_AXI_DATA_WIDTH-1 : 0]                 pkt_pass_cntr;
  wire                                            pkt_drop;
  reg  [C_S_AXI_DATA_WIDTH-1 : 0]                 pkt_drop_cntr;

  wire  [C_S_AXI_DATA_WIDTH/2-1 : 0]              byte_in;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_in_cntr;

  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_in_nf0_cntr;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_in_nf1_cntr;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_in_nf2_cntr;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_in_nf3_cntr;

  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_out_nf0_cntr;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_out_nf1_cntr;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_out_nf2_cntr;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_out_nf3_cntr;

  reg  [31                     : 0]               interval_counter;             //for calculating through-put in 100 msec

	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf0_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf1_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf2_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf3_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf0_stat_temp   ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf1_stat_temp   ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf2_stat_temp   ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_in_nf3_stat_temp   ;

	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf0_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf1_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf2_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf3_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf0_stat_temp  ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf1_stat_temp  ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf2_stat_temp  ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_out_nf3_stat_temp  ;

	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf0_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf1_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf2_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf3_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf0_stat_temp ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf1_stat_temp ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf2_stat_temp ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] byte_drop_nf3_stat_temp ;

	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf0_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf1_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf2_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf3_stat        ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf0_stat_temp   ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf1_stat_temp   ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf2_stat_temp   ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_in_nf3_stat_temp   ;

	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf0_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf1_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf2_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf3_stat       ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf0_stat_temp  ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf1_stat_temp  ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf2_stat_temp  ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_out_nf3_stat_temp  ;

	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf0_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf1_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf2_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf3_stat      ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf0_stat_temp ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf1_stat_temp ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf2_stat_temp ;
	reg  [C_S_AXI_DATA_WIDTH-1   : 0] pkt_drop_nf3_stat_temp ;

  wire  [C_S_AXI_DATA_WIDTH/2-1 : 0]              byte_out;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_out_cntr;
  wire  [C_S_AXI_DATA_WIDTH/2-1 : 0]              byte_pass;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_pass_cntr;
  wire  [C_S_AXI_DATA_WIDTH/2-1 : 0]              byte_drop;
  reg  [C_S_AXI_DATA_WIDTH-1   : 0]               byte_drop_cntr;
  
  
  wire [31:0] ips_done;
  wire [255:0] payload_done;
  

  wire [NUM_RW_REGS*C_S_AXI_DATA_WIDTH-1 : 0]     rw_regs;
  wire [NUM_RO_REGS*C_S_AXI_DATA_WIDTH-1 : 0]     ro_regs;
  wire			                                   rst_cntrs;
  wire			                                   mod_cntrs;
  wire			                                   tuser_cntrs; //0: default config; 1: manual config
  wire [7:0]                                      tuser_drop;  //Set output port for DROP packet
  wire [7:0]                                      tuser_nic0;  //Set output port for input NIC0
  wire [7:0]                                      tuser_nic1;  //Set output port for input NIC1
  wire [7:0]                                      tuser_nic2;  //Set output port for input NIC2
  wire [7:0]                                      tuser_nic3;  //Set output port for input NIC3
  wire [7:0]                                      tuser_cpu0;  //Set output port for input CPU0
  wire [7:0]                                      tuser_cpu1;  //Set output port for input CPU1
  wire [7:0]                                      tuser_cpu2;  //Set output port for input CPU2
  wire [7:0]                                      tuser_cpu3;  //Set output port for input CPU3

  // -- Register assignments
  assign rst_cntrs   = rw_regs[0];
  assign mod_cntrs   = rw_regs[32];
  assign tuser_cntrs = rw_regs[33];
  assign tuser_drop  = (mod_cntrs)   ? ((tuser_cntrs) ? rw_regs[41:34] : 8'h80) : 8'h00;
  assign tuser_nic0  = (tuser_cntrs) ? rw_regs[71:64]   : 8'h04;
  assign tuser_nic1  = (tuser_cntrs) ? rw_regs[79:72]   : 8'h01;
  assign tuser_nic2  = (tuser_cntrs) ? rw_regs[87:80]   : 8'h40;
  assign tuser_nic3  = (tuser_cntrs) ? rw_regs[95:88]   : 8'h10;
  assign tuser_cpu0  = (tuser_cntrs) ? rw_regs[103:96]  : 8'h08;
  assign tuser_cpu1  = (tuser_cntrs) ? rw_regs[111:104] : 8'h02;
  assign tuser_cpu2  = (tuser_cntrs) ? rw_regs[119:112] : 8'h80;
  assign tuser_cpu3  = (tuser_cntrs) ? rw_regs[127:120] : 8'h20;

  //note: edit NUM_RO_REGS if you want to add more reg into ro_regs
  assign ro_regs   = {
						pkt_pass_cntr,
						pkt_drop_cntr,
						pkt_in_cntr,
						pkt_out_cntr,

						byte_pass_cntr,
						byte_drop_cntr,
						byte_in_cntr,
						byte_out_cntr,		
						
						 byte_in_nf0_stat        , //6c
						 byte_in_nf1_stat        , //68
						 byte_in_nf2_stat        , //64
						 byte_in_nf3_stat        , //60

						 byte_out_nf0_stat       , //5c
						 byte_out_nf1_stat       , //58
						 byte_out_nf2_stat       , //54
						 byte_out_nf3_stat       , //50

						 byte_drop_nf0_stat      , //4c
						 byte_drop_nf1_stat      , //48
						 byte_drop_nf2_stat      , //44
						 byte_drop_nf3_stat      , //40

						 pkt_in_nf0_stat        , //3c
						 pkt_in_nf1_stat        , //38
						 pkt_in_nf2_stat        , //34
						 pkt_in_nf3_stat        , //30

						 pkt_out_nf0_stat       , //2c
						 pkt_out_nf1_stat       , //28
						 pkt_out_nf2_stat       , //24
						 pkt_out_nf3_stat       , //20


						 pkt_drop_nf0_stat      , //1c
						 pkt_drop_nf1_stat      , //18
						 pkt_drop_nf2_stat      , //14
						 pkt_drop_nf3_stat        //10
			};

  // -- AXILITE IPIF
  axi_lite_ipif_1bar #
  (
      .C_S_AXI_DATA_WIDTH (C_S_AXI_DATA_WIDTH),
      .C_S_AXI_ADDR_WIDTH (C_S_AXI_ADDR_WIDTH),
      .C_USE_WSTRB        (C_USE_WSTRB),
      .C_DPHASE_TIMEOUT   (C_DPHASE_TIMEOUT),
      .C_BAR0_BASEADDR    (C_BASEADDR),
      .C_BAR0_HIGHADDR    (C_HIGHADDR)
  ) axi_lite_ipif_inst
  (
      .S_AXI_ACLK          ( axi_aclk       ),
      .S_AXI_ARESETN       ( axi_resetn     ),
      .S_AXI_AWADDR        ( S_AXI_AWADDR   ),
      .S_AXI_AWVALID       ( S_AXI_AWVALID  ),
      .S_AXI_WDATA         ( S_AXI_WDATA    ),
      .S_AXI_WSTRB         ( S_AXI_WSTRB    ),
      .S_AXI_WVALID        ( S_AXI_WVALID   ),
      .S_AXI_BREADY        ( S_AXI_BREADY   ),
      .S_AXI_ARADDR        ( S_AXI_ARADDR   ),
      .S_AXI_ARVALID       ( S_AXI_ARVALID  ),
      .S_AXI_RREADY        ( S_AXI_RREADY   ),
      .S_AXI_ARREADY       ( S_AXI_ARREADY  ),
      .S_AXI_RDATA         ( S_AXI_RDATA    ),
      .S_AXI_RRESP         ( S_AXI_RRESP    ),
      .S_AXI_RVALID        ( S_AXI_RVALID   ),
      .S_AXI_WREADY        ( S_AXI_WREADY   ),
      .S_AXI_BRESP         ( S_AXI_BRESP    ),
      .S_AXI_BVALID        ( S_AXI_BVALID   ),
      .S_AXI_AWREADY       ( S_AXI_AWREADY  ),

      // Controls to the IP/IPIF modules
      .Bus2IP_Clk          ( Bus2IP_Clk     ),
      .Bus2IP_Resetn       ( Bus2IP_Resetn  ),
      .Bus2IP_Addr         ( Bus2IP_Addr    ),
      .Bus2IP_RNW          ( Bus2IP_RNW     ),
      .Bus2IP_BE           ( Bus2IP_BE      ),
      .Bus2IP_CS           ( Bus2IP_CS      ),
      .Bus2IP_Data         ( Bus2IP_Data    ),
      .IP2Bus_Data         ( IP2Bus_Data    ),
      .IP2Bus_WrAck        ( IP2Bus_WrAck   ),
      .IP2Bus_RdAck        ( IP2Bus_RdAck   ),
      .IP2Bus_Error        ( IP2Bus_Error   )
      );

  // -- IPIF REGS
  ipif_regs #
  (
      .C_S_AXI_DATA_WIDTH (C_S_AXI_DATA_WIDTH),
      .C_S_AXI_ADDR_WIDTH (C_S_AXI_ADDR_WIDTH),
      .NUM_RW_REGS        (NUM_RW_REGS),
      .NUM_RO_REGS        (NUM_RO_REGS)
  ) ipif_regs_inst
  (
      .Bus2IP_Clk     ( Bus2IP_Clk     ),
      .Bus2IP_Resetn  ( Bus2IP_Resetn  ),
      .Bus2IP_Addr    ( Bus2IP_Addr    ),
      .Bus2IP_CS      ( Bus2IP_CS[0]   ),
      .Bus2IP_RNW     ( Bus2IP_RNW     ),
      .Bus2IP_Data    ( Bus2IP_Data    ),
      .Bus2IP_BE      ( Bus2IP_BE      ),
      .IP2Bus_Data    ( IP2Bus_Data    ),
      .IP2Bus_RdAck   ( IP2Bus_RdAck   ),
      .IP2Bus_WrAck   ( IP2Bus_WrAck   ),
      .IP2Bus_Error   ( IP2Bus_Error   ),

      .rw_regs        ( rw_regs ),
      .ro_regs        ( ro_regs )
  );

  //Packet Pre Process
  packet_pre_process #(
      .DATA_WIDTH(C_S_AXIS_DATA_WIDTH),
      .ID_WIDTH(ID_WIDTH)
  )
  pre_v0(
      .clk(axi_aclk),
      .rst_n(axi_resetn),
      //NIC interface
      .pre_fi_nic_data(s_axis_tdata_0),
      .pre_fi_nic_user(s_axis_tuser_0),
      .pre_fi_nic_strobe(s_axis_tstrb_0),
      .pre_fi_nic_valid(s_axis_tvalid_0),
      .pre_fi_nic_last(s_axis_tlast_0),
      .pre_fo_nic_ready(s_axis_tready_0),
      //RAW_PACKET_FIFO interface
      .pre_fi_raw_fifo_almost_full(raw_fifo_almost_full),
      .pre_fi_raw_fifo_full(raw_fifo_full),
      .pre_fo_raw_fifo_wr_en(raw_fifo_write_en),
      .pre_fo_raw_fifo_data(raw_fifo_data_in),
      //HEADER_FIFO interface
      .pre_fi_header_fifo_almost_full(header_fifo_almost_full),
      .pre_fi_header_fifo_full(header_fifo_full),
      .pre_fo_header_fifo_wr_en(header_fifo_write_en),
      .pre_fo_header_fifo_data(reg_filter_data),
		.payload_out(payload_done),
		.ips_out(ips_done),
      //PACKET counter
      .pkt_in(pkt_in),
      .byte_in(byte_in)
   );

  //Fifo module
  fifo raw_fifo_v0 (
      .clk(axi_aclk),
      .rst(~axi_resetn),
      .din(raw_fifo_data_in),
      .wr_en(raw_fifo_write_en),
      .rd_en(raw_fifo_read_en),
      .dout(raw_fifo_data_out),
      .full(raw_fifo_full),
      .almost_full(raw_fifo_almost_full),
      .empty(raw_fifo_empty),
      .almost_empty(raw_fifo_almost_empty)
  );

  //Header fifo module
  fallthrough_small_fifo #(
      .WIDTH(C_S_AXIS_DATA_WIDTH),
      .MAX_DEPTH_BITS(10)
  )
  header_fifo_v0 (
      .din(header_fifo_data_in),     // Data in
      .wr_en(header_fifo_write_en),   // Write enable
      .rd_en(header_fifo_read_en),   // Read the next word
      .dout(header_fifo_data_out),    // Data out
      .full(header_fifo_full),
      .nearly_full(header_fifo_almost_full),
      .prog_full(),
      .empty(header_fifo_empty),
      .reset(~axi_resetn),
      .clk(axi_aclk)
  );
  `ifndef DEBUG
  //Packet Pos Process
  packet_pos_process #(
      .DATA_WIDTH(C_S_AXIS_DATA_WIDTH),
      .ID_WIDTH(ID_WIDTH)
  )
  pos_v0 (
      .clk(axi_aclk),
      .rst_n(axi_resetn),
      .pos_fi_mode_debug(mod_cntrs),
    //Raw packet fifo interface
     .pos_fi_fifo_data(raw_fifo_data_out),
     .pos_fi_packet_id(s_axis_tdata_1[2:1]),
	 .pos_fi_header_from_filter_id(s_axis_tdata_1[4:3]),
	 .pos_fi_header_from_pre_id(s_axis_tdata_1[6:5]),
	 .pos_fi_fifo_empty(raw_fifo_empty),
     .pos_fi_fifo_almost_empty(raw_fifo_almost_empty),
     .pos_fo_fifo_rd(raw_fifo_read_en),
    //Decision maker interface
     .pos_fi_decision(s_axis_tdata_1[0]),
     .pos_fi_decision_valid(s_axis_tvalid_1),
     .pos_fo_ready(s_axis_tready_1),
    //NIC interface
     .pos_fi_nic_ready(m_axis_tready_1),
     .pos_fo_nic_data(m_axis_tdata_1),
	 .pos_fo_nic_strobe(m_axis_tstrb_1),
     .pos_fo_nic_valid(m_axis_tvalid_1),
	 .pos_fo_nic_last(m_axis_tlast_1),
	 .pos_fo_nic_user(m_axis_tuser_1),
	 // Control tuser for output port lookup
	 .tuser_drop(tuser_drop),
	 .tuser_nic0(tuser_nic0),
	 .tuser_nic1(tuser_nic1),
	 .tuser_nic2(tuser_nic2),
	 .tuser_nic3(tuser_nic3),
	 .tuser_cpu0(tuser_cpu0),
	 .tuser_cpu1(tuser_cpu1),
	 .tuser_cpu2(tuser_cpu2),
	 .tuser_cpu3(tuser_cpu3),
	 // Counter debug
	 .pkt_out(pkt_out),
	 .byte_out(byte_out),
	 .pkt_pass(pkt_pass),
	 .byte_pass(byte_pass),
	 .pkt_drop(pkt_drop),
	 .byte_drop(byte_drop)
  );
  `else //loopback debug
    assign m_axis_tdata_1        = raw_fifo_data_out[255:0];
    assign m_axis_tvalid_1       = ~raw_fifo_empty;
    assign m_axis_tstrb_1        = raw_fifo_data_out[287:256];
    assign m_axis_tuser_1[15:0]  = 0;
    assign m_axis_tuser_1[23:16] = 8'h01; //NET0
    assign m_axis_tuser_1[31:24] = 8'h02; //CPU0
    assign m_axis_tuser_1[127:32]= 0;
    assign m_axis_tlast_1        = raw_fifo_data_out[290];
    assign raw_fifo_read_en      = (!raw_fifo_empty && m_axis_tready_1) ? ENABLE : DISABLE;
  `endif

  //Communicate with filter
  always @(*) begin
   m_axis_tvalid_0       = ~header_fifo_empty;
   header_fifo_read_en   = (!header_fifo_empty && m_axis_tready_0) ? ENABLE : DISABLE;
   m_axis_tdata_0        = {{(182){1'b0}},header_fifo_data_out[73:0]};
   m_axis_tlast_0        = 1'b1;
   m_axis_tstrb_0        = {(32){1'b1}};
   m_axis_tuser_0[15:0]  = 0;
   m_axis_tuser_0[23:16] = 8'h01; //NET0
   m_axis_tuser_0[31:24] = 8'h02; //CPU0
   m_axis_tuser_0[127:32]= 0;
  end

  //Packet Counter
  always @ (posedge axi_aclk) begin
      if (~axi_resetn || rst_cntrs) begin
          pkt_in_cntr       <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_in_cntr      <= {C_S_AXI_DATA_WIDTH{1'b0}};
          pkt_out_cntr      <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_out_cntr     <= {C_S_AXI_DATA_WIDTH{1'b0}};
          pkt_drop_cntr     <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_drop_cntr    <= {C_S_AXI_DATA_WIDTH{1'b0}};
          pkt_pass_cntr     <= {C_S_AXI_DATA_WIDTH{1'b0}};

          byte_pass_cntr    <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_in_nf0_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_in_nf1_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_in_nf2_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_in_nf3_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};

          byte_out_nf0_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_out_nf1_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_out_nf2_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};
          byte_out_nf3_cntr  <= {C_S_AXI_DATA_WIDTH{1'b0}};

          interval_counter       <= {32{1'b0}};
      end
      else begin
          if(pkt_in) begin
              pkt_in_cntr    <= pkt_in_cntr + 1;
              byte_in_cntr   <= byte_in_cntr + byte_in;
              /* Binh added for calculating RX through put for nf0,1,2,3 */
              if( s_axis_tuser_0[16]) begin
                  byte_in_nf0_cntr <= byte_in_nf0_cntr + s_axis_tuser_0[15:0];
              end
              if( s_axis_tuser_0[18]) begin
                  byte_in_nf1_cntr <= byte_in_nf1_cntr + s_axis_tuser_0[15:0];
              end
              if( s_axis_tuser_0[20]) begin
                  byte_in_nf2_cntr <= byte_in_nf2_cntr + s_axis_tuser_0[15:0];
              end
              if( s_axis_tuser_0[22]) begin
                  byte_in_nf3_cntr <= byte_in_nf3_cntr + s_axis_tuser_0[15:0];
              end
          end
          if(pkt_out) begin
              pkt_out_cntr   <= pkt_out_cntr + 1;
              byte_out_cntr  <= byte_out_cntr + byte_out;

              /* Binh added for calculating TX through put for nf0,1,2,3 */
              if( m_axis_tuser_1[24]) begin
                  byte_out_nf0_cntr <= byte_out_nf0_cntr + m_axis_tuser_1[15:0];
              end
              if( m_axis_tuser_1[26]) begin
                  byte_out_nf1_cntr <= byte_out_nf1_cntr + m_axis_tuser_1[15:0];
              end
              if( m_axis_tuser_1[28]) begin
                  byte_out_nf2_cntr <= byte_out_nf2_cntr + m_axis_tuser_1[15:0];
              end
              if( m_axis_tuser_1[30]) begin
                  byte_out_nf3_cntr <= byte_out_nf3_cntr + m_axis_tuser_1[15:0];
              end
          end
          if(pkt_pass) begin
              pkt_pass_cntr  <= pkt_pass_cntr + 1;
              byte_pass_cntr <= byte_pass_cntr + byte_pass;
          end
          if(pkt_drop) begin
              pkt_drop_cntr  <= pkt_drop_cntr + 1;
              byte_drop_cntr <= byte_drop_cntr + byte_drop;
          end

        /* Binh added for calculating RX - TX through-put for NF0,1,2,3 FOR 100 msec */
          if(interval_counter == 16_000_000) begin                  // countering 16M times of 160Mhz --> 100 msec
					byte_in_nf0_stat        <= byte_in_nf0_stat_temp;
					byte_in_nf1_stat        <= byte_in_nf1_stat_temp;
					byte_in_nf2_stat        <= byte_in_nf2_stat_temp;
					byte_in_nf3_stat        <= byte_in_nf3_stat_temp;
					byte_in_nf0_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_in_nf1_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_in_nf2_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_in_nf3_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};

					byte_out_nf0_stat       <= byte_out_nf0_stat_temp;
					byte_out_nf1_stat       <= byte_out_nf1_stat_temp;
					byte_out_nf2_stat       <= byte_out_nf2_stat_temp;
					byte_out_nf3_stat       <= byte_out_nf3_stat_temp;
					byte_out_nf0_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_out_nf1_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_out_nf2_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_out_nf3_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};

					byte_drop_nf0_stat       <= byte_drop_nf0_stat_temp;
					byte_drop_nf1_stat       <= byte_drop_nf1_stat_temp;
					byte_drop_nf2_stat       <= byte_drop_nf2_stat_temp;
					byte_drop_nf3_stat       <= byte_drop_nf3_stat_temp;
					byte_drop_nf0_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_drop_nf1_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_drop_nf2_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					byte_drop_nf3_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};

					pkt_in_nf0_stat        <= pkt_in_nf0_stat_temp;
					pkt_in_nf1_stat        <= pkt_in_nf1_stat_temp;
					pkt_in_nf2_stat        <= pkt_in_nf2_stat_temp;
					pkt_in_nf3_stat        <= pkt_in_nf3_stat_temp;
					pkt_in_nf0_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_in_nf1_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_in_nf2_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_in_nf3_stat_temp   <= {C_S_AXI_DATA_WIDTH{1'b0}};

					pkt_out_nf0_stat       <= pkt_out_nf0_stat_temp;
					pkt_out_nf1_stat       <= pkt_out_nf1_stat_temp;
					pkt_out_nf2_stat       <= pkt_out_nf2_stat_temp;
					pkt_out_nf3_stat       <= pkt_out_nf3_stat_temp;
					pkt_out_nf0_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_out_nf1_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_out_nf2_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_out_nf3_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};

					pkt_drop_nf0_stat       <= pkt_drop_nf0_stat_temp;
					pkt_drop_nf1_stat       <= pkt_drop_nf1_stat_temp;
					pkt_drop_nf2_stat       <= pkt_drop_nf2_stat_temp;
					pkt_drop_nf3_stat       <= pkt_drop_nf3_stat_temp;
					pkt_drop_nf0_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_drop_nf1_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_drop_nf2_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};
					pkt_drop_nf3_stat_temp  <= {C_S_AXI_DATA_WIDTH{1'b0}};

				   interval_counter <= 0;
          end
          else begin
              interval_counter    <= interval_counter + 1'b1;
              if(pkt_in) begin
                  if( s_axis_tuser_0[16]) begin
                      byte_in_nf0_stat_temp <= byte_in_nf0_stat_temp + s_axis_tuser_0[15:0];
                      pkt_in_nf0_stat_temp <= pkt_in_nf0_stat_temp + 1'b1;
                  end
                  if( s_axis_tuser_0[18]) begin
                      byte_in_nf1_stat_temp <= byte_in_nf1_stat_temp + s_axis_tuser_0[15:0];
                      pkt_in_nf1_stat_temp <= pkt_in_nf1_stat_temp + 1'b1;
                  end
                  if( s_axis_tuser_0[20]) begin
                      byte_in_nf2_stat_temp <= byte_in_nf2_stat_temp + s_axis_tuser_0[15:0];
                      pkt_in_nf2_stat_temp <= pkt_in_nf2_stat_temp + 1'b1;
                  end
                  if( s_axis_tuser_0[22]) begin
                      byte_in_nf3_stat_temp <= byte_in_nf3_stat_temp + s_axis_tuser_0[15:0];
                      pkt_in_nf3_stat_temp <= pkt_in_nf3_stat_temp + 1'b1;
                  end
              end
              if(pkt_pass) begin
                  if( m_axis_tuser_1[24]) begin
                      byte_out_nf0_stat_temp <= byte_out_nf0_stat_temp + m_axis_tuser_1[15:0];
                      pkt_out_nf0_stat_temp <= pkt_out_nf0_stat_temp + 1'b1;
                  end
                  if( m_axis_tuser_1[26]) begin
                      byte_out_nf1_stat_temp <= byte_out_nf1_stat_temp + m_axis_tuser_1[15:0];
                      pkt_out_nf1_stat_temp <= pkt_out_nf1_stat_temp + 1'b1;
                  end
                  if( m_axis_tuser_1[28]) begin
                      byte_out_nf2_stat_temp <= byte_out_nf2_stat_temp + m_axis_tuser_1[15:0];
                      pkt_out_nf2_stat_temp <= pkt_out_nf2_stat_temp + 1'b1;
                  end
                  if( m_axis_tuser_1[30]) begin
                      byte_out_nf3_stat_temp <= byte_out_nf3_stat_temp + m_axis_tuser_1[15:0];
                      pkt_out_nf3_stat_temp <= pkt_out_nf3_stat_temp + 1'b1;
                  end
              end
              if(pkt_drop) begin
                  if( s_axis_tuser_0[16]) begin
                      byte_drop_nf0_stat_temp <= byte_drop_nf0_stat_temp + s_axis_tuser_0[15:0];
                      pkt_drop_nf0_stat_temp <= pkt_drop_nf0_stat_temp + 1'b1;
                  end
                  if( s_axis_tuser_0[18]) begin
                      byte_drop_nf1_stat_temp <= byte_drop_nf1_stat_temp + s_axis_tuser_0[15:0];
                      pkt_drop_nf1_stat_temp <= pkt_drop_nf1_stat_temp + 1'b1;
                  end
                  if( s_axis_tuser_0[20]) begin
                      byte_drop_nf2_stat_temp <= byte_drop_nf2_stat_temp + s_axis_tuser_0[15:0];
                      pkt_drop_nf2_stat_temp <= pkt_drop_nf2_stat_temp + 1'b1;
                  end
                  if( s_axis_tuser_0[22]) begin
                      byte_drop_nf3_stat_temp <= byte_drop_nf3_stat_temp + s_axis_tuser_0[15:0];   
                      pkt_drop_nf3_stat_temp <= pkt_drop_nf3_stat_temp + 1'b1;
                  end
				end
          end
      end
  end

  `ifdef CONVERSE_BYTE
      genvar k;
      generate
      //ID
      assign header_fifo_data_in[1:0]     = reg_filter_data[1:0];
      //PROTOCOL
      assign header_fifo_data_in[9:2]     = reg_filter_data[9:2];
      //IHL
      assign header_fifo_data_in[13:10]     = reg_filter_data[13:10];
      //TTL
      assign header_fifo_data_in[21:14]     = reg_filter_data[21:14];
      for(k=1;k<=4;k=k+1) begin: IP_SRC_SWAP
          assign header_fifo_data_in[22+8*k-1:22+8*(k-1)] = reg_filter_data[53-8*(k-1):53-8*k+1];
      end //End IP_SRC_SWAP
      for(k=1;k<=4;k=k+1) begin: IP_DES_SWAP
          assign header_fifo_data_in[54+8*k-1:54+8*(k-1)] = reg_filter_data[85-8*(k-1):85-8*k+1];
      end //End IP_DES_SWAP
      for(k=1;k<=2;k=k+1) begin: PORT_SRC_SWAP
          assign header_fifo_data_in[86+8*k-1:86+8*(k-1)] = reg_filter_data[101-8*(k-1):101-8*k+1];
      end //End PORT_SRC_SWAP
      for(k=1;k<=2;k=k+1) begin: PORT_DES_SWAP
          assign header_fifo_data_in[102+8*k-1:102+8*(k-1)] = reg_filter_data[117-8*(k-1):117-8*k+1];
      end //End PORT_DES_SWAP
      //FLAG
      assign header_fifo_data_in[125:118]     = reg_filter_data[125:118];
      for(k=1;k<=4;k=k+1) begin: ACK_NUM_SWAP
          assign header_fifo_data_in[126+8*k-1:126+8*(k-1)]     = reg_filter_data[157-8*(k-1):157-8*k+1];
      end //End ACK_NUM_SWAP
      //Reverse
      assign header_fifo_data_in[255:158] = reg_filter_data[255:158];
      endgenerate
  `else
      assign header_fifo_data_in = reg_filter_data;
  `endif

endmodule

