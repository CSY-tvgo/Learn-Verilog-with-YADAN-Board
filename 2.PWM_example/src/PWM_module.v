module PWM_module #(parameter width = 8)             // PWM 分辨率位宽
                   (input clk_in,                    // 输入时钟
                    input en,                        // 启用
                    input [width - 1: 0] duty_cycle, // 设定占空比
                    output pwm_out);                 // 输出 PWM 波
    
    // 功能：输入占空比，输出 PWM 波
    
    reg [width - 1: 0] counter        = 'd0;
    reg [width - 1: 0] duty_cycle_reg = 'd0;
    
    always@(duty_cycle) begin
        duty_cycle_reg = duty_cycle;
    end
    
    always @(posedge clk_in) begin
        if (en) begin
            if (counter > {width{1'b1}} - 2) begin  // 计数到这个点就归零，使 PWM 的分辨率为 2 ^ width - 1，即可覆盖 100% 占空比的情况
                counter = 'd0;
            end
            else begin
                counter = counter + 1;
            end
        end
    end
    
    assign pwm_out = (counter < duty_cycle_reg)? 1'b1: 1'b0;
    
endmodule
