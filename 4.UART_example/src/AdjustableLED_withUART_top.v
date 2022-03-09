module AdjustableLED_withUART_top (input CLK_24MHz,
                                   output LED,
                                   output TX_USB,   // 两个 TX 引脚，一个转换成 USB 接给电脑，一个接到 3 号引脚，可供逻辑分析仪采样
                                   output TX_GPIO);
    
    // 功能：旋旋钮可以调 LED 亮度，且每隔一段时间会通过 UART 发送 ADC 转换结果的高 8 位（时间间隔由 UART_TX_ticker 控制）
    
    wire [11: 0] dout;
    wire UART_start_signal;
    
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
    
    UART_TX_ticker UART_TX_ticker_0(
    .CLK_24MHz(CLK_24MHz),
    .emit(UART_start_signal)
    );
    
    UART_TX UART_TX_0(
    .CLK_24MHz(CLK_24MHz),
    .data_in(dout[11: 4]),
    .start(UART_start_signal),
    .TX(TX_GPIO)
    );
    
    assign TX_USB = TX_GPIO;
    
endmodule
