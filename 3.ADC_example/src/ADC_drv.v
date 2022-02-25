module ADC_drv (input CLK_24MHz,
                output [11: 0] dout);
    
    // 功能：不断地让 ADC 转换，然后输出结果。请参考该网址里边对 ADC 的介绍文档：http://www.anlogic.com/prod_view.aspx?TypeId=10&Id=168
    
    reg clk_12MHz      = 1'b0;
    reg [3: 0] counter = 4'd0;
    reg soc            = 1'b0;
    wire eoc;
    
    reg converting = 1'b0; // 为 1 表示在转换过程中
    
    always @(posedge CLK_24MHz) begin  // 生成个 12 MHz 的时钟供 ADC 模块使用
        clk_12MHz = ~clk_12MHz;
    end
    
    ADC_module ADC_module_0(
    .clk(clk_12MHz),            // 工作时钟，不能大于 16MHz
    .pd(1'b0),                  // PowerDown 设为 0，即不关机
    .s(3'b110),                 // 选择通道，此时选择通道 6，对应 87 号引脚
    .soc(soc),                  // 传入一次高信号开始采样
    .eoc(eoc),                  // 输出高信号表示采样完成
    .dout(dout)                 // 转换结果，长度 12 位，但高 8 位是有效精度
    );
    
    always @(posedge clk_12MHz) begin
        counter = counter + 1;
        if ((counter == 4'd0) && (!converting)) begin
            soc        = 1'b1;
            converting = 1'b1;
        end
        
        if ((counter == 4'd1) && (converting)) begin
            soc = 1'b0;
        end
        
        if (eoc) begin
            converting = 1'b0;
        end
        
    end
    
endmodule
