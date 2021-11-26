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


module temp_digital(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    input counter_clk,
    input shift_clk,
    input reset_12,
    output reg sr_out,
    output wire ref_clk,
    output wire c_clk);
    
    wire load_enable;  //Output of 13-bit counter must be 3
    wire count_20_reset; //Output of 13-bit counter must be 7
    wire sr_reset; //Output of 13-bit counter must be 31
    wire counter_sel; //13th bit of counter must be 1 to count and 0 to hold
    
    reg [19:0] count_20;
    reg [11:0] count_12;					//The highest measurable unknown frequency is Fxclk < 2^(36-c) where c is the number of 
    								//stages of the counter producing gate enable
    								//So, for a 12 bit counter, we can measure upto 16.7 MHz until the 20bit counter overflows
    reg [19:0] shift_20;
    
    assign load_enable = count_12==3 ? 1'b1 : 1'b0 ;
    assign count_20_reset = count_12==7 ? 1'b1 : 1'b0;
    assign counter_sel = count_12[11];				//The highest measurable unknown frequency is Fxclk < 2^(36-c) where c is the number of 
    								//stages of the counter producing gate enable
    assign sr_reset = count_12==31 ? 1'b1 : 1'b0;
    assign c_clk = counter_clk;
  
    
    always@ (posedge counter_clk or posedge count_20_reset) begin   //Process 20-bit counter
        if (count_20_reset == 1'b1) begin
        count_20 <= 0;
        end
        else begin
            if ((count_20 < 1048575)&&(counter_sel == 1'b1)) begin
            count_20 <= count_20 + 1;
            end
            else if ((count_20 == 1048575)&&(counter_sel == 1'b1))begin
            count_20 <= 0;
            end
        end
    end 
    
    always@ (posedge shift_clk or posedge sr_reset or posedge load_enable) begin  //Parallel In Serial Out Shift Register with Load Enable
        if (sr_reset == 1'b1) begin
            shift_20 <= 0;
        end
        else if (load_enable == 1'b1) begin
            shift_20 <= count_20;
            sr_out <= load_enable;
        end
        else begin
            sr_out <= shift_20[0];
            shift_20[18:0] <= shift_20[19:1];
            shift_20[19] <= 1'b0;
        end
    end
    assign ref_clk = shift_clk;
    always@ (posedge shift_clk or posedge reset_12) begin   //12 - bit counter
        if (reset_12 == 1'b1) begin
        count_12 <= 0;
        end
        else begin
            if(count_12 <4095) begin
                count_12 <= count_12 +1;
            end
            else if(count_12 == 4095) begin
                count_12 <= 0;
            end
        end
    end

    endmodule
`default_nettype wire
