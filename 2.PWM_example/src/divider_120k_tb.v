`timescale 1ns/1ps
module divider_120k_tb ();
    
    // 输入
    reg clk_in;
    
    // 输出
    wire clk_out;
    
    // 例化待测模块
    divider_120k uut_divider(
    .clk_in (clk_in),
    .clk_out (clk_out)
    );
    
    // 描述输入信号
    initial begin
        clk_in = 0;
        repeat(1000000)
            #10
            clk_in = ~clk_in;
    end
    
endmodule
