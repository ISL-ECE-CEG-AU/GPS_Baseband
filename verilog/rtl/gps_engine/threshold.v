// File threshold_bhv.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
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
// threshold comparator block which performs the acquisition check.
// I/O signals
// ain,bin    --> latched Iprompt and Qprompt values coming from the accumulators
// res        --> clear signal
// aen        --> aquisition enable signal to perform acquisition check
// acq        --> acquisition bit
// car_change --> open loop carrier offset introducing signal
//-*******************************************************************
// no timescale needed
`timescale 1ns / 1ps
module threshold_bhv(
ain,
bin,
mclk,
res,
aen,
integmag,
acq8times,
acq,
thresh
);

input [19:0] ain, bin;
input [14:0] thresh;
input mclk, res, aen;
output [19:0] integmag;
output acq8times, acq;

wire [19:0] ain;
wire [19:0] bin;
wire mclk;
wire res;
wire aen;
wire [19:0] integmag;
reg acq8times;
wire acq;
wire [14:0] thresh; 


							 
reg [19:0] i_arm; 
reg [19:0] q_arm; 
reg [19:0] i_arm_by2; 
reg [19:0] q_arm_by2;
reg [3:0] confirm;
reg [3:0] thresh_m;
reg acq_temp;
reg [1:0] count_out;
reg [19:0] temp1;

  always @(negedge res or posedge aen) begin : P4
  //---pro 1
    reg [19:0] x, y;

    if(res == 1'b 0) begin
      x = {20{1'b0}};
      y = {20{1'b0}};
      i_arm <= {20{1'b0}};
      q_arm <= {20{1'b0}};
      i_arm_by2 <= {20{1'b0}};
      q_arm_by2 <= {20{1'b0}};
    end else begin
      if(ain[19] == 1'b 0) begin
        x = ain;
      end
      else begin
        x = {1'b 0,((( ~ain[19:0])) + 1'b 1)};
      end
      if(bin[19] == 1'b 0) begin
        y = bin;
      end
      else begin
        y = {1'b 0,((( ~bin[19:0])) + 1'b 1)};
        //---2's complement
      end
      i_arm <= x;
      q_arm <= y;
      i_arm_by2 <= {1'b 0,x[19:1]};
      //-----concatenation
      q_arm_by2 <= {1'b 0,y[19:1]};
      //-----concatenation
    end
  end

  always @(negedge res or posedge mclk) begin : P3
  //---pro 2
    reg [19:0] temp;

    if(res == 1'b 0) begin
      temp = {20{1'b0}};
      //		 acq_temp <= '0';
    end else begin
      if((i_arm > q_arm)) begin
        temp = i_arm + q_arm_by2;
      end
      else if((q_arm > i_arm)) begin
        temp = i_arm_by2 + q_arm;
      end
      temp1 <= temp;
      //				if temp > thresh then
      //		    		acq_temp <= '1';
      //	        	else
      //		    		acq_temp <= '0';
      //				end if;
    end
  end

  assign integmag = temp1;
  assign acq = acq_temp;
  always @(negedge res or posedge aen) begin : P2
  //---pro 3

    if(res == 1'b 0) begin
      confirm <= 4'b 0000;
    end else begin
      if(confirm < 4'b 1010) begin
        confirm <= confirm + 1'b 1;
      end
      else if(confirm == 4'b 1010) begin
        confirm <= 4'b 0000;
      end
    end
  end

  always @(negedge res or negedge aen) begin : P1
  //---pro 4

    if(res == 1'b 0) begin
      thresh_m <= 4'b 0000;
      acq8times <= 1'b 0;
      acq_temp <= 1'b 0;
      count_out <= 2'b 00;
    end else begin
      if(temp1 > thresh) begin
        count_out <= 2'b 00;
        acq_temp <= 1'b 1;
        if(thresh_m < 4'b 0011) begin
          thresh_m <= thresh_m + 1'b 1;
          acq8times <= 1'b 0;
          //	acq_temp <= '1' ;
        end
        else if(thresh_m == 4'b 0011) begin
          //and confirm = "1010" then --then
          acq8times <= 1'b 1;
          //	elsif thresh_m < "0010" and confirm > "0100"  then
          //		thresh_m <= "0000";
          //	elsif acq_temp = '0' then 
          // 		thresh_m <= "0000";  
        end
      end
      else if(temp1 < thresh && count_out < 2'b 11) begin
        count_out <= count_out + 1'b 1;
        thresh_m <= 4'b 0000;
      end
      else if(temp1 < thresh && count_out == 2'b 11) begin
        acq_temp <= 1'b 0;
        acq8times <= 1'b 0;
      end
    end
  end

    //process(res,aen)
  //begin				  
  //   if res = '0' then
  // 		thresh_m <= "0000";
  //		acq8times     <= '0'; 
  //  elsif aen'event and aen='1' then     			
  // 		if acq_temp = '1' and thresh_m < "1000" then
  //			thresh_m <= thresh_m + '1';
  //			acq8times     <= '0';
  //		elsif acq_temp = '1' and thresh_m = "1000" then --and confirm = "1010" then
  //	 			acq8times     <= '1'; 
  //		elsif thresh_m < "0010" and confirm > "0100"  then
  //			thresh_m <= "0000";
  //		elsif acq_temp = '0' then 
  //		  		thresh_m <= "0000";  
  //		end if;
  //	end if;
  //end process;

endmodule
