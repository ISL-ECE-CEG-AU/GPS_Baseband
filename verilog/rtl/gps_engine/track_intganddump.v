// File track_intganddump_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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
// integrate and dump filters. contains 6 accumulators for Iearly, Iprompt,
// Ilate, Qearly,Qprompt and Qlate. The accumulator outputs are latched every 
// epoch with epoch clock and then they all are cleared with accclr signal.
// First the code is xored with the multiplier output and then the result is
// sign extended to 14 bits which is fed into the accumulators.
// I/O signals
// clr,clk     --> clear and clock signals
// idat,qdat   --> Ichannel and Qchannel multiplier outputs
// pnp,pnl,pne --> early,prompt and late codes
// len         --> latch enable  pulses
// accclr      --> accumulator clear signal 
// dip,dil,die --> latched outputs of I channel accumulators
// dqp,dql,dqe --> latched outputs of Q channel accumulators
//-----**********************************************************************
// no timescale needed
`timescale 1ns / 1ps
module track_intganddump_bhv(
clr,
clk,
acq,
len,
accclr,
pne1,
pnp1,
pnl1,
idat,
qdat,
dip_track,
dqp_track,
dil_track,
dql_track,
die_track,
dqe_track,
);

input clr, clk, acq;
input len, accclr;
input pne1, pnp1, pnl1;
input [4:0] idat, qdat;
output [19:0] dip_track, dqp_track;
output [19:0] dil_track, dql_track;
output [19:0] die_track, dqe_track;

wire clr;
wire clk;
wire acq;
wire len;
wire accclr;
wire pne1;
wire pnp1;
wire pnl1;
wire [4:0] idat;
wire [4:0] qdat;
reg [19:0] dip_track;
reg [19:0] dqp_track;
reg [19:0] dil_track;
reg [19:0] dql_track;
reg [19:0] die_track;
reg [19:0] dqe_track;

wire ipr; wire qpr; wire iel; wire qel; wire ilt; wire qlt;
wire pnp; wire pne; wire pnl;
wire [19:0] aipr; wire [19:0] aqpr; wire [19:0] aiel; wire [19:0] aqel; wire [19:0] ailt; wire [19:0] aqlt;
wire [19:0] bipr; wire [19:0] bqpr; wire [19:0] biel; wire [19:0] bqel; wire [19:0] bilt; wire [19:0] bqlt;

// Assigning Gold Code
  assign pnp = pnp1;
  assign pne = pne1;
  assign pnl = pnl1;

// Multiplication with Gold Codes - Early, Late and Prompt - with I and Q
  assign iel = idat[4] ^ pne;
  assign ipr = idat[4] ^ pnp;
  assign ilt = idat[4] ^ pnl;
  assign qel = qdat[4] ^ pne;
  assign qpr = qdat[4] ^ pnp;
  assign qlt = qdat[4] ^ pnl;

// Conversion to 20 bit; 2's complement
  assign aiel = iel == 1'b 0 ? {16'b 0000000000000000,idat[3:0]} : {16'b 1111111111111111, ~((idat[3:0]))} + 1;
  assign aipr = ipr == 1'b 0 ? {16'b 0000000000000000,idat[3:0]} : {16'b 1111111111111111, ~((idat[3:0]))} + 1;
  assign ailt = ilt == 1'b 0 ? {16'b 0000000000000000,idat[3:0]} : {16'b 1111111111111111, ~((idat[3:0]))} + 1;
  assign aqel = qel == 1'b 0 ? {16'b 0000000000000000,qdat[3:0]} : {16'b 1111111111111111, ~((qdat[3:0]))} + 1;
  assign aqpr = qpr == 1'b 0 ? {16'b 0000000000000000,qdat[3:0]} : {16'b 1111111111111111, ~((qdat[3:0]))} + 1;
  assign aqlt = qlt == 1'b 0 ? {16'b 0000000000000000,qdat[3:0]} : {16'b 1111111111111111, ~((qdat[3:0]))} + 1;

// I-Early Acc
  accum_bhv acc1(
    aiel,
    clk,
    clr,
    accclr,
    biel);

// I-Prompt Acc
  accum_bhv acc2(
    aipr,
    clk,
    clr,
    accclr,
    bipr);

// I-Late Acc
  accum_bhv acc3(
    ailt,
    clk,
    clr,
    accclr,
    bilt);

// Q-Early Acc
  accum_bhv acc4(
    aqel,
    clk,
    clr,
    accclr,
    bqel);

// Q-Prompt Acc
  accum_bhv acc5(
    aqpr,
    clk,
    clr,
    accclr,
    bqpr);

// Q-Late Acc
  accum_bhv acc6(
    aqlt,
    clk,
    clr,
    accclr,
    bqlt);

// Acc Clear and Control
  always @(negedge clr or posedge len ) begin
    if(clr == 1'b 0) begin
      die_track <= {20{1'b0}};
      dip_track <= {20{1'b0}};
      dil_track <= {20{1'b0}};
      dqe_track <= {20{1'b0}};
      dqp_track <= {20{1'b0}};
      dql_track <= {20{1'b0}};
    //end else if(acq == 1'b 0) begin
      //die_track <= {20{1'b0}};
      //dip_track <= {20{1'b0}};
      //dil_track <= {20{1'b0}};
      //dqe_track <= {20{1'b0}};
      //dqp_track <= {20{1'b0}};
      //dql_track <= {20{1'b0}};
    end else begin
      die_track <= biel;
      dip_track <= bipr;
      dil_track <= bilt;
      dqe_track <= bqel;
      dqp_track <= bqpr;
      dql_track <= bqlt;
      
    end
  end

endmodule
