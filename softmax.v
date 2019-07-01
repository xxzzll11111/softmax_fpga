`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 04:07:34 AM
// Design Name: 
// Module Name: softmax
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


module softmax(
    (* DONT_TOUCH = "TRUE" *)input          aclk,
    (* DONT_TOUCH = "TRUE" *)input          rst_n,
    (* DONT_TOUCH = "TRUE" *)input [519:0]  s_axis_softmax_data,
    (* DONT_TOUCH = "TRUE" *)input          s_axis_softmax_tvalid,
    (* DONT_TOUCH = "TRUE" *)output         s_axis_softmax_tready,
    (* DONT_TOUCH = "TRUE" *)output         m_axis_dout_tvalid,
    (* DONT_TOUCH = "TRUE" *)output [15:0]  m_axis_dout_tdata,
    (* DONT_TOUCH = "TRUE" *)output [7:0]   max_ID
    );
    
    genvar i;
    
    //adder_tree
    (* DONT_TOUCH = "TRUE" *)wire [23:0] conf_index_sum;
    (* DONT_TOUCH = "TRUE" *)wire adder_tree_out_valid;
    adder_tree adder_tree(
        .aclk(aclk),
        .rst_n(rst_n),
        .input_data(s_axis_softmax_data),
        .in_valid(s_axis_softmax_tvalid),
        .div_ready(1),
        .output_adder(conf_index_sum),
        .adder_tree_out_valid(adder_tree_out_valid)
    );
    
    //compare_tree
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] max_data;
    (* DONT_TOUCH = "TRUE" *)wire [7:0] max_ID_tmp;
    (* DONT_TOUCH = "TRUE" *)wire compare_tree_out_valid;
    compare_tree compare_tree(
        .aclk(aclk),
        .rst_n(rst_n),
        .input_data(s_axis_softmax_data),
        .in_valid(s_axis_softmax_tvalid),
        .max_data(max_data),
        .max_ID(max_ID_tmp),
        .compare_tree_out_valid(compare_tree_out_valid)
    );
    
    //ID_delay
    (* DONT_TOUCH = "TRUE" *)reg [7:0] ID_delay[0:0];
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            ID_delay[0] <= 0;
        end
        else begin
            ID_delay[0] <= max_ID_tmp;
        end
    end
    
    generate
    for(i=0;i<0;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                ID_delay[i+1] <= 0;
            end
            else begin
                ID_delay[i+1] <= ID_delay[i];
            end
        end
    end
    endgenerate
    
    assign max_ID = ID_delay[0];
    
    //div
    (* DONT_TOUCH = "TRUE" *)wire din_tvalid;
    assign din_tvalid = compare_tree_out_valid & adder_tree_out_valid;
    
    div_softmax div (
      .aclk(aclk),                                      // input wire aclk
      .rst_n(rst_n),
      .div_in_tvalid(din_tvalid),    // input wire s_axis_divisor_tvalid
      .div_in_tready(s_axis_softmax_tready),    // output wire s_axis_divisor_tready
      .divisor_exponent_tdata(max_data),      // input wire [7 : 0] s_axis_divisor_tdata
      .dividend_power_tdata(conf_index_sum),    // input wire [23 : 0] s_axis_dividend_tdata
      .div_out_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
      .div_out_tdata(m_axis_dout_tdata)            // output wire [31 : 0] m_axis_dout_tdata
    );
    
endmodule
