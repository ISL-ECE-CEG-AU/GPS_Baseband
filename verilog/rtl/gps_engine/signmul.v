// File signmul_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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
// sign mag multiplier used to multiply adcdata with sin and cos signals
// I/O signals
// A   	--> 3 bit sign magnitude transmitter o/p
// B   	--> 3 bit sign magnitude numbers (sine or cosine)
// clk,clr  --> clock and clear signals
// X        --> 5 bit sign magnitude output
//---************************************************************************
// no timescale needed
`timescale 1ns / 1ps
module signmul_bhv(
A,
B,
clk,
clr,
X
);

input [2:0] A, B;
input clk, clr;
output [4:0] X;

wire [2:0] A;
wire [2:0] B;
wire clk;
wire clr;
reg [4:0] X;


  always @(posedge clk or negedge clr) begin : P1
    reg [4:0] Xtemp; 

    if(clr == 1'b 0) begin
      Xtemp = {1{1'b0}};  
      X <= {5{1'b0}};
    end else begin
      if(A[1:0] == 2'b 00 || B[1:0] == 2'b 00) begin
        Xtemp = {1{1'b0}};
      end
      else begin
        Xtemp[4] <= (A[2] ^ B[2]);
        Xtemp[3:0] <= (A[1:0] * B[1:0]);
      end
      X <= Xtemp;
    end
  end


endmodule
