`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2019 12:45:36 AM
// Design Name: 
// Module Name: adder_tree
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


module adder_tree(
    (* DONT_TOUCH = "TRUE" *)input          aclk,
    (* DONT_TOUCH = "TRUE" *)input          rst_n,
    (* DONT_TOUCH = "TRUE" *)input [519:0]  input_data,
    (* DONT_TOUCH = "TRUE" *)input          in_valid,
    (* DONT_TOUCH = "TRUE" *)input          div_ready,
    (* DONT_TOUCH = "TRUE" *)output [23:0]  output_adder,
    (* DONT_TOUCH = "TRUE" *)output         adder_tree_out_valid
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
            if(div_ready)
                valid_delay[0] <= in_valid;
            else
                valid_delay[0] <= valid_delay[0];
            
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
                if(div_ready)
                    valid_delay[i+1] <= valid_delay[i];
                else
                    valid_delay[i+1] <= valid_delay[i+1];
                
            end
        end
    end
    endgenerate
    
    assign adder_tree_out_valid = valid_delay[6];
    
    //data resize
    (* DONT_TOUCH = "TRUE" *)reg signed [7:0] conf_data [0:64];
    generate
    for(i=0;i<65;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_data[i] <= 0;
            end
            else begin
                if(div_ready)
                    conf_data[i] <= 8'h07 - input_data[i*8+7:i*8];
                else
                    conf_data[i] <= conf_data[i];
            end
        end
    end
    endgenerate
    
    //exp
    (* DONT_TOUCH = "TRUE" *)reg [15:0] conf_index [0:64];
    generate
    for(i=0;i<65;i=i+1) begin
        always@(*)	
        begin
            if(conf_data[i][7])
                conf_index[i] <= 16'hFFFF ;
            else
                conf_index[i] <= 16'h8000 >> conf_data[i];
        end
    end
    endgenerate
    
    //add
    (* DONT_TOUCH = "TRUE" *)reg [23:0] conf_index_add_1 [0:31];
    generate
    for(i=0;i<31;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_index_add_1[i] <= 0;
            end
            else begin
                if(div_ready)
                    conf_index_add_1[i] <= conf_index[i*2] + conf_index[i*2+1];
                else
                    conf_index_add_1[i] <= conf_index_add_1[i];
            end
        end
    end
    endgenerate
    
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            conf_index_add_1[31] <= 0;
        end
        else begin
            if(div_ready)
                conf_index_add_1[31] <= conf_index[31*2] + conf_index[31*2+1] + conf_index[64];
            else
                conf_index_add_1[31] <= conf_index_add_1[31];
        end
    end
    
    (* DONT_TOUCH = "TRUE" *)reg [23:0] conf_index_add_2 [0:15];
    generate
    for(i=0;i<16;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_index_add_2[i] <= 0;
            end
            else begin
                if(div_ready)
                    conf_index_add_2[i] <= conf_index_add_1[i*2] + conf_index_add_1[i*2+1];
                else
                    conf_index_add_2[i] <= conf_index_add_2[i];
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg [23:0] conf_index_add_3 [0:7];
    generate
    for(i=0;i<8;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_index_add_3[i] <= 0;
            end
            else begin
                if(div_ready)
                    conf_index_add_3[i] <= conf_index_add_2[i*2] + conf_index_add_2[i*2+1];
                else
                    conf_index_add_3[i] <= conf_index_add_3[i];
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg [23:0] conf_index_add_4 [0:3];
    generate
    for(i=0;i<4;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_index_add_4[i] <= 0;
            end
            else begin
                if(div_ready)
                    conf_index_add_4[i] <= conf_index_add_3[i*2] + conf_index_add_3[i*2+1];
                else
                    conf_index_add_4[i] <= conf_index_add_4[i];
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg [23:0] conf_index_add_5 [0:1];
    generate
    for(i=0;i<2;i=i+1)
    begin
        always@(posedge aclk)	
        begin
            if (!rst_n) begin
                conf_index_add_5[i] <= 0;
            end
            else begin
                if(div_ready)
                    conf_index_add_5[i] <= conf_index_add_4[i*2] + conf_index_add_4[i*2+1];
                else
                    conf_index_add_5[i] <= conf_index_add_5[i];
            end
        end
    end
    endgenerate
    
    (* DONT_TOUCH = "TRUE" *)reg [23:0] conf_index_add_6;
    always@(posedge aclk)	
    begin
        if (!rst_n) begin
            conf_index_add_6 <= 0;
        end
        else begin
            if(div_ready)
                conf_index_add_6 <= conf_index_add_5[0] + conf_index_add_5[1];
            else
                conf_index_add_6 <= conf_index_add_6;
        end
    end
    
    //output
    assign output_adder = conf_index_add_6;
    
    
    
    
endmodule
