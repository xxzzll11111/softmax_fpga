`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2019 04:10:23 AM
// Design Name: 
// Module Name: compare
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


module compare(
    input signed [7:0] data_0,
    input signed [7:0] data_1,
    input signed [7:0] data_2,
    input signed [7:0] data_3,
    input [7:0] ID_0,
    input [7:0] ID_1,
    input [7:0] ID_2,
    input [7:0] ID_3,
    output signed [7:0] max_data_0,
    output signed [7:0] max_data_1,
    output [7:0] max_ID_0,
    output [7:0] max_ID_1
    );
    
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] compare_data_1 [0:1];
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] compare_ID_1 [0:1];
    assign compare_data_1[0] = data_0>=data_1?      data_0:data_1;
    assign compare_data_1[1] = data_2>=data_3?      data_2:data_3;
    assign compare_ID_1[0] = data_0>=data_1?        ID_0:ID_1;
    assign compare_ID_1[1] = data_2>=data_3?        ID_2:ID_3;
    
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] compare_data_1_N [0:1];
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] compare_ID_1_N [0:1];
    assign compare_data_1_N[0] = data_0>=data_1?    data_1:data_0;
    assign compare_data_1_N[1] = data_2>=data_3?    data_3:data_2;
    assign compare_ID_1_N[0] = data_0>=data_1?      ID_1:ID_0;
    assign compare_ID_1_N[1] = data_2>=data_3?      ID_3:ID_2;
    
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] compare_data_2;
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] compare_ID_2;
    assign compare_data_2 = compare_data_1[0]>=compare_data_1[1]?compare_data_1[0]:compare_data_1[1];
    assign compare_ID_2 = compare_data_1[0]>=compare_data_1[1]?compare_ID_1[0]:compare_ID_1[1];
    
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] compare_data_3;
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] compare_ID_3;
    always@(*)	
    begin
        if(compare_ID_2==compare_ID_1[0])
            if(compare_data_1_N[0]>=compare_data_1[1])
                begin
                    compare_data_3 = compare_data_1_N[0];
                    compare_ID_3 = compare_ID_1_N[0];
                end
            else
                begin
                    compare_data_3 = compare_data_1[1];
                    compare_ID_3 = compare_ID_1[1];
                end
        else
            if(compare_data_1[0]>=compare_data_1_N[1])
                begin
                    compare_data_3 = compare_data_1[0];
                    compare_ID_3 = compare_ID_1[0];
                end
            else
                begin
                    compare_data_3 = compare_data_1_N[1];
                    compare_ID_3 = compare_ID_1_N[1];
                end
    end 
    
    assign max_data_0 = compare_data_2;
    assign max_data_1 = compare_data_3;
    assign max_ID_0 = compare_ID_2;
    assign max_ID_1 = compare_ID_3;
    
    
    
endmodule
