/**
 * Author: Karbon
 * GitHub: https://github.com/csy-tvgo
 * Date:   2022-May-9
 * Doc:    https://verimake.com/d/189
 */

`timescale 1ns/ 1ps
module Camera_UART_top (input wire clk_24m,
                        input wire rst_n,
                        input wire cam_pclk,
                        output wire cam_xclk,
                        input wire cam_href,
                        input wire cam_vsync,
                        output wire cam_pwdn,
                        output wire cam_rst,
                        output wire cam_soic,
                        inout wire cam_soid,
                        input wire [7: 0] cam_data,
                        output wire TX_USB);
    
    // 功能：读取摄像头画面，通过 UART 发送
    
    //时钟
    wire   clk_cam;
    wire   clk_sccb;
    
    //摄像头连线
    wire        camera_wrreq;
    wire        camera_wclk;
    wire [15:0] camera_wrdat;
    wire [15:0] camera_addr;
    
    reg   init_state;
    wire   init_ready;
    wire   sda_oe;
    wire   sda;
    wire   sda_in;
    wire   scl;
    
    assign cam_soid = (sda_oe == 1'b1) ? sda : 1'bz;
    assign sda_in   = cam_soid;
    assign cam_soic = scl;
    assign cam_pwdn = 1'b0;
    assign cam_rst  = rst_n;
    
    // UART 图传连线
    wire uart_rclk;
    wire [7:0] uart_data;
    wire cam_wlock;
    wire [15:0] uart_rddat;
    wire [15:0] uart_rdaddr;
    
    // 例化各个模块
    
    ip_pll u_pll(
    .refclk(clk_24m),  // 24M
    .reset(!rst_n),
    .clk0_out(clk_cam),  // 12M, for cam xclk
    .clk1_out(clk_sccb)  // 4M, for sccb init
    );
    
    camera_init u_camera_init
    (
    .clk(clk_sccb),
    .reset_n(rst_n),
    .ready(init_ready),
    .sda_oe(sda_oe),
    .sda(sda),
    .sda_in(sda_in),
    .scl(scl)
    );
    
    camera_reader u_camera_reader
    (
    .clk  (clk_cam),
    .reset_n (rst_n),
    .csi_xclk (cam_xclk),
    .csi_pclk (cam_pclk),
    .csi_data (cam_data),
    .csi_vsync (!cam_vsync),
    .csi_hsync (cam_href),
    .data_out (camera_wrdat),
    .wrreq  (camera_wrreq),
    .wrclk  (camera_wclk),
    .wraddr  (camera_addr)
    );
    
    img_cache u_img_cache
    (
    //write 32800*16
    .dia  (camera_wrdat),
    .addra  (camera_addr),
    .cea  (camera_wrreq & (!cam_wlock)),
    .clka  (camera_wclk),
    //read 32800*16
    .dob   (uart_rddat),
    .addrb (uart_rdaddr),
    .ceb   (1'b1),
    .clkb  (uart_rclk)
    );
    
    UART_img_TX #(
    .width(200),
    .height(164),
    .resize(2)) u_UART_img_TX
    (
    .CLK_24MHz(clk_24m),
    .cam_wlock(cam_wlock),
    .img_rclk(uart_rclk),
    .img_rdaddr(uart_rdaddr),
    .img_rddat(uart_rddat),
    .TX_USB(TX_USB)
    );
    
endmodule
