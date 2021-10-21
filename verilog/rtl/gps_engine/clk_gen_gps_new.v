// File clk_gen_gps_new.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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

// copy contrlogicenable module into this module to do masking operation
// no timescale needed
`timescale 1ns / 1ps
module clk_gen_gps_new(
mclk,
mclr,
dll_sel,
nco_carrier_cos,
nco_carrier_sin,
nco_car_clk1p4m,
nco_cod_clk1p0m,
nco_cod_clk2p0m,
epclk00_clk20ms,
car_change1,
coffset_carr,
foffset_code,
tr_aen_clk1ms,
tr_len_clk1ms,
tr_accclr_clk1ms,
tr_epoclk_clk1ms,
tr_triggerclk,
tr_aen_clk20ms,
tr_len_clk20ms,
tr_accclr_clk20ms,
tr_epoclk_clk20ms,
tr_triggerclk20ms,
enable,
codcntrlenable_01,
count_reset,
startflag,
acq1,
freqword_cod2,
freqword_car,
sin_lut
);

// Below needs to be obtained from wishbone reg
input [29:0]freqword_cod2;
input [29:0]freqword_car;
input [23:0]sin_lut;


input mclk;
input mclr;
input dll_sel;

//NC
output [2:0] nco_carrier_cos;
output [2:0] nco_carrier_sin;
output nco_car_clk1p4m;
inout nco_cod_clk1p0m; //nco_cod_clk1p0m has been defined as inout and the same is used as reg, which is a syntax error
output nco_cod_clk2p0m;
output epclk00_clk20ms;
input car_change1;
input [29:0] coffset_carr;
input [29:0] foffset_code;
output tr_aen_clk1ms;
output tr_len_clk1ms;
output tr_accclr_clk1ms;
output tr_epoclk_clk1ms;
output tr_triggerclk;
output tr_aen_clk20ms;
output tr_len_clk20ms;
output tr_accclr_clk20ms;
output tr_epoclk_clk20ms;
output tr_triggerclk20ms;
input enable;
output codcntrlenable_01;
input count_reset;
output startflag;
input acq1;

wire mclk;
wire mclr;
wire dll_sel;

wire [2:0] nco_carrier_cos;
wire [2:0] nco_carrier_sin;
reg [2:0] nco_carrier_cos_new;
reg [2:0] nco_carrier_sin_new;
wire nco_car_clk1p4m;
wire nco_cod_clk1p0m;
reg nco_cod_clk1p0m_new;
wire nco_cod_clk2p0m;
wire epclk00_clk20ms;
wire car_change1;
wire [29:0] coffset_carr;
wire [29:0] foffset_code;
wire tr_aen_clk1ms;
wire tr_len_clk1ms;
wire tr_accclr_clk1ms;
wire tr_epoclk_clk1ms;
wire tr_triggerclk;
wire tr_aen_clk20ms;
wire tr_len_clk20ms;
wire tr_accclr_clk20ms;
wire tr_epoclk_clk20ms;
wire tr_triggerclk20ms;
wire enable;
reg codcntrlenable_01;
wire count_reset;
wire startflag;
wire acq1;
wire [29:0]freqword_cod2;
wire [29:0]freqword_car;
wire [23:0]sin_lut;

assign nco_cod_clk1p0m = nco_cod_clk1p0m_new;

// nco_car_clk1p4m
  // constant sin_table : sin_lut := ("001","010","010","001","101","110","110","101");
//	signal sinout,cosout	:   std_logic_vector(2 downto 0);
// nco_car_clk1p4m
// nco_cod_clk1p0m
//  signal accout_cod1    : std_logic_vector(29 downto 0);
//   signal newword_cod1   : std_logic_vector(29 downto 0);
//--constant freqword_cod1: std_logic_vector(29 downto 0):="001011011101010010010101000";--1.023MHz

// Below line commented because it is not used.
// parameter freqword_cod1 = 30'b 001011011101010010010101000;  //1.023MHz 


// nco_cod_clk1p0m
// nco_cod_clk2p0m
reg [29:0] accout_cod2;
reg [29:0] newword_cod2;  //signal nco_clk4p0m : std_logic;
//-constant freqword_cod2: std_logic_vector(29 downto 0):="010110111010100100101010001";--2.046MHz




// nco_cod_clk2p0m
wire acq2 = 1'b 1;
reg [10:0] counter_chec;
wire nco_cod_clk2p0m_sig;
reg len01_clk1ms;
reg aen01_clk1ms;
reg epoclk01_clk1ms;
reg accclr01_clk1ms; reg triggerclk;
reg len01_clk20ms;
reg aen01_clk20ms;
reg epoclk01_clk20ms;
reg accclr01_clk20ms;
reg trigger01_clk20ms;
reg start;
wire [4:0] counter_len;
wire [4:0] counter_aen;
wire [4:0] counter_epoclk;
wire [4:0] counter_acclr;
wire [4:0] counter_trigger;
reg [29:0] phase_car,newword_car,coffset_car,coffset2_car;
wire [29:0] coffset1_car;




  assign startflag = start;
  // nco_car_clk1p4m
  always @(negedge mclk or negedge mclr) begin : P8
  //--process 1

    if(mclr == 1'b 0) begin
      //    		p1     <= (others=>'0');
      phase_car <= {29{1'b0}};
    end else begin
      //  		p1   <= phase_car + newword_car;
      phase_car <= phase_car + newword_car;
    end
  end
  always @(phase_car[29:27]) begin
  case(phase_car[29:27])
  3'b000: begin
  nco_carrier_sin_new <= sin_lut[23:21];
  nco_carrier_cos_new <= sin_lut[17:15];
  end
  3'b001: begin
  nco_carrier_sin_new <= sin_lut[20:18];
  nco_carrier_cos_new <= sin_lut[14:12];
  end
  3'b010: begin
  nco_carrier_sin_new <= sin_lut[17:15];
  nco_carrier_cos_new <= sin_lut[11:9];
  end
  3'b011: begin
  nco_carrier_sin_new <= sin_lut[14:12];
  nco_carrier_cos_new <= sin_lut[8:6];
  end
  3'b100: begin
  nco_carrier_sin_new <= sin_lut[11:9];
  nco_carrier_cos_new <= sin_lut[5:3];
  end
  3'b101: begin
  nco_carrier_sin_new <= sin_lut[8:6];
  nco_carrier_cos_new <= sin_lut[2:0];
  end
  3'b110: begin
  nco_carrier_sin_new <= sin_lut[5:3];
  nco_carrier_cos_new <= sin_lut[23:21];
  end
  3'b111: begin
  nco_carrier_sin_new <= sin_lut[2:0];
  nco_carrier_cos_new <= sin_lut[20:18];
  end
  endcase
  end
  

  //p2<=not(p1);
  //p3<=not(p2);
  //p4<=not(p3);
  //phase_car<=not(p4);
  assign nco_carrier_sin = nco_carrier_sin_new;
  assign nco_carrier_cos = nco_carrier_cos_new;
  assign nco_car_clk1p4m = phase_car[29];
  
  always @(negedge mclr or posedge mclk) begin : P7
  //--process 2

    if(mclr == 1'b 0) begin
      newword_car <= freqword_car;
    end else begin
      newword_car <= freqword_car + coffset1_car;
      //-replaced coffset1_car by coffset_car
    end
  end

  always @(negedge mclr or posedge accclr01_clk1ms) begin : P6
  //--process 3

    if(mclr == 1'b 0) begin
      coffset2_car <= {29{1'b0}};
    end else begin
      if(acq1 == 1'b 1) begin
        coffset2_car <= coffset1_car + coffset_carr;
        // edit - fll (fine acquisition in range of 250Hz range) and costas (tracking less than 250Hz)
      end
      else begin
        if(car_change1 == 1'b 1) begin
          coffset2_car <= coffset1_car + coffset_carr;
          // edit - coarse acquisition in 500 Hz
        end
      end
    end
  end

  //upto this carrier related
  assign coffset1_car = count_reset == 1'b 0 ? coffset2_car : {29{1'b0}};
  
  always @(negedge mclr or posedge nco_cod_clk2p0m_sig) begin : P5
  //---process 4

    if(mclr == 1'b 0) begin
      nco_cod_clk1p0m_new <= 1'b0;
    end else begin
      nco_cod_clk1p0m_new <= ~nco_cod_clk1p0m_new;
    end
  end

  // nco_cod_clk2p0m
  always @(negedge mclr or posedge mclk) begin : P4
  //----process 5

    if(mclr == 1'b 0) begin
      accout_cod2 <= {29{1'b0}};
    end else begin
      accout_cod2 <= accout_cod2 + newword_cod2;
    end
  end

  assign nco_cod_clk2p0m =  ~accout_cod2[29];
  assign nco_cod_clk2p0m_sig =  ~accout_cod2[29];
  
  always @(negedge mclr or posedge accclr01_clk1ms) begin : P3
  //---process 6

    if(mclr == 1'b 0) begin
      newword_cod2 <= freqword_cod2;
    end else begin
      if(dll_sel == 1'b 1) begin
        newword_cod2 <= freqword_cod2 + foffset_code;
      end
      else if(dll_sel == 1'b 0) begin
        newword_cod2 <= freqword_cod2;
      end
    end
  end

  // nco_cod_clk2p0m
  // epoclk01_clk1ms
  
  always @(negedge mclr or posedge nco_cod_clk2p0m_sig) begin : P2
  //-process 7
    reg [10:0] counterout1, counterout2, counterout3, counterout4, counterout5;
    reg [16:0] counterout6, counterout7, counterout8, counterout9, counterout10;
    reg flag;

    if(mclr == 1'b 0) begin
      counterout1 = {1{1'b0}};
      counter_chec <= {11{1'b0}};
      len01_clk1ms <= 1'b 0;
      aen01_clk1ms <= 1'b 0;
      epoclk01_clk1ms <= 1'b 0;
      accclr01_clk1ms <= 1'b 0;
      triggerclk <= 1'b 0;
      codcntrlenable_01 <= 1'b 1;
      start <= 1'b 0;
      flag = 1'b 0;
    end else begin
      if(counterout1 == 11'b 11111111111) begin
        counterout1 = 11'b 00000000000;
      end
      else begin
        counterout1 = counterout1 + 1'b 1;
      end
      case(counterout1)
      11'b 11111111000 : begin
        //----******2040******------
        len01_clk1ms <= 1'b 1;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 0;
      end
      11'b 11111111001 : begin
        //----******2041******------
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 0;
      end
      11'b 11111111010 : begin
        //----******2042******------
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 1;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 0;
      end
      11'b 11111111011 : begin
        //----******2043******------
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 0;
      end
      11'b 11111111100 : begin
        //----******2044******------
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 1;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 0;
      end
      11'b 11111111101 : begin
        //----******2045******------
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 0;
      end
      11'b 11111111110 : begin
        //----******2046******------
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 1;
        triggerclk <= 1'b 0;
      end
      11'b 11111111111 : begin
        //----******2047******------
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 1;
        if(enable == 1'b 1) begin
          flag = 1'b 1;
        end
        else begin
          flag = 1'b 0;
        end
      end
      default : begin
        len01_clk1ms <= 1'b 0;
        aen01_clk1ms <= 1'b 0;
        epoclk01_clk1ms <= 1'b 0;
        accclr01_clk1ms <= 1'b 0;
        triggerclk <= 1'b 0;
        if(enable == 1'b 1 && flag == 1'b 1) begin
          start <= 1'b 1;
        end
        else begin
          start <= 1'b 0;
        end
      end
      endcase
    end
  end

  always @(negedge mclr or posedge nco_cod_clk2p0m_sig) begin : P1
  //-process 7
    reg [15:0] counter;

    if(mclr == 1'b 0) begin
      counter = {1{1'b0}};
      len01_clk20ms <= 1'b 0;
      aen01_clk20ms <= 1'b 0;
      epoclk01_clk20ms <= 1'b 0;
      accclr01_clk20ms <= 1'b 0;
      trigger01_clk20ms <= 1'b 0;
    end 
    else if(enable == 1'b 0) begin
      counter = {1{1'b0}};
      len01_clk20ms <= 1'b 0;
      aen01_clk20ms <= 1'b 0;
      epoclk01_clk20ms <= 1'b 0;
      accclr01_clk20ms <= 1'b 0;
      trigger01_clk20ms <= 1'b 0;
    end
    else if(start == 1'b 0) begin
      counter = {1{1'b0}};
      len01_clk20ms <= 1'b 0;
      aen01_clk20ms <= 1'b 0;
      epoclk01_clk20ms <= 1'b 0;
      accclr01_clk20ms <= 1'b 0;
      trigger01_clk20ms <= 1'b 0;
    end
    else begin
      if(counter == 16'b 1001111111111111) begin
        counter = 16'b 0000000000000000;
      end
      else begin
        counter = counter + 1'b 1;
      end
      case(counter)
      16'b 1001111111111000 : begin
        //----******40952******------
        len01_clk20ms <= 1'b 1;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 0;
      end
      16'b 1001111111111001 : begin
        //----******40953******------
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 0;
      end
      16'b 1001111111111010 : begin
        //----******40954******------
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 1;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 0;
      end
      16'b 1001111111111011 : begin
        //----******40955******------
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 0;
      end
      16'b 1001111111111100 : begin
        //----******40956******------
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 1;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 0;
      end
      16'b 1001111111111101 : begin
        //----******40957******------
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 0;
      end
      16'b 1001111111111110 : begin
        //----******40958******------
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 1;
        trigger01_clk20ms <= 1'b 0;
      end
      16'b 1001111111111111 : begin
        //----******40959******------
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 1;
      end
      default : begin
        len01_clk20ms <= 1'b 0;
        aen01_clk20ms <= 1'b 0;
        epoclk01_clk20ms <= 1'b 0;
        accclr01_clk20ms <= 1'b 0;
        trigger01_clk20ms <= 1'b 0;
      end
      endcase
    end
  end

  // epoclk01_clk1ms	  
  assign epclk00_clk20ms = 1'b 1;
  // Channel Selector
  assign tr_aen_clk1ms = aen01_clk1ms;
  assign tr_len_clk1ms = len01_clk1ms;
  assign tr_accclr_clk1ms = accclr01_clk1ms;
  assign tr_epoclk_clk1ms = epoclk01_clk1ms;
  assign tr_triggerclk = triggerclk;
  assign tr_len_clk20ms = len01_clk20ms;
  assign tr_aen_clk20ms = aen01_clk20ms;
  assign tr_epoclk_clk20ms = epoclk01_clk20ms;
  assign tr_accclr_clk20ms = accclr01_clk20ms;
  assign tr_triggerclk20ms = trigger01_clk20ms;

endmodule