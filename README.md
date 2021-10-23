GPS Baseband Chip
====================

Table of contents
=================

-  `Overview `
-  `RTL Implementation `
-  `RTL Verification `
-  `ASIC Implementation `

Overview
========
In this proposal, the entire GPS baseband functionality is realized using a combination of custom designed logic functionality GPS Engine (ASIC portion) and the on chip RISCV microprocessor to provide the complete position fix starting from the digitized IF input bits. The signal processing operations in the baseband comprise of dispreading and data demodulation performed on six identical channels followed by psuedo range, and position fix computation. The major part of the signal processing operations for the six channels are carried out in the GPS Engine and the low frequency control tasks and position fix computation tasks are carried out in the RISCV processor.

RTL Implementation
========
![caravel_based_img](https://user-images.githubusercontent.com/88964390/138535599-c008bcb2-fc9a-4cb0-b36b-a32f13a39cce.png)

The Caravel user_proj_example.v has eight instanciation of GPS channel and a I2C Master . The GPS Channel < write the functionality of gps channel> and the I2C Master is used to configure the GPS RF Front End chipset .

The following block diagram shows the internal blocks of single gps channel 
![gps_single_channel](https://user-images.githubusercontent.com/88964390/138535817-e26fe5bf-d545-4786-bf1d-8c33a29dbd9a.png)


1. `accumulator.v` - 20 bit accumulator 
2. `adc2to3bit.v` - Two to three bit mapping of the input data
3. `clk_gen_gps_new.v` - Module containing NCO for Carrier Generation and code clock generation
4. `codectrllogic.v`- Topmost module for generation of three versions of Goldcodes (Early,Late,Prompt)
5. `codegen.v` - Goldcode instantiation module
6. `goldcode.v`- Goldcode generation module based on the Satellite ID
7. `gps_multichannel.v` - Topmost Module containing 8 single channels and address decoding
8. `gps_single_channel.v` - Single channel module containing all module instantiations and Wishbone Interface
9. `signmag_twocomp_vv.v` - Sign Magnitude to Two's complement Conversion
10. `signmul.v` - 3 bit Sign Magnitude Number multiplier
11. `thresh_control.v` - Threshold check block to generate Carrier change pulse to invoke Doppler
12. `threshold.v` - Threshold check block to check whether the satellite is acquired or not
13. `track_intganddump.v` - Gold code multiplication with Integrate and dumping of 6 signals(3 - i and 3 - q)
14. `wb_interface.v` - Provides interface between 32-bit wiishbone bus and internal blocks . Through this wishbone interface , software can write and read memory mapped registers . The details of the wishbone registers is mentioned below .

Wishbone Registers
----------------
														
![image](https://user-images.githubusercontent.com/88964390/138536387-8cfaa180-f718-4f0a-a099-f3cd0043cd8c.png)
![image](https://user-images.githubusercontent.com/88964390/138536464-3aecfafd-0c37-43ba-8770-c287126a40ea.png)

Pin Description
----------------

![image](https://user-images.githubusercontent.com/88964390/138536527-58f45c08-142e-477e-9469-e3dce5b03dce.png)

Verification Environment 
========
The verification environment is shown in the following block diagram . A wishbone bus function model is used to create wishbone write and read transactions . The gps raw data is stored to a txt file and being used in the simulation environment .

![tb_img](https://user-images.githubusercontent.com/88964390/138536675-274e7149-0dc1-4842-97ce-edc6ff4be3a8.png)

Test Case Description
----------------
The following test cases were created and used to verify the gps channel at block level and system level 

- wb_bfm_carrier_part_test : <add test case description and the modules covered>
- wb_bfm_goldcode_test : <add test case description and the modules covered>

The testcase can be simulated by executing the following command 

.. code:: bash

     cd verilog/dv/wb_bfm_goldcode_test/
     chmod +x verify_gold.sh
     ./verify_gold.sh
	

ASIC Implementation  
========
	
The Physical implementation of single gps channel is carried out using openlane tool flow with the timing constraint of 50MHz .
	
![user_proj_example gds](https://user-images.githubusercontent.com/88964390/138538843-23880db7-d4f7-4e24-a8b3-6b2377f5d692.png)
	


	






