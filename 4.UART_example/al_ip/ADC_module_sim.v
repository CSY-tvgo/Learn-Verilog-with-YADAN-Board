// Verilog netlist created by TD v5.0.29524
// Thu Feb 24 20:16:32 2022

`timescale 1ns / 1ps
module ADC_module  // ADC_module.v(14)
  (
  clk,
  pd,
  s,
  soc,
  dout,
  eoc
  );

  input clk;  // ADC_module.v(18)
  input pd;  // ADC_module.v(19)
  input [2:0] s;  // ADC_module.v(20)
  input soc;  // ADC_module.v(21)
  output [11:0] dout;  // ADC_module.v(16)
  output eoc;  // ADC_module.v(15)


  EG_PHY_ADC #(
    .CH0("DISABLE"),
    .CH1("DISABLE"),
    .CH2("DISABLE"),
    .CH3("DISABLE"),
    .CH4("DISABLE"),
    .CH5("DISABLE"),
    .CH6("ENABLE"),
    .CH7("DISABLE"),
    .VREF("DISABLE"))
    adc (
    .clk(clk),
    .pd(pd),
    .s(s),
    .soc(soc),
    .dout(dout),
    .eoc(eoc));  // ADC_module.v(25)
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();

endmodule 

