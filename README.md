Caravel User Project
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

- wb_interface : Provides interface between 32-bit wiishbone bus and internal blocks . Through this wishbone interface , software can write and read memory mapped registers . The details of the wishbone registers is mentioned below .
- adc2to3bit :
- signmul_bhv :
- clk_gen_gps_new :
- signmag_twocomp :
- codecontrollogic :
- threshold :
- threshold_ctl :
- track_intganddump :

Wishbone Registers
----------------
														
![image](https://user-images.githubusercontent.com/88964390/138536387-8cfaa180-f718-4f0a-a099-f3cd0043cd8c.png)
![image](https://user-images.githubusercontent.com/88964390/138536464-3aecfafd-0c37-43ba-8770-c287126a40ea.png)

Pin Description
----------------

![image](https://user-images.githubusercontent.com/88964390/138536527-58f45c08-142e-477e-9469-e3dce5b03dce.png)

Verification Environment 
========
The verification environment is shown in the following block diagram . A wishbone bus function model is used to create wishbone write and read transactions .
![tb_img](https://user-images.githubusercontent.com/88964390/138536675-274e7149-0dc1-4842-97ce-edc6ff4be3a8.png)


