module AdjustableLED_top (input CLK_24MHz,
                          output LED);
    
    // 功能：把 ADC 和 PWM 模块以一定的逻辑组合，实现旋旋钮可以调 LED 亮度
    
    wire [11: 0] dout;
    
    ADC_drv ADC_drv_0(
    .CLK_24MHz(CLK_24MHz),
    .dout(dout)                    // 转换结果
    );
    
    PWM_module #(8) PWM_module_0(
    .clk_in (CLK_24MHz),
    .en (1'b1),
    .duty_cycle (dout[11: 4]),   // 传入 ADC 转换结果的高 8 位
    .pwm_out (LED)
    );
    
endmodule
