//============================================================
// router_module_pkg.sv
// Package for Router Module UVC
//============================================================

package router_module_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  import hbus_pkg::*;
  import yapp_pkg::*;
  import channel_pkg::*;

  // Include all files that belong to the router module UVC
  `include "router_reference.sv"
  //`include "router_scoreboard.sv"
  `include "router_scoreboard_fifo.sv"
  `include "router_module_env.sv"



endpackage : router_module_pkg

