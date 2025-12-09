/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;


import uvm_pkg::*;
`include "uvm_macros.svh"

import yapp_pkg::*;
`include "router_tb.sv"
`include "router_test_lib.sv"

yapp_packet packet ;
int ok;

initial begin 
	run_test("base_test");
end



endmodule : top
