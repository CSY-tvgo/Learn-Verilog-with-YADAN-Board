module CW_TOP_WRAPPER(jtdi, jtck, jrstn, jscan, jshift, jupdate, jtdo, non_bus_din, bus_din, trig_clk, wt_ce, wt_en, wt_addr);
	localparam DEFAULT_CTRL_REG_LEN = 562;
	localparam DEFAULT_STAT_REG_LEN = 18;
	localparam DEFAULT_STOP_LEN = 42;
	localparam DEFAULT_NON_BUS_NODE_NUM = 1;
	localparam DEFAULT_BUS_NODE_NUM = 82;
	localparam DEFAULT_BUS_NUM = 8;
	localparam DEFAULT_BUS1_WIDTH = 16;
	localparam DEFAULT_BUS2_WIDTH = 6;
	localparam DEFAULT_BUS3_WIDTH = 8;
	localparam DEFAULT_BUS4_WIDTH = 16;
	localparam DEFAULT_BUS5_WIDTH = 6;
	localparam DEFAULT_BUS6_WIDTH = 6;
	localparam DEFAULT_BUS7_WIDTH = 16;
	localparam DEFAULT_BUS8_WIDTH = 8;
	input jtdi;
	input jtck;
	input jrstn;
	input [1:0] jscan;
	input jshift;
	input jupdate;
	output [1:0] jtdo;
	input trig_clk;
	input [DEFAULT_NON_BUS_NODE_NUM-1:0] non_bus_din;
	input [DEFAULT_BUS_NODE_NUM-1:0] bus_din;
	output wt_ce;
	output wt_en;
	output [15:0] wt_addr;

	cwc_top #(.BUS1_WIDTH(DEFAULT_BUS1_WIDTH), .BUS2_WIDTH(DEFAULT_BUS2_WIDTH), .BUS3_WIDTH(DEFAULT_BUS3_WIDTH), .BUS4_WIDTH(DEFAULT_BUS4_WIDTH), .BUS5_WIDTH(DEFAULT_BUS5_WIDTH), .BUS6_WIDTH(DEFAULT_BUS6_WIDTH), .BUS7_WIDTH(DEFAULT_BUS7_WIDTH), .BUS8_WIDTH(DEFAULT_BUS8_WIDTH), .CTRL_REG_LEN(DEFAULT_CTRL_REG_LEN), .STAT_REG_LEN(DEFAULT_STAT_REG_LEN), .STOP_LEN(DEFAULT_STOP_LEN), .NON_BUS_NODE_NUM(DEFAULT_NON_BUS_NODE_NUM), .BUS_NODE_NUM(DEFAULT_BUS_NODE_NUM), .BUS_NUM(DEFAULT_BUS_NUM))
	 wrapper_cwc_top(
		.jtdi(jtdi),
		.jtck(jtck),
		.jrstn(jrstn),
		.jscan(jscan),
		.jshift(jshift),
		.jupdate(jupdate),
		.jtdo(jtdo),
		.non_bus_din(non_bus_din),
		.bus_din(bus_din),
		.trig_clk(trig_clk),
		.wt_ce(wt_ce),
		.wt_en(wt_en),
		.wt_addr(wt_addr)
	);
endmodule


