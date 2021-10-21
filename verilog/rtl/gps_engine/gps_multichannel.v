`timescale 1ns / 1ps
module gps_multichannel(
	mclr,
	mclk,
	adc2bit_i,
	adc2bit_q,
	codeout,
	epochrx,
	dll_sel,  //Going to be a GPIO
	select_qmaxim,
	wb_clk_i, wb_rst_i, wb_adr_i, wb_dat_i, wb_dat_o,
    wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o
);
input mclr;
input mclk;
input [1:0] adc2bit_i;
input [1:0] adc2bit_q;
output codeout;
input dll_sel;
output epochrx; //Can be given to logic analyzer
input select_qmaxim;

//wishbone signals
    input        wb_clk_i;     // master clock input
	input        wb_rst_i;     // synchronous active high reset
	input  [31:0] wb_adr_i;     // lower address bits
	input  [31:0] wb_dat_i;     // databus input
	output [31:0] wb_dat_o;     // databus output
	input        wb_we_i;      // write enable input
	input        wb_stb_i;     // stobe/core select signal
	input        wb_cyc_i;     // valid bus cycle input
	output       wb_ack_o;     // bus cycle acknowledge output

// Channel 1 GPS signals

wire mclr;
wire mclk;
wire [1:0] adc2bit_i;
wire [1:0] adc2bit_q;
wire dll_sel;
wire fll_enabl = 1'b 1;
wire costas_enabl = 1'b 1;
wire epochrx;
wire select_qmaxim;

wire ch1_select,ch2_select,ch3_select,ch4_select ;
wire ch5_select,ch6_select,ch7_select,ch8_select ;
wire ch1_wb_stb_i,ch2_wb_stb_i,ch3_wb_stb_i,ch4_wb_stb_i;
wire ch5_wb_stb_i,ch6_wb_stb_i,ch7_wb_stb_i,ch8_wb_stb_i;
wire ch1_wb_ack_o,ch2_wb_ack_o,ch3_wb_ack_o,ch4_wb_ack_o;
wire ch5_wb_ack_o,ch6_wb_ack_o,ch7_wb_ack_o,ch8_wb_ack_o;


   // Module Address Select Logic
   assign ch1_select = (wb_adr_i[15:8] == 8'h0A) ;
   assign ch2_select = (wb_adr_i[15:8] == 8'h0B) ;
   assign ch3_select = (wb_adr_i[15:8] == 8'h0C) ;
   assign ch4_select = (wb_adr_i[15:8] == 8'h0D) ;
   assign ch5_select = (wb_adr_i[15:8] == 8'h0E) ;
   assign ch6_select = (wb_adr_i[15:8] == 8'h0F) ;
   assign ch7_select = (wb_adr_i[15:8] == 8'h10) ;
   assign ch8_select = (wb_adr_i[15:8] == 8'h11) ;

   // Module STROBE Select based on Address Range
   assign ch1_wb_stb_i = (wb_stb_i && ch1_select) ;
   assign ch2_wb_stb_i = (wb_stb_i && ch2_select) ;
   assign ch3_wb_stb_i = (wb_stb_i && ch3_select) ;
   assign ch4_wb_stb_i = (wb_stb_i && ch4_select) ;
   assign ch5_wb_stb_i = (wb_stb_i && ch5_select) ;
   assign ch6_wb_stb_i = (wb_stb_i && ch6_select) ;
   assign ch7_wb_stb_i = (wb_stb_i && ch7_select) ;
   assign ch8_wb_stb_i = (wb_stb_i && ch8_select) ;

   assign wb_ack_o = ch1_wb_ack_o || ch2_wb_ack_o || ch3_wb_ack_o || ch4_wb_ack_o || ch5_wb_ack_o || ch6_wb_ack_o || ch7_wb_ack_o || ch8_wb_ack_o ; 

gps_single_channel ch1(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx),
	.codeout(codeout),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch1_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch1_wb_ack_o)
);



endmodule
