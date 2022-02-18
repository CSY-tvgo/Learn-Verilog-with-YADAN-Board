`timescale 1ns/1ps
module PWM_module_tb ();
    
    // PWM 分辨率位宽
    parameter width = 8;
    
    // 输入
    reg clk_in;
    reg [width - 1: 0] duty_cycle;
    
    // 输出
    wire pwm_out;
    
    // 例化待测模块
    PWM_module #(width) uut_pwm(
    .clk_in (clk_in),
    .en (1'b1),
    .duty_cycle (duty_cycle),
    .pwm_out (pwm_out)
    );
    
    // 描述输入信号
    initial begin
        clk_in = 0;
        
        duty_cycle = 'd100;
        repeat(10000)
            #10
            clk_in = ~clk_in;
        
        duty_cycle = 'd0;
        repeat(10000)
            #10
            clk_in = ~clk_in;
        
        duty_cycle = 'd255;
        repeat(10000)
            #10
            clk_in = ~clk_in;
    end
    
endmodule
