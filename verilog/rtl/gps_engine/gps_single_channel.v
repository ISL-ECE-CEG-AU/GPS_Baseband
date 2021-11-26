//---- FILE NAME 		  : gps_single_channel.v
//----**********************************************************************
// DESCRIPTION
// Complete Single channel Receiver.
// I/O SIGNALS
// mclk,mclr --> the master clock and master reset signal
// adcdata   --> the 3 bit data coming from transmitter (sign mag binary format)
// thrchk    --> the acquisition bit or the threshold check bit.
// car_change--> used to reset codcntrl block whenver openloop offset is given 
//               by means of delay counter
// ch_out    --> channel number where acq is done  
//----***********************************************************************
// no timescale needed
`timescale 1ns / 1ps
module gps_single_channel(
// Global inputs	
mclr,
mclk,
//Wishbone signals 
wb_clk_i, wb_rst_i, wb_adr_i, wb_dat_i, wb_dat_o,
wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o,
// RFFE ADC Inputs 
adc2bit_i,
adc2bit_q,

epochrx,
codeout,
dll_sel1,
fll_enabl,
costas_enabl,
select_qmaxim
);

input mclr, mclk;
input [1:0] adc2bit_i;
input [1:0] adc2bit_q; 
// wishbone signals
input        wb_clk_i;     // master clock input
input        wb_rst_i;     // synchronous active high reset
input  [7:0] wb_adr_i;     // lower address bits
input  [31:0] wb_dat_i;     // databus input
output [31:0] wb_dat_o;     // databus output
input        wb_we_i;      // write enable input
input        wb_stb_i;     // stobe/core select signal
input        wb_cyc_i;     // valid bus cycle input
output       wb_ack_o;     // bus cycle acknowledge output

output epochrx;
output codeout;
input dll_sel1;
input fll_enabl;
input costas_enabl;
input select_qmaxim; // to be given as GPIO

wire mclr;
wire mclk;
wire [1:0] adc2bit_i;
wire [1:0] adc2bit_q;
wire select_qmaxim; 
wire epochrx;
wire codeout;
wire dll_sel1;
wire fll_enabl;
wire costas_enabl;
wire irnss_sel;
wire [10:1] irnss_code;


wire [29:0] code_frequency ;
wire [29:0] carr_frequency ;
wire [29:0] code_frequency_offset;
wire [29:0] carr_frequency_offset;
wire [14:0] acq_threshold;
wire [23:0] sine_lut;
wire [4:0]  satellite_id;
wire [19:0] prompt_idata ;
wire [19:0] prompt_qdata;
wire [19:0] late_idata;
wire [19:0] late_qdata;
wire [19:0] early_idata;
wire [19:0] early_qdata;


wire pne1; wire pnp1; wire pnl1;


reg [29:0] coffset; 
wire [29:0] coffset_costas;


parameter coffsetvalue = 30'b 000000000000010110111100000101;  // 500 Hz  --- 93957 (for 30bit NCO)
// -- 500 Hz	---131868918--set now as 133748128-20khz

// ----- Doubt: How is this set?
//parameter coffset_reset = 27'b 111111111101001000100000000;  //"111110111000010100011110110"; -- 500 Hz	---131868918--set now as 133865528

//edit 6:multiplier o/p signals
wire [4:0] idat_cos;
wire [4:0] idat_sin; 
wire [4:0] qdat_cos;
wire [4:0] qdat_sin;  

//edit 7: converted multiplier o/p signals
wire [4:0] idat_cos_cov;
wire [4:0] idat_sin_cov;
wire [4:0] qdat_cos_cov;
wire [4:0] qdat_sin_cov;

//edit 8: added o/p signals
wire [4:0] idat_2;
wire [4:0] qdat_2;

//edit 9: actual iout and qout
wire [4:0] idat;
wire [4:0] qdat;


wire codctrlenable;
wire acq;

wire [19:0] dip_track;
wire [19:0] dqp_track;
wire [19:0] dil_track;
wire [19:0] dql_track;
wire [19:0] die_track;
wire [19:0] dqe_track;

wire [2:0] nco_carrier_cos;
wire [2:0] nco_carrier_sin;

//edit 10: 2 to 3 bit converter outputs
wire [2:0] adc3bit_i;
wire [2:0] adc3bit_q;
wire [2:0] adc3bit_qsel;

reg enable = 1'b 0;
reg sat_change;

wire nco_car_clk1p4m;
wire nco_cod_clk1p0m;
wire nco_cod_clk2p0m;
wire epclk00_clk20ms;
wire epoclk01_clk1ms;
wire accclr01_clk1ms;
wire len01_clk1ms;
wire aen01_clk1ms;
wire tr_triggerclk;
wire tr_aen_clk1ms;
wire tr_len_clk1ms;
wire tr_accclr_clk1ms;
wire tr_epoclk_clk1ms;
wire tr_triggerclk20ms;
wire tr_aen_clk20ms;
wire tr_len_clk20ms;
wire tr_accclr_clk20ms;
wire tr_epoclk_clk20ms;
wire acq8times; 
wire car_change; 
wire fll_enable; 
wire dll_enable; 
reg [5:0] counter_carrier;
reg [9:0] counter_data;  
reg count_reset = 1'b 0;
wire [19:0] integmag;
wire start; 
wire [4:0] satellite_id2;
wire [4:0] satellite_id1;

  assign fll_enable = acq & fll_enabl;
  assign dll_enable = dll_sel1 & acq;
  assign codeout = pnp1;
  assign prompt_idata = dip_track;
  assign prompt_qdata = dqp_track;
  assign early_idata = die_track;
  assign early_qdata = dqe_track;
  assign late_idata = dil_track;
  assign late_qdata = dql_track;


wb_interface wb_i (
	.wb_clk_i (wb_clk_i), 
	.wb_rst_i (wb_rst_i) , 
	.wb_adr_i (wb_adr_i) , 
	.wb_dat_i (wb_dat_i) , 
	.wb_dat_o (wb_dat_o) ,
	.wb_we_i (wb_we_i) , 
	.wb_stb_i (wb_stb_i) , 
	.wb_cyc_i (wb_cyc_i) , 
	.wb_ack_o (wb_ack_o),
  .code_frequency (code_frequency),
	.carr_frequency (carr_frequency),
	.code_frequency_offset (code_frequency_offset),
	.carr_frequency_offset (carr_frequency_offset),
	.acq_threshold (acq_threshold),
	.sine_lut (sine_lut),
	.satellite_id1 (satellite_id1),
  .satellite_id2 (satellite_id2),
	.prompt_idata (prompt_idata),
	.prompt_qdata (prompt_qdata),
	.late_idata (late_idata),
	.late_qdata (late_qdata),
	.early_idata (early_idata),
	.early_qdata (early_qdata),
	.intg_ready (tr_len_clk1ms),
	.acq_complete (acq),
  .irnss_sel(irnss_sel),
  .irnss_code(irnss_code),
  .sat_change(sat_change)
 ); 

// 2 to 3 bit conv for I-channel IF Input
two2threebit_adcdata_bhv adct2to3_i(
    .reset(mclr),
    .clk(mclk),
    .adc2bit(adc2bit_i),
    .adc3bit(adc3bit_i)
);

// 2 to 3 bit conv for Q-channel IF Input	 
two2threebit_adcdata_bhv adct2to3_q(
    .reset(mclr),
    .clk(mclk),
    .adc2bit(adc2bit_q),
    .adc3bit(adc3bit_q)
    );
	 
// Selecting quadrature input or zero
	
assign adc3bit_qsel = select_qmaxim == 1'b1 ? adc3bit_q : {3{1'b0}};

// Four Signed Multiplication Blocks

// Ixcos
  signmul_bhv signmul1(
    .A(adc3bit_i),
    .B(nco_carrier_cos),
    .clk(mclk),
    .clr(mclr),
    .X(idat_cos)
    );

//Ixsin
  signmul_bhv signmul2(
    .A(adc3bit_i),
    .B(nco_carrier_sin),
    .clk(mclk),
    .clr(mclr),
    .X(idat_sin)
    );

//Qxcos	 
  signmul_bhv signmul3(
    .A(adc3bit_qsel),
    .B(nco_carrier_cos),
    .clk(mclk),
    .clr(mclr),
    .X(qdat_cos)
    );

//Qxsin
  signmul_bhv signmul4(
    .A(adc3bit_qsel),
    .B(nco_carrier_sin),
    .clk(mclk),
    .clr(mclr),
    .X(qdat_sin)
    );
	 
	//Signed magintude to 2's complement
	signmag_twocomp_vv sigto2_1(idat_cos,idat_cos_cov);
	signmag_twocomp_vv sigto2_2(idat_sin,idat_sin_cov);
	signmag_twocomp_vv sigto2_3(qdat_cos,qdat_cos_cov);
	signmag_twocomp_vv sigto2_4(qdat_sin,qdat_sin_cov);
	
	//Adding the outputs of multiplier blocks

    // Q_final = Ixsin + Qxcos
	assign qdat_2 = qdat_cos_cov + idat_sin_cov; 

    // I_final = Ixcos - Qxsin
	assign idat_2 = idat_cos_cov + (~qdat_sin_cov + 5'b00001);
	
	// 2's complement to signed magnitude	
	signmag_twocomp_vv twostosig_1(idat_2,idat);
	signmag_twocomp_vv twostosig_2(qdat_2,qdat);

    // Track, Integrate and Dump Module
    // Includes Multiplication of Early, Late and Prompt Gold Codes with I_dat and Q_dat
    // 20bit conversion
    // 6 Accumulators

    track_intganddump_bhv tid(
        .clr(mclr),
        .clk(mclk),
        .acq(acq),
        .len(tr_len_clk1ms),
        .accclr(tr_accclr_clk1ms),
        .pne1(pne1),
        .pnp1(pnp1),
        .pnl1(pnl1),
        .idat(idat),
        .qdat(qdat),
        .dip_track(dip_track),
        .dqp_track(dqp_track),
        .dil_track(dil_track),
        .dql_track(dql_track),
        .die_track(die_track),
        .dqe_track(dqe_track)
    );

   // Threshold Check for Coarse Acquisition Mode

   threshold_bhv thr(
        .ain(dip_track),
        .bin(dqp_track),
        .mclk(mclk),
        .res(mclr),
        .aen(tr_aen_clk1ms),
        .acq8times(acq8times),              // ----- Doubt: How the Neyman-Pearson criterion is getting checked?
        .acq(acq),
        .thresh(acq_threshold)   // ----- Declare acq_threshold_reg in input
   );

   // Threshold Control Block
   // To check if all 2046 delay positions have been searched
   // If yes and no acq is obtained, change the carrier frequency (next Doppler search)

    thresh_control_bhv thrctrl(
        .clk(mclk),
        .aen(tr_aen_clk1ms),
        .len(tr_len_clk1ms),
        .res(mclr),
        .acq(acq),
        .car_change(car_change)
    );

    // Code Control Logic Module
    // Gold Code - Early, Late, Prompt Generation
    //

    codectrllogic_bhv ccl(
        .res(mclr),
        .nco_cod_clk1p0m(nco_cod_clk1p0m),
        .nco_cod_clk2p0m(nco_cod_clk2p0m),
        .acq(acq),
        .codctrlenable(codctrlenable),
        .car_change(car_change),
        .pne(pne1),
        .pnp(pnp1),
        .pnl(pnl1),
        .epochrx(epochrx),
        .code_sel(satellite_id),     // ----- Declare confg_reg_1 in input
        .epoch(tr_epoclk_clk1ms),
        .irnss_sel(irnss_sel),  //To be declared as inputs
        .irnss_code(irnss_code)
    );


    // Primary Clock Generator Module
    // NCO for Carrier Signals Sin/Cos
    // NCO for Code Clock
    // Other control clocks

    // ----- Doubts: Confirm whether DLL_sel can be used for wishbone write flag for DLL
    //               Wishbone write flag for FLL is not declared in clk_gen_gps_new (it is not getting used)

    clk_gen_gps_new clkgen(
        .mclk(mclk),
        .mclr(mclr),
        .dll_sel(dll_enable),            
        .nco_carrier_cos(nco_carrier_cos),
        .nco_carrier_sin(nco_carrier_sin),
        .nco_car_clk1p4m(nco_car_clk1p4m),
        .nco_cod_clk1p0m(nco_cod_clk1p0m),
        .nco_cod_clk2p0m(nco_cod_clk2p0m),
        .epclk00_clk20ms(epclk00_clk20ms),
        .car_change1(car_change),
        .coffset_carr(coffset),     
        .foffset_code(code_frequency_offset),
        .tr_aen_clk1ms(tr_aen_clk1ms),
        .tr_len_clk1ms(tr_len_clk1ms),
        .tr_accclr_clk1ms(tr_accclr_clk1ms),
        .tr_epoclk_clk1ms(tr_epoclk_clk1ms),
        .tr_triggerclk(tr_triggerclk),
        .tr_aen_clk20ms(tr_aen_clk20ms),
        .tr_len_clk20ms(tr_len_clk20ms),
        .tr_accclr_clk20ms(tr_accclr_clk20ms),
        .tr_epoclk_clk20ms(tr_epoclk_clk20ms),
        .tr_triggerclk20ms(tr_triggerclk20ms),
        .enable(enable),
        .codcntrlenable_01(codctrlenable),
        .count_reset(count_reset),
        .startflag(start),
        .acq1(acq),
        .freqword_cod2(code_frequency),            
        .freqword_car(carr_frequency),             
        .sin_lut(sine_lut)
    );

always @(negedge mclr or negedge tr_epoclk_clk1ms or posedge tr_accclr_clk1ms) begin : P3
  //----process 5

    if(mclr == 1'b 0 ) begin
      coffset <= {30{1'b0}};
      count_reset <= 1'b 0;
    end else if(tr_accclr_clk1ms == 1'b 1) begin
      coffset <= {30{1'b0}};
      count_reset <= 1'b 0;
    end else begin
      if(acq == 1'b 0 && car_change == 1'b 1 && counter_carrier < 6'b 010100) begin
        //(40)101000(30)011110 --(60)111100if counter_carrier is less than 60--set now as 30				
        coffset <= coffsetvalue;
        count_reset <= 1'b 0;
      end
      else if(acq == 1'b 0 && car_change == 1'b 1 && counter_carrier == 6'b 010100) begin
        count_reset <= 1'b 1;
      end
      else if(acq == 1'b 0 && car_change == 1'b 0) begin
        coffset <= {30{1'b0}};
        count_reset <= 1'b 0;
        //coffset      <= coffsetvalue;
      end
      else if(acq == 1'b 1) begin
        //-coffset      <= (others => '0');		
        coffset <= carr_frequency_offset;
        count_reset <= 1'b 0;
        //coffset      <= value;
      end
    end
  end

  //
  always @(negedge mclr or posedge tr_aen_clk1ms) begin : P2
  //--process 6

    if(mclr == 1'b 0) begin
      counter_carrier <= {6{1'b0}};
    end else begin
      if(acq == 1'b 0 && car_change == 1'b 1 && counter_carrier < 6'b 010100) begin
        counter_carrier <= counter_carrier + 1'b 1;
      end
      else if(acq == 1'b 0 && car_change == 1'b 1 && counter_carrier == 6'b 010100) begin
        counter_carrier <= {6{1'b0}};
      end
    end
  end

  always @(negedge mclr or posedge tr_triggerclk) begin : P1
  //--process 7

    if(mclr == 1'b 0) begin
      counter_data <= {10{1'b0}};
      enable <= 1'b 0;
    end else if(acq == 1'b 0) begin
      counter_data <= {10{1'b0}};
      enable <= 1'b 0;
    end else begin
      if(fll_enable == 1'b 1 && counter_data < 10'b 0111111111) begin
        counter_data <= counter_data + 1'b 1;
      end
      if(fll_enable == 1'b 1 && counter_data == 10'b 0111111111) begin
        enable <= 1'b 1;
      end
    end
  end

  integer count_sat = 0;

  always @(posedge tr_epoclk_clk1ms or negedge mclr) begin
    if(mclr==1'b0) begin
      count_sat = 0 ;
      sat_change = 1'b0;
    end
    else begin
      if (acq==1'b0 && count_sat<40920) begin
        count_sat = count_sat + 1;
      end else if(acq==1'b0 && count_sat==40920) begin
        sat_change = ~sat_change ;
        count_sat = 0;
      end
    end
  end

  assign satellite_id = sat_change == 1'b0 ? satellite_id1 : satellite_id2;



















endmodule








