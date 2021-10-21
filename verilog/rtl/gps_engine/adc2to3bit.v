// File two2threebit_adcdata_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
// vhd2vl settings:
//  * Verilog Module Declaration Style: 1995

// vhd2vl is Free (libre) Software:
//   Copyright (C) 2001 Vincenzo Liguori - Ocean Logic Pty Ltd
//     http://www.ocean-logic.com
//   Modifications Copyright (C) 2006 Mark Gonzales - PMC Sierra Inc
//   Modifications (C) 2010 Shankar Giri
//   Modifications Copyright (C) 2002, 2005, 2008-2010 Larry Doolittle - LBNL
//     http://doolittle.icarus.com/~larry/vhd2vl/
//
//   vhd2vl comes with ABSOLUTELY NO WARRANTY.  Always check the resulting
//   Verilog for correctness, ideally with a formal verification tool.
//
//   You are welcome to redistribute vhd2vl under certain conditions.
//   See the license (GPLv2) file included with the source for details.

// The result of translation follows.  Its copyright status should be
// considered unchanged from the original VHDL.

//
// VHDL Architecture gps_may24_parallel_nov19.two2threebit_adcdata.bhv
//
// no timescale needed
`timescale 1ns / 1ps
module two2threebit_adcdata_bhv(
reset,
clk,
adc2bit,
adc3bit
);

input reset, clk;
input [1:0] adc2bit;
output [2:0] adc3bit;

wire reset;
wire clk;
wire [1:0] adc2bit;
reg [2:0] adc3bit;



  always @(negedge reset or negedge clk) begin
    if(reset == 1'b 0) begin
      adc3bit <= 3'b 000;
    end else begin
      case(adc2bit)
      2'b 00 : begin
        adc3bit <= 3'b 001;
      end
      2'b 01 : begin
        adc3bit <= 3'b 011;
      end
      2'b 10 : begin
        adc3bit <= 3'b 101;
      end
      2'b 11 : begin
        adc3bit <= 3'b 111;
      end
      default : begin
        adc3bit <= 3'b 000;
      end
      endcase
    end
  end


endmodule
