`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/21 14:27:08
// Design Name: 
// Module Name: controller
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
//`include "axi_vip_0_mem_stimulus.sv"

module controller(
    

    );
    (* DONT_TOUCH = "TRUE" *)reg         aclk;
    (* DONT_TOUCH = "TRUE" *)reg         rst_n;
    (* DONT_TOUCH = "TRUE" *)reg [31:0]        gpio_io_o;
    
//    axi_vip_0_mem_stimulus slv();
    
    initial
    begin 
        aclk <= 1;
        rst_n <= 0;
        forever  #5 aclk <= ~aclk;  
    end
    
    initial
    begin 
        gpio_io_o<=32'h0000_0000;
        #1000 gpio_io_o<=32'h0000_00aa;
        #1100 gpio_io_o<=32'h0000_0000;
    end
    
    design_2_wrapper block_design
       (aclk,
        gpio_io_o,
        rst_n);
    
    integer fid;
    integer i;
    initial
    begin
        fid = $fopen("xxxx.txt","w");
        wait(block_design.design_2_i.load_fetch_0.m_axis_s2mm_tlast && block_design.design_2_i.blk_mem_gen_1.addra==0);
        $display("-------------------------------start output--------------------------------------------");
        for(i=0;i<4800;i=i+1)
        begin
            $fwrite(fid, "%.0f ",block_design.design_2_i.blk_mem_gen_1.inst.native_mem_mapped_module.blk_mem_gen_v8_4_1_inst.memory[131072+i][31:16]);
            $fwrite(fid, "%f ",block_design.design_2_i.blk_mem_gen_1.inst.native_mem_mapped_module.blk_mem_gen_v8_4_1_inst.memory[131072+i][15:0]/4096.0);
            $fwrite(fid, "%f\n",4096.0/block_design.design_2_i.blk_mem_gen_1.inst.native_mem_mapped_module.blk_mem_gen_v8_4_1_inst.memory[131072+i][15:0]);
        end
        $display("-------------------------------finish output--------------------------------------------");
        $fclose(fid);
    end
    
endmodule
