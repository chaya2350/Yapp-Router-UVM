/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

-uvmhome /tools/cadence/XCELIUM/24.09.011/tools/methodology/UVM/CDNS-1.1d

-timescale 1ns/1ns

//../sv/yapp_pkg.sv // compile YAPP package
//../sv/yapp_if.sv

//yapp
-incdir ../../yapp/sv
../../yapp/sv/yapp_pkg.sv
../../yapp/sv/yapp_if.sv

//channel 
-incdir ../../channel/sv
../../channel/sv/channel_pkg.sv
../../channel/sv/channel_if.sv

//hbus
-incdir ../../hbus/sv
../../hbus/sv/hbus_pkg.sv
../../hbus/sv/hbus_if.sv

//clock and reset
-incdir ../../clock_and_reset/sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv
../../clock_and_reset/sv/clock_and_reset_if.sv


clkgen.sv
../../router_rtl/yapp_router.sv
tb_top.sv // compile top level module
hw_top.sv

//+UVM_TESTNAME=simple_test 
+UVM_TESTNAME=router_mcseq_test 
+UVM_VERBOSITY=UVM_MEDIUM



