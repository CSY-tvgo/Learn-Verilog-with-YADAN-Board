`timescale 1ms/1us
module counter_200_tb ();
    
    // 输入
    reg clk_in;
    reg pause_n;
    
    // 输出
    wire [7: 0] duty_cycle;
    
    // 例化待测模块
    counter_200 uut_counter(
    .clk_in (clk_in),
    .pause_n (pause_n),
    .duty_cycle (duty_cycle)
    );
    
    // 描述输入信号
    initial begin
        clk_in = 0;
        
        pause_n = 1;
        repeat(1000)
            #2.5
            clk_in = ~clk_in;
        
        pause_n = 0;
        repeat(1000)
            #2.5
            clk_in = ~clk_in;
    end
    
endmodule
