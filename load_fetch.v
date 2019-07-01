`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2019 05:03:57 PM
// Design Name: 
// Module Name: load_fetch
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


module load_fetch(
(* DONT_TOUCH = "TRUE" *)input [519:0]       s_axis_mm2s_tdata           ,
(* DONT_TOUCH = "TRUE" *)input 			    s_axis_mm2s_tvalid 	  		,
(* DONT_TOUCH = "TRUE" *)output 		    s_axis_mm2s_tready 	  		,
(* DONT_TOUCH = "TRUE" *)output reg [31:0]  m_axis_s2mm_tdata           ,
(* DONT_TOUCH = "TRUE" *)output reg		    m_axis_s2mm_tvalid 	  		,
(* DONT_TOUCH = "TRUE" *)output reg		    m_axis_s2mm_tlast 	  		,
(* DONT_TOUCH = "TRUE" *)input 		        m_axis_s2mm_tready 	  		,
(* DONT_TOUCH = "TRUE" *)output reg [31:0]  load_data_i 	        ,
//(* DONT_TOUCH = "TRUE" *)output reg			load_data_en_i 	,
(* DONT_TOUCH = "TRUE" *)output  		    m_axis_mm2s_cmd_tvalid   	,
(* DONT_TOUCH = "TRUE" *)input 			    m_axis_mm2s_cmd_tready   	,
(* DONT_TOUCH = "TRUE" *)output [71:0]	    m_axis_mm2s_cmd_tdata    	,
(* DONT_TOUCH = "TRUE" *)output  		    m_axis_s2mm_cmd_tvalid   	,
(* DONT_TOUCH = "TRUE" *)input 			    m_axis_s2mm_cmd_tready   	,
(* DONT_TOUCH = "TRUE" *)output [71:0]	    m_axis_s2mm_cmd_tdata    	,
(* DONT_TOUCH = "TRUE" *)input[31:0]        gpio_io_o   ,

input clk,
input rstn
    );
    
    (* DONT_TOUCH = "TRUE" *)wire [15:0] m_axis_dout_tdata;        // output wire [31 : 0] m_axis_dout_tdata
    (* DONT_TOUCH = "TRUE" *)wire [7:0] max_ID;
    (* DONT_TOUCH = "TRUE" *)wire m_axis_dout_tvalid;
    
    softmax softmax(
        .aclk(clk),
        .rst_n(rstn),
        .s_axis_softmax_data(s_axis_mm2s_tdata),
        .s_axis_softmax_tvalid(s_axis_mm2s_tvalid),
        .s_axis_softmax_tready(s_axis_mm2s_tready),
        .m_axis_dout_tvalid(m_axis_dout_tvalid),
        .m_axis_dout_tdata(m_axis_dout_tdata),
        .max_ID(max_ID)
    );
    
    always@(posedge clk)	
    begin
        if (!rstn) begin
            load_data_i     <= 0;
            //load_data_en_i    <= 0;
        end
        else if(s_axis_mm2s_tvalid==1)
        begin
            load_data_i     <= s_axis_mm2s_tdata;
            //load_data_en_i    <= m_axis_mm2s_tvalid;
        end
        else begin
            load_data_i     <= load_data_i;
        end
    end 
    
    //mm2s cmd
    (* DONT_TOUCH = "TRUE" *)reg valid_mm2s_cmd;
    (* DONT_TOUCH = "TRUE" *)reg valid_mm2s_cmd2;
    
    always@(posedge clk)
    begin
        if (!rstn || gpio_io_o==32'h0000_0000)    valid_mm2s_cmd <= 0;
        else if(gpio_io_o==32'h0000_00aa)       valid_mm2s_cmd <= 1;
        else                                    valid_mm2s_cmd <= valid_mm2s_cmd;       
    end
    
    always@(posedge clk)
    begin
        if (!rstn || gpio_io_o==32'h0000_0000)    valid_mm2s_cmd2 <= 0;
        else if(m_axis_mm2s_cmd_tready)         valid_mm2s_cmd2 <= valid_mm2s_cmd;
        else                                    valid_mm2s_cmd2 <= valid_mm2s_cmd2;
    end
    
    assign m_axis_mm2s_cmd_tvalid = (valid_mm2s_cmd) & (!valid_mm2s_cmd2);
    
    assign m_axis_mm2s_cmd_tdata[22:0] = 312000;		//BTT: Bytes To Transfer
    assign m_axis_mm2s_cmd_tdata[23] = 1;                    //type: 1-enable INCR    0- enable FIXED;
    assign m_axis_mm2s_cmd_tdata[29:24] = 0;                //DSA: DRE Stream Alignment
    assign m_axis_mm2s_cmd_tdata[30] = 1;                    //EOF: End Of Frame
    assign m_axis_mm2s_cmd_tdata[31] = 1;                    //DRR: DRE ReAlignment Request
    assign m_axis_mm2s_cmd_tdata[63:32] = 32'h0000_0000;//32'h60000000;    //SADDR: Start Address    
    assign m_axis_mm2s_cmd_tdata[67:64] = 0;                //TAG: Command TAG
    assign m_axis_mm2s_cmd_tdata[71:68] = 0;                //RSVD: Reserved
    
    //s2mm cmd
    (* DONT_TOUCH = "TRUE" *)reg valid_s2mm_cmd;
    (* DONT_TOUCH = "TRUE" *)reg valid_s2mm_cmd2;
    
    always@(posedge clk)
    begin
        if (!rstn || gpio_io_o==32'h0000_0000)  valid_s2mm_cmd <= 0;
        else if(gpio_io_o==32'h0000_00aa)       valid_s2mm_cmd <= 1;
        else                                    valid_s2mm_cmd <= valid_s2mm_cmd;       
    end
    
    always@(posedge clk)
    begin
        if (!rstn || gpio_io_o==32'h0000_0000)  valid_s2mm_cmd2 <= 0;
        else if(m_axis_s2mm_cmd_tready)         valid_s2mm_cmd2 <= valid_s2mm_cmd;
        else                                    valid_s2mm_cmd2 <= valid_s2mm_cmd2;
    end
    
    assign m_axis_s2mm_cmd_tvalid = (valid_s2mm_cmd) & (!valid_s2mm_cmd2);
    
    assign m_axis_s2mm_cmd_tdata[22:0] = 19200;		//BTT: Bytes To Transfer
    assign m_axis_s2mm_cmd_tdata[23] = 1;                    //type: 1-enable INCR    0- enable FIXED;
    assign m_axis_s2mm_cmd_tdata[29:24] = 0;                //DSA: DRE Stream Alignment
    assign m_axis_s2mm_cmd_tdata[30] = 1;                    //EOF: End Of Frame
    assign m_axis_s2mm_cmd_tdata[31] = 1;                    //DRR: DRE ReAlignment Request
    assign m_axis_s2mm_cmd_tdata[63:32] = 32'h0008_0000;//32'h7000_0000;    //SADDR: Start Address    
    assign m_axis_s2mm_cmd_tdata[67:64] = 0;                //TAG: Command TAG
    assign m_axis_s2mm_cmd_tdata[71:68] = 0;                //RSVD: Reserved
    
    //s2mm_tdata
    always@(posedge clk)	
    begin
        if (!rstn) m_axis_s2mm_tdata <= 0;
        else if(m_axis_dout_tvalid && m_axis_s2mm_tready)
        begin
            m_axis_s2mm_tdata[15:0] <= m_axis_dout_tdata;
            m_axis_s2mm_tdata[23:16] <= max_ID;
            m_axis_s2mm_tdata[31:24] <= 0;
        end
        else m_axis_s2mm_tdata <= m_axis_s2mm_tdata;
    end 
    
    //s2mm_tvalid
    always@(posedge clk)	
    begin
        if (!rstn)  m_axis_s2mm_tvalid <= 0;
        else        m_axis_s2mm_tvalid <= (m_axis_dout_tvalid && m_axis_s2mm_tready);
    end 
    
    //s2mm_tlast
    (* DONT_TOUCH = "TRUE" *)reg [15:0] tlast_num;
    always@(posedge clk)	
    begin
        if (!rstn || m_axis_mm2s_cmd_tvalid) begin
            tlast_num <= 0;
        end
        else if(m_axis_dout_tvalid && m_axis_s2mm_tready) begin
            tlast_num <= tlast_num + 1;
        end
        else begin
            tlast_num <= tlast_num;
        end
    end 
    
    always@(posedge clk)	
    begin
        if (!rstn || tlast_num<4799) begin
            m_axis_s2mm_tlast <= 0;
        end
        else begin
            m_axis_s2mm_tlast <= 1;
        end
    end 
    
    //mm2s_tready
    assign s_axis_mm2s_tready = m_axis_s2mm_tready;
    
    
    
endmodule
