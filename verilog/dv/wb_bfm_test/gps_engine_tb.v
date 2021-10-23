`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.10.2021 22:37:56
// Design Name: 
// Module Name: gps_engine_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module gps_engine_tb( );
    
    parameter aw                    = 32 ;
    parameter dw                    = 32 ;
	parameter CH1_BASE_ADDR         = 32'h00000A00;
	parameter CH2_BASE_ADDR         = 32'h00000B00;
	parameter CODE_FREQUENCY_REG_ADDR = CH1_BASE_ADDR + 8'h00 ;
    parameter CARR_FREQUENCY_REG_ADDR = CH1_BASE_ADDR + 8'h04 ;
    parameter CODE_FREQUENCY_OFFSET_REG_ADDR = CH1_BASE_ADDR + 8'h08 ;
    parameter CARR_FREQUENCY_OFFSET_REG_ADDR = CH1_BASE_ADDR + 8'h0C ;
    parameter ACQ_THRESHOLD_REG_ADDR = CH1_BASE_ADDR + 8'h10;
    parameter CONFG_REG_ADDR = CH1_BASE_ADDR + 8'h14;
    parameter PROMPT_IDATA_REG_ADDR = CH1_BASE_ADDR + 8'h18;
    parameter PROMPT_QDATA_REG_ADDR = CH1_BASE_ADDR + 8'h1C;
    parameter LATE_IDATA_REG_ADDR  = CH1_BASE_ADDR + 8'h20;
    parameter LATE_QDATA_REG_ADDR  = CH1_BASE_ADDR + 8'h24;
    parameter EARLY_IDATA_REG_ADDR = CH1_BASE_ADDR + 8'h28;
    parameter EARLY_QDATA_REG_ADDR = CH1_BASE_ADDR + 8'h2C;
    parameter STATUS_REG_ADDR      = CH1_BASE_ADDR + 8'h30;     
    
    
    integer outfile0, count ; //file descriptors
    reg [1:0] gps_data_i ; 
    reg [1:0] gps_data_q ;
    reg gps_clk ;
    
    // wishbone signals
    reg 	      wb_clk_i ;
    reg 	      wb_rst_i ;
    wire [aw-1:0]   wb_adr_o ;
    wire [dw-1:0]   wb_dat_o ;
    wire [dw/8-1:0] wb_sel_o ;
    wire 	      wb_we_o ;
    wire 	      wb_cyc_o ;
    wire 	      wb_stb_o ;
    wire [2:0]      wb_cti_o ;
    wire [1:0]      wb_bte_o ;
    wire [dw-1:0]    wb_dat_i ;
    wire 	      wb_ack_i ;
    wire 	      wb_err_i ;
    wire 	      wb_rty_i ;

    //Accumulator outputs
    reg [31:0] dip;
    reg [31:0] dqp;
    reg [31:0] die;
    reg [31:0] dqe;
    reg [31:0] dil;
    reg [31:0] dql;
    reg [31:0] rs_reg;

    reg select_qmaxim;
    reg dll_sel;
    wire epochrx;
    wire codeout;
    reg mclr;


    
    
    
    initial begin
        //$dumpfile("gps_test.vcd");
        //$dumpvars(0, gps_engine_tb);
    outfile0=$fopen ("input.txt","r");
  // outfile0 = $fopenr ("input.txt");
        while (! $feof(outfile0)) begin
        @ (posedge gps_clk);
        count = $fscanf(outfile0,"%b\n",gps_data_i);
        //#10;
        end      
    $fclose(outfile0);
    #100;
    $stop;
    end
   
    initial begin 
    gps_clk = 1'b0 ;
    end
    
    always
    #87.5 gps_clk = ! gps_clk ; // Clock of 5.714 MHz
    
    always
    #5 wb_clk_i = ! wb_clk_i ;
    
    
    wb_master_model #(32,32) u0 (
    
		.clk(wb_clk_i),
		.rst(wb_rst_i),
		.adr(wb_adr_o),
		.din(wb_dat_i),
		.dout(wb_dat_o),
		.cyc(wb_cyc_o),
		.stb(wb_stb_o),
		.we(wb_we_o),
		.sel(wb_sel_o),
		.ack(wb_ack_i),
		.err(1'b0),
		.rty(1'b0)
	);

    gps_multichannel gps_engine_i (

    .mclr (mclr),
    .mclk (gps_clk ),
    .adc2bit_i (gps_data_i),
    .adc2bit_q (gps_data_q),
    .codeout(codeout),
    .epochrx(epochrx),
    .dll_sel(dll_sel),
    .select_qmaxim(select_qmaxim),
    .wb_clk_i (wb_clk_i), 
    .wb_rst_i (wb_rst_i), 
    .wb_adr_i (wb_adr_o), 
    .wb_dat_i (wb_dat_o), 
    .wb_dat_o (wb_dat_i),
    .wb_we_i (wb_we_o), 
    .wb_stb_i (wb_stb_o), 
    .wb_cyc_i (wb_cyc_o),
    .wb_ack_o (wb_ack_i)

    );	    
	
	initial begin
	$display("\nstatus: %t Testbench started\n\n", $time);
	// initially values
	wb_clk_i = 0;
    dll_sel = 1'b0;
    select_qmaxim = 1'b0;
    gps_data_i = 2'b00;
    gps_data_q = 2'b00;
    mclr = 1'b0;
	// reset system
	wb_rst_i = 1'b0; // negate reset
	
	repeat(4) @(posedge wb_clk_i);
	wb_rst_i = 1'b1; // negate reset
	$display("status: %t done reset", $time);
    mclr = 1'b1;

	@(posedge wb_clk_i);

	//
	// program core
	//

	// program internal registers
	u0.wb_write(0,CARR_FREQUENCY_REG_ADDR,32'h0FB82165); // load prescaler lo-byte 1.405MHz-1.5KHz
	u0.wb_write(0,CODE_FREQUENCY_REG_ADDR,32'h16EA4A8C); // load prescaler lo-byte 2.046MHz
    u0.wb_write(0,ACQ_THRESHOLD_REG_ADDR,32'h000003E8); //Threshold value given
    u0.wb_write(0,CONFG_REG_ADDR,32'h1409A1BE);  //Satellite ID 20 & Sine LUT
    u0.wb_write(0,CARR_FREQUENCY_OFFSET_REG_ADDR,32'h00000000);  //Offset words are set to zero
    u0.wb_write(0,CODE_FREQUENCY_OFFSET_REG_ADDR,32'h00000000);
    u0.wb_read(0,STATUS_REG_ADDR,rs_reg);
    repeat(4) @(posedge wb_clk_i);
    #100 mclr = 1'b0;
    #100 mclr = 1'b1;
        // check the bit
	 while(!rs_reg[0]) begin
	    u0.wb_read(0,STATUS_REG_ADDR,rs_reg); // poll it until it is zero
            repeat(4) @(posedge wb_clk_i);
     end
    u0.wb_read(0,PROMPT_IDATA_REG_ADDR,dip);
    repeat(4) @(posedge wb_clk_i);
    u0.wb_read(0,PROMPT_QDATA_REG_ADDR,dqp);
    repeat(4) @(posedge wb_clk_i);
    u0.wb_read(0,EARLY_IDATA_REG_ADDR,die);
    repeat(4) @(posedge wb_clk_i);
    u0.wb_read(0,EARLY_QDATA_REG_ADDR,dqe);
    repeat(4) @(posedge wb_clk_i);
    u0.wb_read(0,LATE_IDATA_REG_ADDR,dil);
    repeat(4) @(posedge wb_clk_i);
    u0.wb_read(0,LATE_QDATA_REG_ADDR,dql);
    repeat(4) @(posedge wb_clk_i);
    rs_reg[0] = ~rs_reg[0];
    u0.wb_write(0,STATUS_REG_ADDR,rs_reg);
    $display("WB_READ @ %t : dip = 0x%h ", $time,dip);
    $display("WB_READ @ %t : dqp = 0x%h ", $time,dqp);
    $display("WB_READ @ %t : die = 0x%h ", $time,die);
    $display("WB_READ @ %t : dqe = 0x%h ", $time,dqe);
    $display("WB_READ @ %t : dil = 0x%h ", $time,dil);
    $display("WB_READ @ %t : dql = 0x%h ", $time,dql);
    #1200000;
    $display("STATUS : TESTCASE PASSED");
    $finish;
	end
            



    
    
    
endmodule
