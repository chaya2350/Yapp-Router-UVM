/*-----------------------------------------------------------------
File name     : tb_top.sv
Description   : Lab09A - Router testbench top
-------------------------------------------------------------------*/

module tb_top;

import uvm_pkg::*;
`include "uvm_macros.svh"


import yapp_pkg::*;
import hbus_pkg::*;
import channel_pkg::*;
import clock_and_reset_pkg::*;
import router_module_pkg::*;


`include "router_mcsequencer.sv"
`include "router_mcseqs_lib.sv"
//`include "../sv/router_scoreboard.sv"  
`include "router_tb.sv"
`include "router_test_lib.sv"


yapp_packet packet;
router_scoreboard_fifo sb;
int ok;

initial begin
  // --------------------------------------------------------
  // Interface Configurations
  // --------------------------------------------------------
  yapp_vif_config::set(null, "uvm_test_top.tb.yapp.tx_agent.*", "vif", hw_top.in0);
  hbus_vif_config::set(null, "*.tb.hbus.*", "vif", hw_top.hif);
  channel_vif_config::set(null, "*.tb.chan0.*", "vif", hw_top.ch0);
  channel_vif_config::set(null, "*.tb.chan1.*", "vif", hw_top.ch1);
  channel_vif_config::set(null, "*.tb.chan2.*", "vif", hw_top.ch2);
  clock_and_reset_vif_config::set(null, "*.tb.clock_and_reset*", "vif", hw_top.clk_rst_if);

  // --------------------------------------------------------
  // Scoreboard creation
  // --------------------------------------------------------
  sb = router_scoreboard_fifo::type_id::create("sb", null);

  // --------------------------------------------------------
  // Start test
  // --------------------------------------------------------
  run_test();  // או run_test("base_test");
  $finish;
end

endmodule : tb_top
