// File codegen_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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

//---- FILE NAME 		  : intganddump.vhd
// DESCRIPTION
// code generator block. generates the early prompt and late versions of 
// the code uses linear feedback shift register (LFSR) to generate the 
// PRBS sequence or the PN code. In this the module GOLDCODE is the goldcode 
// generator block. The generated code is then latched accordingly to generate
// the promp,early and later versions of the code.
// I/O signals
// res         --> clear signal
// ncoclock    --> 2.046 Mhz clk  from NCO for generating early and late codes
// clk         --> 1.023 Mhz clk used to generate code
// pnp         --> prompt versions of the code
// no timescale needed
`timescale 1ns / 1ps
module codegen_bhv(
res,
ncoclk,
codeclk,
car_change,
epochrx,
code_sel,
pne,
pnp,
pnl
);

input res, ncoclk, codeclk;
input car_change;
output epochrx;
input [4:0] code_sel;
output pne, pnp, pnl;

wire res;
wire ncoclk;
wire codeclk;
wire car_change;
wire epochrx;
wire [4:0] code_sel;
reg pne;
reg pnp;
reg pnl;


// hds interface_end
// hds interface_end
//component goldcode_allones is
//	port ( reset,clk: in std_logic;
//		 car_change : in std_logic;
//	 	 code_sel		: in std_logic_vector(4 downto 0);
//       	 goldcode :out std_logic );
//end component;
wire prncode1; reg code;
wire prncode;

  //	gold : goldcode_allones port map(res,codeclk,car_change,code_sel,prncode);	-- PN Code Generator
  goldcode gold(
      .reset(res),
    .clk(codeclk),
    .car_change(car_change),
    .epochrx(epochrx),
    .code_sel(code_sel),
    .goldcode(prncode));

  always @(negedge res or posedge codeclk) begin
    if(res == 1'b 0) begin
      code <= 1'b 0;
      pne <= 1'b 0;
    end else begin
      code <= prncode;
      pne <= prncode;
      //early only	
    end
  end

  always @(posedge ncoclk or negedge res) begin : P2
  // Prompt and Late versions

    if(res == 1'b 0) begin
      pnl <= 1'b 0;
    end else begin
      pnl <= code;
      //late only on rising edge of ncoclock
    end
  end

  always @(negedge ncoclk or negedge res) begin : P1
  // Prompt and Late versions

    if(res == 1'b 0) begin
      pnp <= 1'b 0;
    end else begin
      pnp <= code;
      //prompt only on falling edge of ncoclock
    end
  end


endmodule
