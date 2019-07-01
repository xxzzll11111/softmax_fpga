`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2019 02:09:12 AM
// Design Name: 
// Module Name: div_softmax
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


module div_softmax(
    (* DONT_TOUCH = "TRUE" *)input              aclk,                                      // input wire aclk
    (* DONT_TOUCH = "TRUE" *)input              rst_n,
    (* DONT_TOUCH = "TRUE" *)input              div_in_tvalid,    // input wire s_axis_divisor_tvalid
    (* DONT_TOUCH = "TRUE" *)output             div_in_tready,    // output wire s_axis_divisor_tready
    (* DONT_TOUCH = "TRUE" *)input signed [7:0] divisor_exponent_tdata,      // input wire [31 : 0] s_axis_divisor_tdata
    (* DONT_TOUCH = "TRUE" *)input [23:0]       dividend_power_tdata,    // input wire [23 : 0] s_axis_dividend_tdata
    (* DONT_TOUCH = "TRUE" *)output reg         div_out_tvalid,          // output wire m_axis_dout_tvalid
    (* DONT_TOUCH = "TRUE" *)output [15:0]      div_out_tdata            // output wire [31 : 0] m_axis_dout_tdata
    );
    
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] divisor_exponent_with_bias;
    assign divisor_exponent_with_bias = (divisor_exponent_tdata <= -12)? -16:divisor_exponent_tdata - 4;
    
    (* DONT_TOUCH = "TRUE" *)wire [39:0] dividend_power;
    assign dividend_power = dividend_power_tdata;
    
    (* DONT_TOUCH = "TRUE" *)reg [39:0] div_result;
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            div_result <= 0;
        end
        else begin
            if(div_in_tvalid) begin
                if(divisor_exponent_with_bias>4)
                    div_result <= dividend_power >> 4;
                else if(divisor_exponent_with_bias>0)
                    div_result <= dividend_power >> divisor_exponent_with_bias;
                else
                    div_result <= dividend_power << -divisor_exponent_with_bias;
            end
            else begin
                div_result <= div_result;
            end
        end
    end
    
    assign div_out_tdata = (div_result>40'h00_0000_FFFF)? 16'hFFFF:div_result;
    
    assign div_in_tready = 1;
    
    always@(posedge aclk)
    begin
        if (!rst_n) begin
            div_out_tvalid <= 0;
        end
        else begin
            div_out_tvalid <= div_in_tvalid;
        end
    end
    
endmodule
