`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 01:47:50 AM
// Design Name: 
// Module Name: compare_tree
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


module compare_tree(
    (* DONT_TOUCH = "TRUE" *)input                      aclk,
    (* DONT_TOUCH = "TRUE" *)input                      rst_n,
    (* DONT_TOUCH = "TRUE" *)input [511:0]              input_data,
    (* DONT_TOUCH = "TRUE" *)input                      in_valid,
    (* DONT_TOUCH = "TRUE" *)output reg signed [7:0]    max_data,
    (* DONT_TOUCH = "TRUE" *)output reg [7:0]           max_ID,
    (* DONT_TOUCH = "TRUE" *)output                     compare_tree_out_valid
    );
    
    genvar i; 
    
    //valid_delay
    (* DONT_TOUCH = "TRUE" *)reg valid_delay[6:0];
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            valid_delay[0] <= 0;
        end
        else begin
            valid_delay[0] <= in_valid;
        end
    end
    
    generate
    for(i=0;i<6;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                valid_delay[i+1] <= 0;
            end
            else begin
                valid_delay[i+1] <= valid_delay[i];
            end
        end
    end
    endgenerate
    
    assign compare_tree_out_valid = valid_delay[6];
    
    //data resize
    (* DONT_TOUCH = "TRUE" *)wire signed [7:0] conf_data [0:63];
    generate
    for(i=0;i<64;i=i+1)
    begin
        assign conf_data[i] = input_data[i*8+7:i*8];
    end
    endgenerate
    
    //compare
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] conf_max_data_1 [0:31];
    (* DONT_TOUCH = "TRUE" *)reg[7:0] conf_max_ID_1 [0:31];
    generate
    for(i=0;i<32;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_max_data_1[i] <= 0;
                conf_max_ID_1[i] <= 0;
            end
            else begin
                conf_max_data_1[i] <= conf_data[2*i]>=conf_data[2*i+1]?   conf_data[2*i]:conf_data[2*i+1];
                conf_max_ID_1[i] <= conf_data[2*i]>=conf_data[2*i+1]?     (2*i):(2*i+1);
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] conf_max_data_2 [0:15];
    (* DONT_TOUCH = "TRUE" *)reg [7:0] conf_max_ID_2 [0:15];
    generate
    for(i=0;i<16;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_max_data_2[i] <= 0;
                conf_max_ID_2[i] <= 0;
            end
            else begin
                conf_max_data_2[i] <= conf_max_data_1[2*i]>=conf_max_data_1[2*i+1]?   conf_max_data_1[2*i]:conf_max_data_1[2*i+1];
                conf_max_ID_2[i] <= conf_max_data_1[2*i]>=conf_max_data_1[2*i+1]?     conf_max_ID_1[2*i]:conf_max_ID_1[2*i+1];
            end
        end
        
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] conf_max_data_3 [0:7];
    (* DONT_TOUCH = "TRUE" *)reg [7:0] conf_max_ID_3 [0:7];
    generate
    for(i=0;i<8;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_max_data_3[i] <= 0;
                conf_max_ID_3[i] <= 0;
            end
            else begin
                conf_max_data_3[i] <= conf_max_data_2[2*i]>=conf_max_data_2[2*i+1]?   conf_max_data_2[2*i]:conf_max_data_2[2*i+1];
                conf_max_ID_3[i] <= conf_max_data_2[2*i]>=conf_max_data_2[2*i+1]?     conf_max_ID_2[2*i]:conf_max_ID_2[2*i+1];
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] conf_max_data_4 [0:3];
    (* DONT_TOUCH = "TRUE" *)reg [7:0] conf_max_ID_4 [0:3];
    generate
    for(i=0;i<4;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_max_data_4[i] <= 0;
                conf_max_ID_4[i] <= 0;
            end
            else begin
                conf_max_data_4[i] <= conf_max_data_3[2*i]>=conf_max_data_3[2*i+1]?   conf_max_data_3[2*i]:conf_max_data_3[2*i+1];
                conf_max_ID_4[i] <= conf_max_data_3[2*i]>=conf_max_data_3[2*i+1]?     conf_max_ID_3[2*i]:conf_max_ID_3[2*i+1];
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] conf_max_data_5 [0:1];
    (* DONT_TOUCH = "TRUE" *)reg [7:0] conf_max_ID_5 [0:1];
    generate
    for(i=0;i<2;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_max_data_5[i] <= 0;
                conf_max_ID_5[i] <= 0;
            end
            else begin
                conf_max_data_5[i] <= conf_max_data_4[2*i]>=conf_max_data_4[2*i+1]?   conf_max_data_4[2*i]:conf_max_data_4[2*i+1];
                conf_max_ID_5[i] <= conf_max_data_4[2*i]>=conf_max_data_4[2*i+1]?     conf_max_ID_4[2*i]:conf_max_ID_4[2*i+1];
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] conf_max_data_6;
    (* DONT_TOUCH = "TRUE" *)reg [7:0] conf_max_ID_6;
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            conf_max_data_6 <= 0;
            conf_max_ID_6 <= 0;
        end
        else begin
            conf_max_data_6 <= conf_max_data_5[0]>=conf_max_data_5[1]?   conf_max_data_5[0]:conf_max_data_5[1];
            conf_max_ID_6 <= conf_max_data_5[0]>=conf_max_data_5[1]?     conf_max_ID_5[0]:conf_max_ID_5[1];
        end
    end
    
    //output delay
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            max_data <= 0;
        end
        else begin
            max_data <= conf_max_data_6;
        end
    end
    
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            max_ID <= 0;
        end
        else begin
            max_ID <= conf_max_ID_6;
        end
    end

    
endmodule
