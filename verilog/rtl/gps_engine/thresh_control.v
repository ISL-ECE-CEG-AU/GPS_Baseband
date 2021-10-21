// File thresh_control_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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

// no timescale needed
`timescale 1ns / 1ps
module thresh_control_bhv(
clk,
aen,
len,
res,
acq,
car_change
);

input clk;
input aen, len;
input res;
input acq;
output car_change;

wire clk;
wire aen;
wire len;
wire res;
wire acq;
reg car_change;


reg [31:0] count_temp;

 always @(posedge len or negedge res) begin
    if(res == 1'b 0) begin
      count_temp <= 0;
      car_change <= 1'b 0;
    end else begin
      if(acq == 1'b 0) begin
        if(count_temp == 2046) begin
          count_temp <= 0;
          car_change <= 1'b 1;
        end
        else if(count_temp < 2046) begin
          count_temp <= count_temp + 1;
          car_change <= 1'b 0;
        end
      end
      else if(acq == 1'b 1) begin
        car_change <= 1'b 0;
      end
    end
  end


endmodule
