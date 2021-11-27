# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper_empty/fixed_wrapper_cfgs.tcl
source $::env(CARAVEL_ROOT)/openlane/user_project_wrapper_empty/pdn.tcl

set script_dir [file dirname [file normalize [info script]]]

#source /home/gokul/projects/GPS_Baseband/caravel/openlane/user_project_wrapper_empty/fixed_wrapper_cfgs.tcl
#source $script_dir/../../caravel/openlane/user_project_wrapper_empty/fixed_wrapper_cfgs.tcl
#source $script_dir/fixed_wrapper_cfgs.tcl


set ::env(DESIGN_NAME) user_project_wrapper
#section end

# User Configurations

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "wb_clk_i"
set ::env(CLOCK_NET) "wb_clk_i"

set ::env(CLOCK_PERIOD) "10"

## Internal Macros
### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_proj_example.v \
	$script_dir/../../verilog/rtl/analog_macro.v \
	$script_dir/../../verilog/rtl/temp_digital.v \
	$script_dir/../../verilog/rtl/LVDT.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/user_proj_example.lef \
	$script_dir/../../lef/analog_macro.lef \
	$script_dir/../../lef/temp_digital.lef \
	$script_dir/../../lef/LVDT.lef "

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/user_proj_example.gds \
	$script_dir/../../gds/analog_macro.gds \
	$script_dir/../../gds/temp_digital.gds \
	$script_dir/../../gds/LVDT.gds "

set ::env(GLB_RT_MAXLAYER) 4

#set ::env(FP_PDN_CORE_RING) 1
set ::env(FP_PDN_CHECK_NODES) 0
#set ::env(FP_CORE_UTIL) 40
#set ::env(VDD_NETS) [list {vccd1} {vdda2}]
set ::env(VDD_NETS) [list {vccd1}]
#set ::env(GND_NETS) [list {vssd1} {vssa2}]
set ::env(GND_NETS) [list {vssd1}]
#set ::env(PL_TARGET_DENSITY) 0.1
set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2920 3520"

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
#set ::env(PL_RANDOM_GLB_PLACEMENT) 1
set ::env(SYNTH_STRATEGY) "AREA 0"
#set ::env(OPT_CLEAN) 0

set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

set ::env(FP_PDN_ENABLE_RAILS) 0
#set ::env(FP_PDN_ENABLE_MACROS_GRID) 0
#set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) 1
#set ::env(FP_PDN_MACRO_HOOKS) "\
	mprj vccd1 vssd1 \
	temp1 vdda2 vssa2"
#set ::env(GLB_RT_OBS) 
		

set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0

set ::env(KLAYOUT_XOR_GDS) 1
set ::env(KLAYOUT_XOR_XML) 1
set ::env(QUIT_ON_LVS_ERROR) 0
#set ::env(QUIT_ON_ILLEGAL_OVERLAPS) 0

#set ::env(LVS_CONNECT_BY_LABEL) 1
#set ::env(YOSYS_REWRITE_VERILOG) 1

