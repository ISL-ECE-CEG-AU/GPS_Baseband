`timescale 1ns / 1ps
module gps_multichannel(
	`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
    `endif

input mclr,
input mclk,
input [1:0] adc2bit_i,
input [1:0] adc2bit_q,
output [7:0] codeout,
input dll_sel,
output [7:0] epochrx, //Can be given to logic analyzer
input select_qmaxim,

//wishbone signals
    input        wb_clk_i,     // master clock input
	input        wb_rst_i,     // synchronous active high reset
	input  [31:0] wb_adr_i,     // lower address bits
	input  [31:0] wb_dat_i,     // databus input
	output reg [31:0] wb_dat_o,     // databus output
	input        wb_we_i,      // write enable input
	input        wb_stb_i,     // stobe/core select signal
	input        wb_cyc_i,     // valid bus cycle input
	output       wb_ack_o     // bus cycle acknowledge output
);


// Channel 1 GPS signals

wire mclr;
wire mclk;
wire [1:0] adc2bit_i;
wire [1:0] adc2bit_q;
wire dll_sel;
wire fll_enabl = 1'b 1;
wire costas_enabl = 1'b 1;
wire [7:0] epochrx;
wire [7:0] codeout;
wire select_qmaxim;

wire ch1_select,ch2_select,ch3_select,ch4_select ;
wire ch5_select,ch6_select,ch7_select,ch8_select ;
wire all_ch_select ;
wire ch1_wb_stb_i,ch2_wb_stb_i,ch3_wb_stb_i,ch4_wb_stb_i;
wire ch5_wb_stb_i,ch6_wb_stb_i,ch7_wb_stb_i,ch8_wb_stb_i;
wire ch1_wb_ack_o,ch2_wb_ack_o,ch3_wb_ack_o,ch4_wb_ack_o;
wire ch5_wb_ack_o,ch6_wb_ack_o,ch7_wb_ack_o,ch8_wb_ack_o;

wire [31:0] ch1_wb_dat_o, ch2_wb_dat_o, ch3_wb_dat_o, ch4_wb_dat_o;
wire [31:0] ch5_wb_dat_o, ch6_wb_dat_o, ch7_wb_dat_o, ch8_wb_dat_o;
reg [31:0] count32;

   // Module Address Select Logic
   assign ch1_select = (wb_adr_i[31:8] == 24'h00000A) ;
   assign ch2_select = (wb_adr_i[31:8] == 24'h00000B) ;
   assign ch3_select = (wb_adr_i[31:8] == 24'h00000C) ;
   assign ch4_select = (wb_adr_i[31:8] == 24'h00000D) ;
   assign ch5_select = (wb_adr_i[31:8] == 24'h00000E) ;
   assign ch6_select = (wb_adr_i[31:8] == 24'h00000F) ;
   assign ch7_select = (wb_adr_i[31:8] == 24'h000010) ;
   assign ch8_select = (wb_adr_i[31:8] == 24'h000011) ;

   assign all_ch_select = {ch8_select,ch7_select,ch6_select,ch5_select,ch4_select,ch3_select,ch2_select,ch1_select};

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
	.epochrx(epochrx[0]),
	.codeout(codeout[0]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch1_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch1_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch1_wb_ack_o),
	.count32(count32)
);

gps_single_channel ch2(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx[1]),
	.codeout(codeout[1]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch2_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch2_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch2_wb_ack_o),
	.count32(count32)
);
gps_single_channel ch3(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx[2]),
	.codeout(codeout[2]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch3_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch3_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch3_wb_ack_o),
	.count32(count32)
);
gps_single_channel ch4(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx[3]),
	.codeout(codeout[3]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch4_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch4_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch4_wb_ack_o),
	.count32(count32)
);
gps_single_channel ch5(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx[4]),
	.codeout(codeout[4]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch5_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch5_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch5_wb_ack_o),
	.count32(count32)
);
gps_single_channel ch6(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx[5]),
	.codeout(codeout[5]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch6_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch6_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch6_wb_ack_o),
	.count32(count32)
);
gps_single_channel ch7(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx[6]),
	.codeout(codeout[6]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch7_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch7_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch7_wb_ack_o),
	.count32(count32)
);
gps_single_channel ch8(
	.mclr(mclr),
	.mclk(mclk),
	.adc2bit_i(adc2bit_i),
	.adc2bit_q(adc2bit_q),
	.epochrx(epochrx[7]),
	.codeout(codeout[7]),
	.dll_sel1(dll_sel),
	.fll_enabl(fll_enabl),
	.costas_enabl(costas_enabl),
	.select_qmaxim(select_qmaxim),  
	.wb_clk_i(wb_clk_i),
	.wb_rst_i(wb_rst_i), 
	.wb_adr_i(wb_adr_i[7:0]), 
	.wb_dat_i(wb_dat_i), 
	.wb_dat_o(ch8_wb_dat_o),
	.wb_we_i(wb_we_i), 
	.wb_stb_i(ch8_wb_stb_i), 
	.wb_cyc_i(wb_cyc_i), 
	.wb_ack_o(ch8_wb_ack_o),
	.count32(count32)
);


always @ (all_ch_select,ch1_wb_dat_o,ch2_wb_dat_o,ch3_wb_dat_o,ch4_wb_dat_o,ch5_wb_dat_o,ch6_wb_dat_o,ch7_wb_dat_o,ch8_wb_dat_o)
begin
	case(all_ch_select)
		8'b00000001 : wb_dat_o <= ch1_wb_dat_o ;
		8'b00000010 : wb_dat_o <= ch2_wb_dat_o ;
		8'b00000100 : wb_dat_o <= ch3_wb_dat_o ;
		8'b00001000 : wb_dat_o <= ch4_wb_dat_o ;
		8'b00010000 : wb_dat_o <= ch5_wb_dat_o ;
		8'b00100000 : wb_dat_o <= ch6_wb_dat_o ;
		8'b01000000 : wb_dat_o <= ch7_wb_dat_o ;
		8'b10000000 : wb_dat_o <= ch8_wb_dat_o ;
		default     : wb_dat_o <= 32'd0 ;
	endcase
end

always @(negedge mclk or negedge mclr) begin
	if (mclr==1'b0) begin
		count32 <= 32'd0 ;
	end
	else begin
		count32 <= count32 + 32'd1 ;
	end
end

endmodule
