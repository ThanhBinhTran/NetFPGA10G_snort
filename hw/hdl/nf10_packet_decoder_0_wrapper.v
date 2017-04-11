//-----------------------------------------------------------------------------
// nf10_packet_decoder_0_wrapper.v
//-----------------------------------------------------------------------------

module nf10_packet_decoder_0_wrapper
  (
    axi_aclk,
    axi_resetn,
    m_axis_tdata_0,
    m_axis_tstrb_0,
    m_axis_tuser_0,
    m_axis_tvalid_0,
    m_axis_tready_0,
    m_axis_tlast_0,
    m_axis_tdata_1,
    m_axis_tstrb_1,
    m_axis_tuser_1,
    m_axis_tvalid_1,
    m_axis_tready_1,
    m_axis_tlast_1,
    s_axis_tdata_0,
    s_axis_tstrb_0,
    s_axis_tuser_0,
    s_axis_tvalid_0,
    s_axis_tready_0,
    s_axis_tlast_0,
    s_axis_tdata_1,
    s_axis_tstrb_1,
    s_axis_tuser_1,
    s_axis_tvalid_1,
    s_axis_tready_1,
    s_axis_tlast_1,
    S_AXI_AWADDR,
    S_AXI_AWVALID,
    S_AXI_WDATA,
    S_AXI_WSTRB,
    S_AXI_WVALID,
    S_AXI_BREADY,
    S_AXI_ARADDR,
    S_AXI_ARVALID,
    S_AXI_RREADY,
    S_AXI_ARREADY,
    S_AXI_RDATA,
    S_AXI_RRESP,
    S_AXI_RVALID,
    S_AXI_WREADY,
    S_AXI_BRESP,
    S_AXI_BVALID,
    S_AXI_AWREADY
  );
  input axi_aclk;
  input axi_resetn;
  output [255:0] m_axis_tdata_0;
  output [31:0] m_axis_tstrb_0;
  output [127:0] m_axis_tuser_0;
  output m_axis_tvalid_0;
  input m_axis_tready_0;
  output m_axis_tlast_0;
  output [255:0] m_axis_tdata_1;
  output [31:0] m_axis_tstrb_1;
  output [127:0] m_axis_tuser_1;
  output m_axis_tvalid_1;
  input m_axis_tready_1;
  output m_axis_tlast_1;
  input [255:0] s_axis_tdata_0;
  input [31:0] s_axis_tstrb_0;
  input [127:0] s_axis_tuser_0;
  input s_axis_tvalid_0;
  output s_axis_tready_0;
  input s_axis_tlast_0;
  input [255:0] s_axis_tdata_1;
  input [31:0] s_axis_tstrb_1;
  input [127:0] s_axis_tuser_1;
  input s_axis_tvalid_1;
  output s_axis_tready_1;
  input s_axis_tlast_1;
  input [31:0] S_AXI_AWADDR;
  input S_AXI_AWVALID;
  input [31:0] S_AXI_WDATA;
  input [3:0] S_AXI_WSTRB;
  input S_AXI_WVALID;
  input S_AXI_BREADY;
  input [31:0] S_AXI_ARADDR;
  input S_AXI_ARVALID;
  input S_AXI_RREADY;
  output S_AXI_ARREADY;
  output [31:0] S_AXI_RDATA;
  output [1:0] S_AXI_RRESP;
  output S_AXI_RVALID;
  output S_AXI_WREADY;
  output [1:0] S_AXI_BRESP;
  output S_AXI_BVALID;
  output S_AXI_AWREADY;

  nf10_packet_decoder
    #(
      .C_M_AXIS_DATA_WIDTH ( 256 ),
      .C_S_AXIS_DATA_WIDTH ( 256 ),
      .C_M_AXIS_TUSER_WIDTH ( 128 ),
      .C_S_AXIS_TUSER_WIDTH ( 128 ),
      .C_S_AXI_DATA_WIDTH ( 32 ),
      .C_S_AXI_ADDR_WIDTH ( 32 ),
      .C_BASEADDR ( 32'h77600000 ),
      .C_HIGHADDR ( 32'h7760ffff ),
      .C_FAMILY ( "virtex5" ),
      .C_S_AXI_ACLK_FREQ_HZ ( 160000000 )
    )
    nf10_packet_decoder_0 (
      .axi_aclk ( axi_aclk ),
      .axi_resetn ( axi_resetn ),
      .m_axis_tdata_0 ( m_axis_tdata_0 ),
      .m_axis_tstrb_0 ( m_axis_tstrb_0 ),
      .m_axis_tuser_0 ( m_axis_tuser_0 ),
      .m_axis_tvalid_0 ( m_axis_tvalid_0 ),
      .m_axis_tready_0 ( m_axis_tready_0 ),
      .m_axis_tlast_0 ( m_axis_tlast_0 ),
      .m_axis_tdata_1 ( m_axis_tdata_1 ),
      .m_axis_tstrb_1 ( m_axis_tstrb_1 ),
      .m_axis_tuser_1 ( m_axis_tuser_1 ),
      .m_axis_tvalid_1 ( m_axis_tvalid_1 ),
      .m_axis_tready_1 ( m_axis_tready_1 ),
      .m_axis_tlast_1 ( m_axis_tlast_1 ),
      .s_axis_tdata_0 ( s_axis_tdata_0 ),
      .s_axis_tstrb_0 ( s_axis_tstrb_0 ),
      .s_axis_tuser_0 ( s_axis_tuser_0 ),
      .s_axis_tvalid_0 ( s_axis_tvalid_0 ),
      .s_axis_tready_0 ( s_axis_tready_0 ),
      .s_axis_tlast_0 ( s_axis_tlast_0 ),
      .s_axis_tdata_1 ( s_axis_tdata_1 ),
      .s_axis_tstrb_1 ( s_axis_tstrb_1 ),
      .s_axis_tuser_1 ( s_axis_tuser_1 ),
      .s_axis_tvalid_1 ( s_axis_tvalid_1 ),
      .s_axis_tready_1 ( s_axis_tready_1 ),
      .s_axis_tlast_1 ( s_axis_tlast_1 ),
      .S_AXI_AWADDR ( S_AXI_AWADDR ),
      .S_AXI_AWVALID ( S_AXI_AWVALID ),
      .S_AXI_WDATA ( S_AXI_WDATA ),
      .S_AXI_WSTRB ( S_AXI_WSTRB ),
      .S_AXI_WVALID ( S_AXI_WVALID ),
      .S_AXI_BREADY ( S_AXI_BREADY ),
      .S_AXI_ARADDR ( S_AXI_ARADDR ),
      .S_AXI_ARVALID ( S_AXI_ARVALID ),
      .S_AXI_RREADY ( S_AXI_RREADY ),
      .S_AXI_ARREADY ( S_AXI_ARREADY ),
      .S_AXI_RDATA ( S_AXI_RDATA ),
      .S_AXI_RRESP ( S_AXI_RRESP ),
      .S_AXI_RVALID ( S_AXI_RVALID ),
      .S_AXI_WREADY ( S_AXI_WREADY ),
      .S_AXI_BRESP ( S_AXI_BRESP ),
      .S_AXI_BVALID ( S_AXI_BVALID ),
      .S_AXI_AWREADY ( S_AXI_AWREADY )
    );

endmodule

