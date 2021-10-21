`timescale 1ns / 1ps
module wb_interface (
	wb_clk_i, wb_rst_i, wb_adr_i, wb_dat_i, wb_dat_o,
	wb_we_i, wb_stb_i, wb_cyc_i, wb_ack_o,
	code_frequency,
	carr_frequency,
	code_frequency_offset,
	carr_frequency_offset,
	acq_threshold,
	sine_lut,
	satellite_id,
	prompt_idata,
	prompt_qdata,
	late_idata,
	late_qdata,
	early_idata,
	early_qdata,
	intg_ready,
	acq_complete
);


// wishbone signals
input        wb_clk_i;     // master clock input
input        wb_rst_i;     // synchronous active high reset
input  [7:0] wb_adr_i;     // lower address bits
input  [31:0] wb_dat_i;     // databus input
output reg [31:0] wb_dat_o;     // databus output
input        wb_we_i;      // write enable input
input        wb_stb_i;     // stobe/core select signal
input        wb_cyc_i;     // valid bus cycle input
output       wb_ack_o;     // bus cycle acknowledge output
// GPS signals
output reg [29:0] code_frequency ;
output reg [29:0] carr_frequency ;
output reg [29:0] code_frequency_offset;
output reg [29:0] carr_frequency_offset;
output reg [14:0] acq_threshold;
output reg [23:0] sine_lut;
output reg [4:0]  satellite_id;
input [19:0] prompt_idata ;
input [19:0] prompt_qdata;
input [19:0] late_idata;
input [19:0] late_qdata;
input [19:0] early_idata;
input [19:0] early_qdata;
input intg_ready;
input acq_complete;

parameter CODE_FREQUENCY_REG_ADDR = 8'h00 ;
parameter CARR_FREQUENCY_REG_ADDR = 8'h04 ;
parameter CODE_FREQUENCY_OFFSET_REG_ADDR = 8'h08 ;
parameter CARR_FREQUENCY_OFFSET_REG_ADDR = 8'h0C ;
parameter ACQ_THRESHOLD_REG_ADDR = 8'h10;
parameter CONFG_REG_ADDR = 8'h14;
parameter PROMPT_IDATA_REG_ADDR = 8'h18;
parameter PROMPT_QDATA_REG_ADDR = 8'h1C;
parameter LATE_IDATA_REG_ADDR  = 8'h20;
parameter LATE_QDATA_REG_ADDR  = 8'h24;
parameter EARLY_IDATA_REG_ADDR = 8'h28;
parameter EARLY_QDATA_REG_ADDR = 8'h2C;
parameter STATUS_REG_ADDR      = 8'h30;

reg intg_ready_reg ;	
reg intg_ready_ff1 ,intg_ready_ff2 ,intg_ready_ff3 ;	
wire intg_ready_pulse ;

// generate wishbone signals
wire wb_wacc = wb_we_i & wb_ack_o;
// generate acknowledge output signal
//always @(posedge wb_clk_i)
	assign wb_ack_o = wb_cyc_i & wb_stb_i ;


always @(posedge wb_clk_i or negedge wb_rst_i)
	if (wb_rst_i == 1'b0)
	begin
		intg_ready_ff1 <= 1'b0 ;    
		intg_ready_ff2 <= 1'b0 ;    
		intg_ready_ff3 <= 1'b0 ;  
	end
	else
	begin
		intg_ready_ff1 <= intg_ready ;
		intg_ready_ff2 <= intg_ready_ff1 ;
		intg_ready_ff3 <= intg_ready_ff2 ;
	end 

assign intg_ready_pulse = (intg_ready_ff2 == 1'b0 & intg_ready_ff3 == 1'b1) ? 1'b1 : 1'b0 ;

	// generate registers
always @(posedge wb_clk_i or negedge wb_rst_i)
	if (wb_rst_i == 1'b0)
	begin
		code_frequency <= #1 30'h00000000;
		carr_frequency <= #1 30'h00000000;
		code_frequency_offset <= #1 30'h00000000;
		carr_frequency_offset <= #1 30'h00000000;
		acq_threshold <= #1 15'h0000;
		sine_lut <= #1 24'h000000;
		satellite_id <= #1 5'h00;
		intg_ready_reg <= #1 1'b0;
	end
	else begin
		if (wb_wacc) begin
			case (wb_adr_i) 
				CODE_FREQUENCY_REG_ADDR :  code_frequency <= #1 wb_dat_i[29:0];
				CARR_FREQUENCY_REG_ADDR :  carr_frequency <= #1 wb_dat_i[29:0];
				CODE_FREQUENCY_OFFSET_REG_ADDR :  code_frequency_offset <= #1 wb_dat_i[29:0];
				CARR_FREQUENCY_OFFSET_REG_ADDR :  carr_frequency_offset <= #1 wb_dat_i[29:0];
				ACQ_THRESHOLD_REG_ADDR :  acq_threshold <= #1 wb_dat_i[14:0];
				CONFG_REG_ADDR :  begin
					sine_lut <= #1 wb_dat_i[23:0];
					satellite_id <= #1 wb_dat_i[28:24];
				end
				STATUS_REG_ADDR :    intg_ready_reg <= #1 wb_dat_i[0];

				default: ;
			endcase
		end
		if (intg_ready_pulse == 1'b1) begin
		    intg_ready_reg <= 1'b1 ;
		end
	end


always @(posedge wb_clk_i or negedge wb_rst_i)
	if (wb_rst_i == 1'b0)
	begin
		wb_dat_o <= #1 32'h00000000;
	end
	else
	begin
		case (wb_adr_i) 
			PROMPT_IDATA_REG_ADDR : wb_dat_o <= #1 { {12{1'b0}},prompt_idata};
			PROMPT_QDATA_REG_ADDR : wb_dat_o <= #1 { {12{1'b0}},prompt_qdata};
			LATE_IDATA_REG_ADDR  : wb_dat_o <= #1 { {12{1'b0}},late_idata};
			LATE_QDATA_REG_ADDR  : wb_dat_o <= #1 { {12{1'b0}},late_qdata};
			EARLY_IDATA_REG_ADDR : wb_dat_o <= #1 { {12{1'b0}},early_idata};
			EARLY_QDATA_REG_ADDR : wb_dat_o <= #1 { {12{1'b0}},early_qdata};
			STATUS_REG_ADDR      : wb_dat_o <= #1 { {30{1'b0}},acq_complete,intg_ready_reg};  
			default: ;
		endcase
	end

endmodule

