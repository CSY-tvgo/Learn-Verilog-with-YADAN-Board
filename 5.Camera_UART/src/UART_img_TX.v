/**
 * Author: Karbon
 * GitHub: https://github.com/csy-tvgo
 * Date:   2022-May-9
 * Doc:    https://verimake.com/d/189
 */

module UART_img_TX #(parameter width = 200,        // 图像宽度
                     parameter height = 164,       // 图像高度
                     parameter resize = 1)         // 缩小倍数（若缩小会传输更快，请设为宽度和高度的公约数）
                    (input CLK_24MHz,
                     output reg img_rclk = 1'b0,
                     output reg [15:0] img_rdaddr,
                     input [15:0] img_rddat,
                     output reg cam_wlock = 1'b0,  // 这个寄存器若为 1，暂停让摄像头向 BRAM 里写入数据
                     output TX_USB);
    
    // 功能：从 BRAM 里读图像并通过 UART_TX 模块发送出去
    
    reg [23: 0] counter = 'd0;   // 计数
    
    reg [15: 0] pixel_x = 'd0;   // 当前像素的 x 方向坐标
    reg [15: 0] pixel_y = 'd0;   // 当前像素的 y 方向坐标
    
    reg [15: 0] datapack;        // 打包好的一像素数据，共 2B
    reg [7: 0] send_buf;         // 暂存待发的 1B 数据
    reg emit = 1'b0;             // 控制 UART_TX 发送的信号
    
    always @(posedge CLK_24MHz) begin
        
        counter = counter + 1;
        if (counter >= 'd2400) begin // 10000 px/s
            counter = 'd0;
        end
        
        case(counter)
            // 从 BRAM 读数据
            'd0: begin
                img_rdaddr = pixel_x + pixel_y * width + 16'd1;
                img_rclk   = 1'b1;
            end
            
            // 打包从 BRAM 读来的数据，然后发送高 8 位
            'd1: begin
                img_rclk = 1'b0;
                
                // 打包第一字节数据
                datapack[15]    = 1'b1;                                               // 固定值1
                datapack[14]    = ((pixel_y == 'd0) && (pixel_x == 'd0))? 1'b1: 1'b0; // 帧头标记
                datapack[13]    = (pixel_x == 'd0)? 1'b1: 1'b0;                       // 行头标记
                datapack[12: 9] = img_rddat[15: 12];                                  // R[3:0]
                datapack[8]     = img_rddat[10];                                      // G[3]
                // 打包第二字节数据
                datapack[7]     = 1'b0;                                               // 固定值0
                datapack[6: 4]  = img_rddat[9: 7];                                    // G[2:0]
                datapack[3: 0]  = img_rddat[4: 1];                                    // B[3:0]
                
                send_buf = datapack[15: 8];
                emit     = 1'b1;
            end
            
            // 复位 emit
            'd100:   emit = 1'b0;
            
            // 发送低 8 位
            'd1200: begin
                send_buf = datapack[7: 0];
                emit     = 1'b1;
            end
            
            // 复位 emit
            'd1300:   emit = 1'b0;
            
            // 准备下一像素的地址
            'd2399: begin
                pixel_x = pixel_x + resize;
                if (pixel_x >= width) begin
                    pixel_x = 'd0;
                    pixel_y = pixel_y + resize;
                    if (pixel_y >= height) begin
                        pixel_y = 'd0;
                    end
                end
            end
            
        endcase
    end
    
    
    UART_TX #(
    .baudrate(240000)) u_UART_TX
    (
    .CLK_24MHz(CLK_24MHz),
    .data_in(send_buf),
    .start(emit),
    .TX(TX_USB)
    );
    
endmodule
