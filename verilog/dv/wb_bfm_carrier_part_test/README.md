## Testbench for verification of digital logic

## Testbench Description

This test is to verify the working of Carrier generation (cos and sine) at a correct frequency and proper integration and dump of the signals. 

The Sine Input Text file has the data of 1.405MHz sine wave sampled at 5.714285MHz Clock generated from Matlab. The Local Gold code generation has been forced to 1, so that we can exploit the effects of carrier generation alone. When the sine data is given as input to the RTL and the Local Carrier Frequency is set to 1.405MHz + 100Hz, the I-arm and Q-arm must contain on the the Difference Frequency component, which is 100Hz. 
Thus, this proves to us that our carrier generation is taken place for a proper frequency, multiplication has taken place correctly and Integrate and dump is also done correctly.
The waveform can be seen using the gtkwave viewer and the waves to be seen are `gps_engine_i.ch1.tid.dip_track` and `gps_engine_i.ch1.tid.dqp_track` (Can be seen as Analog for Better interpretation)

The design files reside in `GPS_Baseband/verilog/rtl/gps_engine` and are listed below.

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
14. `wb_interface.v` - Wishbone Interface containing Registers and flag declarations

Further explanation on the operation given in.

## Requirements

The testbench given here requires two programs.

1. [Icarus Iverilog](https://github.com/steveicarus/iverilog) - Please take a look at iverilog's github repository (link given above) for installation instructions.

2. [GTKWave Analyser](http://gtkwave.sourceforge.net/) - GTKWave can be installed easily on Ubuntu using `apt`, the package manager.

```
sudo apt-get install gtkwave
```

Once these programs are installed, you can open your terminal in this folder (`/verilog/dv/wb_bfm_carrier_part_test`) and run the following commands.

```
chmod +x verify_carrier.sh
./verify_carrier.sh
```

In the window opened by GTKWave, please click on `gps_engine_tb` that appears on the left pane.
It will list internal instantiations. Go through the hierarchy and select any signal which you want to view and click insert which will be present at the bottom.

Go Inside `gps_engine_i` --> `ch1` --> `tid` --> Click on it to list the waveforms in that module --> Click on `dip_track` and `dqp_track` and give insert --> Right Click on the Wavename in the waveform window and click `Data Format` --> `Click `Analog` --> Click `Interpolated` and you can see the Analog Waveform with correct frequency of 100Hz

