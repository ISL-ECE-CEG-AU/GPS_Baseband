// File codectrllogic_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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

// hds header_start
//---- FILE NAME 		  : codectrllogic.vhd
//----**********************************************************************
// DESCRIPTION
// control logic unit for code generation. it calls the code generator and the 
// 10 bit counter modules within it to generate the code and the control signals.
// if the acq bit is 0 the code clock is slipped to shift the code Tc/2 units. 
// if the acq bit is 1 the code clock is retained the same as it indicates
// the codes are acquired. 
// I/O signals
// res         --> clear signal
// twiceclock  --> 2.046 MHz clock to generate early and late code versions
// acq         --> acquisition bit
// accclr      --> accumulator clear signal
// pnp         --> prompt versions of the code
// epclk       --> epock clock
// aen         --> add enable signal to perform acquisition check
// len         --> latch enable signal to latch the accumulator outputs
// car_change  --> used to reset the codcontrollogic whenever openloop offset is given
//---*****************************************************************************
// no timescale needed
`timescale 1ns / 1ps
module codectrllogic_bhv(
res,
nco_cod_clk1p0m,
nco_cod_clk2p0m,
acq,
codctrlenable,
car_change,
pne,
pnp,
pnl,
epochrx,
code_sel,
epoch
);

input res, nco_cod_clk1p0m, nco_cod_clk2p0m, acq;
input codctrlenable;
input car_change;
output pne, pnp, pnl;
output epochrx;
input [4:0] code_sel;
input epoch;

wire res;
wire nco_cod_clk1p0m;
wire nco_cod_clk2p0m;
wire acq;
wire codctrlenable;
wire car_change;
wire pne;
wire pnp;
wire pnl;
wire epochrx;
wire [4:0] code_sel;
wire epoch;


// hds interface_end
// hds interface_end
reg clk; reg mask; wire epoch1;
wire clktemp; wire clktemp1; reg clktempt;

  codegen_bhv codgen(
      res,
    nco_cod_clk2p0m,
    clktempt,
    car_change,
    epochrx,
    code_sel,
    pne,
    pnp,
    pnl);

  assign epoch1 =  ~((epoch));
  always @(negedge res or posedge nco_cod_clk2p0m) begin
    if(res == 1'b 0) begin
      clk <= 1'b 0;
      clktempt <= 1'b 0;
    end else begin
      if(codctrlenable == 1'b 1) begin
        clk <=  ~clk;
        clktempt <= clktemp1;
      end
      else if(codctrlenable == 1'b 0) begin
        clk <= 1'b 0;
        clktempt <= 1'b 0;
      end
    end
  end

  always @(negedge res or posedge epoch1) begin
    if(res == 1'b 0) begin 
      mask <= 1'b 0;
    end else begin
      if(acq == 1'b 0) begin
        mask <=  ~mask;
      end
    end
  end

  assign clktemp1 = mask == 1'b 0 ? clk :  ~clk;
    //process(res,epoch,nco_cod_clk1p0m)
  //begin
  //if res = '0' then
  //clktemp <= '0';--	nco_cod_clk2p0m
  //elsif nco_cod_clk2p0m'event and nco_cod_clk2p0m='1' then
  //elsif acq = '0' and epoch = '1' then
  //clktemp <=  nco_cod_clk1p0m;
  //else
  //clktemp <= not nco_cod_clk1p0m;
  //end if;
  //end process;

endmodule
