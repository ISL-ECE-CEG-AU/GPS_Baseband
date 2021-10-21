// File accum_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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

// DESCRIPTION
// 20 bit accumulator used to accumulate 1 msec data (from I or 
// Q prompt (after carrier multiplication)multiplied by goldcode)
// to check threshold for acquition is reached.
// I/O signals
// clr,clk --> master rest and master clock signal 
// accclr  --> used to clear the accumulator every epoch(1 msec)  
// datain  --> 20 bit data input either from I or Q prompt 
// dataout --> 20 bit accumulated data output used to check acq 
// no timescale needed
`timescale 1ns / 1ps

module accum_bhv(
datain,
clk,
clr,
accclr,
datout
);

input [19:0] datain;
input clk, clr;
input accclr;
inout [19:0] datout;

wire [19:0] datain;
wire clk;
wire clr;
wire accclr;
wire [19:0] datout;
reg [19:0] dataout;

assign datout = dataout;


  always @(negedge clk or negedge clr or posedge accclr) begin
    if(clr == 1'b 0) begin
      dataout <= {20{1'b0}};
    end else if(accclr== 1'b1) begin
    	dataout <= {20{1'b0}};
    end else begin
      dataout <= dataout + datain;
    end
  end


endmodule


