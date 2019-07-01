`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/28 21:10:07
// Design Name: 
// Module Name: pass_through
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


module pass_through(
(* DONT_TOUCH = "TRUE" *)input [127:0]       s_axis_mm2s_tdata           ,
(* DONT_TOUCH = "TRUE" *)input 			    s_axis_mm2s_tvalid 	  		,
(* DONT_TOUCH = "TRUE" *)input 			    s_axis_mm2s_tlast        ,
(* DONT_TOUCH = "TRUE" *)output 		    s_axis_mm2s_tready 	  		,
(* DONT_TOUCH = "TRUE" *)output reg [127:0]  m_axis_s2mm_tdata           ,
(* DONT_TOUCH = "TRUE" *)output reg		    m_axis_s2mm_tvalid 	  		,
(* DONT_TOUCH = "TRUE" *)output reg		    m_axis_s2mm_tlast 	  		,
(* DONT_TOUCH = "TRUE" *)input 		        m_axis_s2mm_tready 	  		,


input clk,
input rstn
    );
    
    assign s_axis_mm2s_tready = m_axis_s2mm_tready;
    
    always@(posedge clk)	
    begin
        if (!rstn)  m_axis_s2mm_tdata <= 0;
        else        m_axis_s2mm_tdata <= s_axis_mm2s_tdata;
    end 
    
    always@(posedge clk)	
    begin
        if (!rstn)  m_axis_s2mm_tvalid <= 0;
        else        m_axis_s2mm_tvalid <= s_axis_mm2s_tvalid;
    end 
    
    always@(posedge clk)	
    begin
        if (!rstn)  m_axis_s2mm_tlast <= 0;
        else        m_axis_s2mm_tlast <= s_axis_mm2s_tlast;
    end  
    
endmodule
