module UART_TX_ticker (input CLK_24MHz,
                       output reg emit = 1'b0);
    
    // 功能：每 10ms 向 UART_TX 模块发射一次发送信号
    
    reg [24: 0] counter = 'd0;
    
    always @(posedge CLK_24MHz) begin
        if (counter < 'd208) begin
            emit    = 1'b1;
            counter = counter + 1;
        end
        else if (counter < 'd239999) begin
            emit    = 1'b0;
            counter = counter + 1;
        end
        else begin
            counter = 'd0;
        end
    end
    
endmodule
