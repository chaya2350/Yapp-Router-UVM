/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
// import the UVM library
// include the UVM macros
import uvm_pkg::*; 
`include "uvm_macros.svh"

// import the YAPP package
import yapp_pkg::*;
import hbus_pkg::*;
import channel_pkg::*;
import clock_and_reset_pkg::*;

`include "router_mcsequencer.sv"
`include "router_mcseqs_lib.sv"
`include "router_tb.sv"
`include "router_test_lib.sv"


initial begin
yapp_vif_config::set(null,"*.tb.yapp.agent.*","vif",hw_top.in0);
hbus_vif_config::set(null,"*.tb.hbus.*","vif",hw_top.hb_in);
channel_vif_config::set(null,"*.tb.channel_0.*","vif",hw_top.c_in0);
channel_vif_config::set(null,"*.tb.channel_1.*","vif",hw_top.c_in1);
channel_vif_config::set(null,"*.tb.channel_2.*","vif",hw_top.c_in2);
clock_and_reset_vif_config::set(null,"*.tb.clock_and_reset*","vif",hw_top.cl_re_in);

run_test();
$finish;
end

// experiment with the copy, clone and compare UVM method
endmodule : tb_top
