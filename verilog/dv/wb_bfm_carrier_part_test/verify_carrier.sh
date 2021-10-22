# Designs in ../../rtl folder
# Testbench in this folder
# Requires iverilog and gtkwave as binary executables.

iverilog -o carrier_test.vvp ../../rtl/gps_engine/accumulator.v ../../rtl/gps_engine/adc2to3bit.v ../../rtl/gps_engine/clk_gen_gps_new.v ../../rtl/gps_engine/codectrllogic.v ../../rtl/gps_engine/codegen.v ../../rtl/gps_engine/goldcode.v ../../rtl/gps_engine/gps_multichannel.v ../../rtl/gps_engine/gps_single_channel.v ../../rtl/gps_engine/signmag_twocomp_vv.v ../../rtl/gps_engine/signmul.v ../../rtl/gps_engine/thresh_control.v ../../rtl/gps_engine/threshold.v ../../rtl/gps_engine/track_intganddump.v ../../rtl/gps_engine/wb_interface.v gps_engine_tb_carrier.v wb_master_model.v
vvp carrier_test.vvp
gtkwave gps_test_sine.vcd

