/**
 * Author: Karbon
 * GitHub: https://github.com/csy-tvgo
 * Date:   2022-May-9
 * Doc:    https://verimake.com/d/189
 */

module UART_TX #(parameter baudrate = 115200)
                (input CLK_24MHz,
                 input [7: 0] data_in,
                 input start,                 // 开始发送
                 output reg TX = 1'b1);
    
    // 功能：用 UART 发送一字节数据，波特率：由 baudrate 设置，数据位: 8，奇偶校验: 无
    
    reg [23: 0] counter = 'd0;        // 用于分频的计数
    reg clk_uart        = 1'b0;       // 分频后的时钟
    
    reg [3: 0] state = 'd0;           // 指示发送状态（0: 闲置，1: 发送起始位，2 ~ 9: 发送数据，10: 发送停止位）
    reg [7: 0] data_buffer;           // start 触发时存储 data_in 端口输入的数据
    
    localparam div_factor = 12000000 / baudrate;
    always @(posedge CLK_24MHz) begin
        counter = counter + 1;
        if (counter >= div_factor) begin
            counter  = 'd0;
            clk_uart = ~clk_uart;
        end
    end
    
    always @(posedge clk_uart) begin
        if (state == 'd0 && start == 1'b1) begin
            state       = 'd1;
            data_buffer = data_in;
        end
        else if ('d0 < state && state < 'd9) begin
            state = state + 'd1;
        end
        else begin
            state = 0;
        end
        
        case (state)
            'd0: TX = 1'b1;
            'd1: TX = 1'b0;
            'd2: TX = data_buffer[0];
            'd3: TX = data_buffer[1];
            'd4: TX = data_buffer[2];
            'd5: TX = data_buffer[3];
            'd6: TX = data_buffer[4];
            'd7: TX = data_buffer[5];
            'd8: TX = data_buffer[6];
            'd9: TX = data_buffer[7];
            default: begin
                TX    = 1'b1;
                state = 0;
            end
        endcase
    end
    
endmodule
