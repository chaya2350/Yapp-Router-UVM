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

 -uvmhome $UVMHOME
-timescale 1ns/1ns

// include directories
//*** add incdir include directories here

// compile files
//*** add compile files here

-incdir ../sv // include directory for sv files
../sv/yapp_pkg.sv // compile YAPP package
../sv/yapp_if.sv
clkgen.sv
../../router_rtl/yapp_router.sv
tb_top.sv // compile top level module
hw_top.sv
+UVM_TESTNAME=short_yapp_012
+UVM_VERBOSITY=UVM_HIGH


