/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;


import uvm_pkg::*;
`include "uvm_macros.svh"

import yapp_pkg::*;
import hbus_pkg::*;
import channel_pkg::*;
import clock_and_reset_pkg::*;

`include "router_mcsequencer.sv"
`include "router_mcseqs_lib.sv"
`include "router_tb.sv"
`include "router_test_lib.sv"


yapp_packet packet ;
int ok;

initial begin 
	yapp_vif_config::set(null, "uvm_test_top.tb.yapp.tx_agent.*", "vif", hw_top.in0);
	hbus_vif_config::set(null,"*.tb.hbus.*","vif",hw_top.hif);
	channel_vif_config::set(null,"*.tb.chan0.*" ,"vif", hw_top.ch0);
	channel_vif_config::set(null,"*.tb.chan1.*" ,"vif", hw_top.ch1);
	channel_vif_config::set(null,"*.tb.chan2.*" ,"vif", hw_top.ch2);
	clock_and_reset_vif_config::set(null,"*.tb.clock_and_reset*","vif",hw_top.clk_rst_if);
	//run_test("base_test");
run_test();
$finish;
end



endmodule : tb_top
