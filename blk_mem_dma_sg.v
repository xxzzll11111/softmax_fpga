`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/29 21:10:26
// Design Name: 
// Module Name: blk_mem_dma_sg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module blk_mem_dma_sg(
    output wire rsta_busy,
    output wire rstb_busy,
    input wire s_aclk,
    input wire s_aresetn,
    input wire [3 : 0] s_axi_awid,
    input wire [31 : 0] s_axi_awaddr,
    input wire [7 : 0] s_axi_awlen,
    input wire [2 : 0] s_axi_awsize,
    input wire [1 : 0] s_axi_awburst,
    input wire s_axi_awvalid,
    output wire s_axi_awready,
    input wire [31 : 0] s_axi_wdata,
    input wire [3 : 0] s_axi_wstrb,
    input wire s_axi_wlast,
    input wire s_axi_wvalid,
    output wire s_axi_wready,
    output wire [3 : 0] s_axi_bid,
    output wire [1 : 0] s_axi_bresp,
    output wire s_axi_bvalid,
    input wire s_axi_bready,
    input wire [3 : 0] s_axi_arid,
    input wire [31 : 0] s_axi_araddr,
    input wire [7 : 0] s_axi_arlen,
    input wire [2 : 0] s_axi_arsize,
    input wire [1 : 0] s_axi_arburst,
    input wire s_axi_arvalid,
    output wire s_axi_arready,
    output wire [3 : 0] s_axi_rid,
    output wire [31 : 0] s_axi_rdata,
    output wire [1 : 0] s_axi_rresp,
    output wire s_axi_rlast,
    output wire s_axi_rvalid,
    input wire s_axi_rready
    );
    
    blk_mem_gen_0 blk_mem (
      .rsta_busy(rsta_busy),          // output wire rsta_busy
      .rstb_busy(rstb_busy),          // output wire rstb_busy
      .s_aclk(s_aclk),                // input wire s_aclk
      .s_aresetn(s_aresetn),          // input wire s_aresetn
      .s_axi_awid(s_axi_awid),        // input wire [3 : 0] s_axi_awid
      .s_axi_awaddr(s_axi_awaddr),    // input wire [31 : 0] s_axi_awaddr
      .s_axi_awlen(s_axi_awlen),      // input wire [7 : 0] s_axi_awlen
      .s_axi_awsize(s_axi_awsize),    // input wire [2 : 0] s_axi_awsize
      .s_axi_awburst(s_axi_awburst),  // input wire [1 : 0] s_axi_awburst
      .s_axi_awvalid(s_axi_awvalid),  // input wire s_axi_awvalid
      .s_axi_awready(s_axi_awready),  // output wire s_axi_awready
      .s_axi_wdata(s_axi_wdata),      // input wire [31 : 0] s_axi_wdata
      .s_axi_wstrb(s_axi_wstrb),      // input wire [3 : 0] s_axi_wstrb
      .s_axi_wlast(s_axi_wlast),      // input wire s_axi_wlast
      .s_axi_wvalid(s_axi_wvalid),    // input wire s_axi_wvalid
      .s_axi_wready(s_axi_wready),    // output wire s_axi_wready
      .s_axi_bid(s_axi_bid),          // output wire [3 : 0] s_axi_bid
      .s_axi_bresp(s_axi_bresp),      // output wire [1 : 0] s_axi_bresp
      .s_axi_bvalid(s_axi_bvalid),    // output wire s_axi_bvalid
      .s_axi_bready(s_axi_bready),    // input wire s_axi_bready
      .s_axi_arid(s_axi_arid),        // input wire [3 : 0] s_axi_arid
      .s_axi_araddr(s_axi_araddr),    // input wire [31 : 0] s_axi_araddr
      .s_axi_arlen(s_axi_arlen),      // input wire [7 : 0] s_axi_arlen
      .s_axi_arsize(s_axi_arsize),    // input wire [2 : 0] s_axi_arsize
      .s_axi_arburst(s_axi_arburst),  // input wire [1 : 0] s_axi_arburst
      .s_axi_arvalid(s_axi_arvalid),  // input wire s_axi_arvalid
      .s_axi_arready(s_axi_arready),  // output wire s_axi_arready
      .s_axi_rid(s_axi_rid),          // output wire [3 : 0] s_axi_rid
      .s_axi_rdata(s_axi_rdata),      // output wire [31 : 0] s_axi_rdata
      .s_axi_rresp(s_axi_rresp),      // output wire [1 : 0] s_axi_rresp
      .s_axi_rlast(s_axi_rlast),      // output wire s_axi_rlast
      .s_axi_rvalid(s_axi_rvalid),    // output wire s_axi_rvalid
      .s_axi_rready(s_axi_rready)    // input wire s_axi_rready
    );
endmodule
