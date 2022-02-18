module divider_120k (input clk_in,               // 24MHz
                     output reg clk_out = 1'd0); // 200Hz
    
    // 功能：把 24MHz 的时钟分频 12k 倍，输出 200Hz 的时钟
    
    reg [15: 0] counter = 'd0;
    
    always @(posedge clk_in) begin
        if (counter < 'd59999) begin
            counter = counter + 1;
        end
        else begin
            counter = 'd0;
            clk_out = ~clk_out;
        end
    end
    
endmodule
