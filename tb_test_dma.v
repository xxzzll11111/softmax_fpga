`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/28 21:39:37
// Design Name: 
// Module Name: tb_test_dma
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


module tb_test_dma(

    );
    
    (* DONT_TOUCH = "TRUE" *)reg         aclk;
    (* DONT_TOUCH = "TRUE" *)reg         rst_n;
    
//    axi_vip_0_mem_stimulus slv();
    
    initial
    begin 
        aclk <= 1;
        rst_n <= 0;
        forever  #5 aclk <= ~aclk;  
    end
    
    design_test_dma_wrapper block_design
       (aclk,
        rst_n);
    
    integer fid;
    integer i;
    initial
    begin
        fid = $fopen("dma_test.txt","w");
        #30_000;
        $display("-------------------------------start output--------------------------------------------");
        for(i=0;i<4800;i=i+1)
        begin
            $fwrite(fid, "%x\n",block_design.design_test_dma_i.blk_mem_gen_1.inst.native_mem_mapped_module.blk_mem_gen_v8_4_1_inst.memory[32768+i]);
//            if(i%4!=3)
//                $fwrite(fid, " ");
//            else
//                $fwrite(fid, "\n");
        end
        $display("-------------------------------finish output--------------------------------------------");
        $fclose(fid);
    end
endmodule
