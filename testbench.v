`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2019 10:36:54 AM
// Design Name: 
// Module Name: testbench
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


module testbench(
   
    );
    
    
    (* DONT_TOUCH = "TRUE" *)reg [519:0] input_data;
    (* DONT_TOUCH = "TRUE" *)wire [7:0] max_ID;
    (* DONT_TOUCH = "TRUE" *)reg aclk;
    (* DONT_TOUCH = "TRUE" *)reg rst_n;
    (* DONT_TOUCH = "TRUE" *)reg s_axis_softmax_tvalid;
    (* DONT_TOUCH = "TRUE" *)wire s_axis_softmax_tready;
    (* DONT_TOUCH = "TRUE" *)wire m_axis_dout_tvalid;          // output wire m_axis_dout_tvalid
    (* DONT_TOUCH = "TRUE" *)wire [15 : 0] m_axis_dout_tdata;        // output wire [31 : 0] m_axis_dout_tdata
    (* DONT_TOUCH = "TRUE" *)reg [7:0]k;
    
    initial
    begin 
        aclk <= 1;
        s_axis_softmax_tvalid <= 1;
        rst_n <= 1;
        k <= 0;
        forever  #5 aclk <= ~aclk;  
    end
    
    initial
    begin 
        rst_n <= 0;
        #15 rst_n <= 1;
    end
    
    softmax softmax(
        .aclk(aclk),
        .rst_n(rst_n),
        .s_axis_softmax_data(input_data),
        .s_axis_softmax_tvalid(s_axis_softmax_tvalid),
        .s_axis_softmax_tready(s_axis_softmax_tready),
        .m_axis_dout_tvalid(m_axis_dout_tvalid),
        .m_axis_dout_tdata(m_axis_dout_tdata),
        .max_ID(max_ID)
    );
    
    always@(posedge aclk)	
    begin
        if(!rst_n)
            input_data <= 1 << 8;
        else begin
            if(s_axis_softmax_tready)
                input_data <= input_data << 9;
            else
                input_data <= input_data;
        end
    end
    
    // always@(posedge aclk)	
    // begin
        // if(k < 0)
            // k <= k + 1;
        // else begin
            // s_axis_softmax_tvalid <= ~s_axis_softmax_tvalid;
            // k <= 0;
        // end
    // end
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] test1;
    assign test1 = -128;
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] test;
    assign test = test1 - 4;
    
    


endmodule
