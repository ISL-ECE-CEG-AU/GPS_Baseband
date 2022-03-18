// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    //inout vdda1,	// User area 1 3.3V supply
    //inout vdda2,	// User area 2 3.3V supply
    //inout vssa1,	// User area 1 analog ground
    //inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    //inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    //inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    //output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);

    wire [`MPRJ_IO_PADS-1:0] io_in;
    //wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire mclk ;
    wire mclr;
    wire [1:0] gps_data_i ;
    wire [1:0] gps_data_q ;
    wire dll_sel ;
    wire select_qmaxim ;
    wire [7:0] codeout ;
    wire [7:0] epochrx ;

    // IRQ
    assign irq = 3'b000;	// Unused


    //io_oeb is active low signal

    assign mclk = io_in[29] ;                           
    assign io_oeb[29]= 1'b1;

    assign gps_data_i[0] = io_in[30] ;                   
    assign io_oeb[30]= 1'b1;

    assign gps_data_i[1] = io_in[31] ;                     
    assign io_oeb[31]= 1'b1;

    assign gps_data_q[0] = io_in[32] ;                     
    assign io_oeb[32]= 1'b1;

    assign gps_data_q[1] = io_in[33] ;                     
    assign io_oeb[33]= 1'b1;

    assign dll_sel = io_in[34] ;
    assign io_oeb[34]= 1'b1;
    assign select_qmaxim = io_in[35] ;
    assign io_oeb[35]= 1'b1;
    assign la_data_out[10:3] = codeout ;
    assign la_data_out[18:11] = epochrx ;
    assign mclr = io_in[36];
    assign io_oeb[36]= 1'b1;

    assign io_oeb[8] = 1'b0;      //Digital Outputs of Analog Macro and LVDT
    assign io_oeb[9] = 1'b0;
    assign io_oeb[14] = 1'b0;
    assign io_oeb[15] = 1'b0;
    assign io_oeb[25] = 1'b0;
    assign io_oeb[26] = 1'b0;
    assign io_oeb[27] = 1'b0;

    assign io_oeb[10] = 1'b1;     //Digital Inputs of Analog Macro and LVDT
    assign io_oeb[12] = 1'b1;
    assign io_oeb[17] = 1'b1;
    assign io_oeb[18] = 1'b1;
    assign io_oeb[23] = 1'b1;
    assign io_oeb[24] = 1'b1;

    gps_multichannel gps_engine_i(
    .mclr (mclr),
    .mclk (mclk),
    .adc2bit_i (gps_data_i),
    .adc2bit_q (gps_data_q),
    .codeout(codeout),
    .epochrx(epochrx),
    .dll_sel (dll_sel),
    .select_qmaxim (select_qmaxim),
    .wb_clk_i (wb_clk_i), 
    .wb_rst_i (wb_rst_i), 
    .wb_adr_i (wbs_adr_i), 
    .wb_dat_i (wbs_dat_i), 
    .wb_dat_o (wbs_dat_o),
    .wb_we_i (wbs_we_i), 
    .wb_stb_i (wbs_stb_i), 
    .wb_cyc_i (wbs_cyc_i),
    .wb_ack_o (wbs_ack_o)

    );	    

endmodule

`default_nettype wire
