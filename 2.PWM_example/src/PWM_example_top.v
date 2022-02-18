module PWM_example_top(input clk_in,    // 24MHz
                       input pause_n,   // 按住暂停
                       output pwm_out); // 点灯引脚
    
    // 功能：把三个子模块连起来，实现亮暗变化周期为 2s 的呼吸灯
    
    wire clk_200;
    wire [7: 0] duty_cycle;
    
    divider_120k divider_120k_0 (
    .clk_in(clk_in),
    .clk_out(clk_200)
    );
    
    counter_200 counter_200_0(
    .clk_in (clk_200),
    .pause_n (pause_n),
    .duty_cycle(duty_cycle)
    );
    
    PWM_module #(8) PWM_module_0(
    .clk_in (clk_in),
    .en (1'b1),
    .duty_cycle (duty_cycle),
    .pwm_out (pwm_out)
    );
    
endmodule
