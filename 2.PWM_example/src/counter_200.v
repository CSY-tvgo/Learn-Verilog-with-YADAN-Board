module counter_200(input clk_in,                        // 200Hz
                   input pause_n,                       // 按住暂停
                   output reg [7: 0] duty_cycle = 'd0); // 输出占空比的数值
    
    // 功能：在每第 0 ~ 1 秒，生成 0 ~ 199 递增的数值，在每第 1 ~ 2 秒，生成 200 ~ 1 递减的数值
    
    reg dir = 'd0; // 0 为递增，1 为递减
    
    always @(posedge clk_in) begin
        if (pause_n) begin
            if (dir == 'd0) begin
                if (duty_cycle < 'd199) begin
                    duty_cycle = duty_cycle + 1;
                end
                else begin
                    duty_cycle = 'd200;
                    dir        = 'd1;
                end
            end
            else begin
                if (duty_cycle > 'd1) begin
                    duty_cycle = duty_cycle - 1;
                end
                else begin
                    duty_cycle = 'd0;
                    dir        = 'd0;
                end
            end
        end
    end
    
endmodule
