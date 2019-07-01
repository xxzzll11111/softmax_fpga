`timescale 1ns/1ps
/////////////////////////////////////////////////////////////
// (c) Copyright 2018 NICS. THU. All rights reserved.
// Engineer:	Guangjun Ge
// Email:	geguangjun@126.com	
// 
// Create Data:	2019/1/9
// Module Name:	load_fetch
// Project Name:	
// Target Devices:	
// Tool Version:	Vivado 2017.4
// Descripton:	
// Dependencies:
// Revision:
// Modification History:
// Date by Version Change Description
//=======================================
//
//=======================================
//
/////////////////////////////////////////////////


module load_fetch_l  #(
	parameter HP_WD_BYTE 		= 	4			// the width of input (in bytes) 8, 16		
)
(
// AXI interface
input [HP_WD_BYTE*8-1:0]	m_axis_mm2s_tdata			,
input [HP_WD_BYTE-1:0]		m_axis_mm2s_tkeep 	    	,
input 			m_axis_mm2s_tlast 	    	,
input 			m_axis_mm2s_tvalid 	  		,
output 			m_axis_mm2s_tready 	  		,
output reg		s_axis_mm2s_cmd_tvalid   	,
input 			s_axis_mm2s_cmd_tready   	,
output [71:0]	s_axis_mm2s_cmd_tdata    	,
input 			m_axis_mm2s_sts_tvalid   	,
output 			m_axis_mm2s_sts_tready   	,
input [7:0]		m_axis_mm2s_sts_tdata    	,
input [0:0]		m_axis_mm2s_sts_tkeep    	,
input 			m_axis_mm2s_sts_tlast    	,

//ctrl interface
input  [1:0]		ddr_port_id_i		,
input  [29:0]		ddr_addr_i			,
input  [11:0]		line_size_i			,
input 				start_i				,
input 				triger_i			,

input	[9:0]		bank_id_i			,
input 	[31:0]		addr_image_base_i   ,
input 	[31:0]		addr_weight_base_i  ,
// output data
output reg [HP_WD_BYTE*8-1:0]   load_data_i 	,
output reg			   			load_data_en_i 	,
// system signals
input clk,
input rst
);


wire [31:0] ADDR_BASE = (bank_id_i[9:8]==0)? addr_image_base_i:addr_weight_base_i;

reg [31:0] instr_axi_addr;
always@(posedge clk)	
begin
	if (rst)
		instr_axi_addr <= 0;
	else if (start_i)
		instr_axi_addr <= ddr_addr_i+ADDR_BASE;
	else if (triger_i)
		instr_axi_addr <= instr_axi_addr + line_size_i;
	else
		instr_axi_addr <= instr_axi_addr;
end 

always@(posedge clk)	
begin
	if (rst)
		s_axis_mm2s_cmd_tvalid <= 0;
	else if ((start_i)||(triger_i))
		s_axis_mm2s_cmd_tvalid <= 1;
	else if (s_axis_mm2s_cmd_tready)
		s_axis_mm2s_cmd_tvalid <= 0;
	else
		s_axis_mm2s_cmd_tvalid <= s_axis_mm2s_cmd_tvalid;
end 

assign s_axis_mm2s_cmd_tdata[22:0] = line_size_i;		//BTT: Bytes To Transfer
assign s_axis_mm2s_cmd_tdata[23] = 1;					//type: 1-enable INCR	0- enable FIXED;
assign s_axis_mm2s_cmd_tdata[29:24] = 0;				//DSA: DRE Stream Alignment
assign s_axis_mm2s_cmd_tdata[30] = 1;					//EOF: End Of Frame
assign s_axis_mm2s_cmd_tdata[31] = 1;					//DRR: DRE ReAlignment Request
assign s_axis_mm2s_cmd_tdata[63:32] = instr_axi_addr;	//SADDR: Start Address	
assign s_axis_mm2s_cmd_tdata[67:64] = 0;				//TAG: Command TAG
assign s_axis_mm2s_cmd_tdata[71:68] = 0;				//RSVD: Reserved



assign m_axis_mm2s_tready = 1;
assign m_axis_mm2s_sts_tready = 1;
always@(posedge clk)	
begin
	if (rst) begin
		load_data_i 	<= 0;
		load_data_en_i	<= 0;
	end
	else begin
		load_data_i 	<= m_axis_mm2s_tdata;
		load_data_en_i	<= m_axis_mm2s_tvalid;
	end
end 


endmodule








