//------------------------------------------------------------
// File: router_scoreboard_fifo.sv
// Purpose: Scoreboard using TLM Analysis FIFOs (Lab 9D)
//------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

//------------------------------------------------------------
// Class: router_scoreboard_fifo
//------------------------------------------------------------
class router_scoreboard_fifo extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard_fifo)

  //------------------------------------------------------------
  // Analysis FIFOs
  //------------------------------------------------------------
  uvm_tlm_analysis_fifo #(yapp_packet)      yapp_fifo;
  uvm_tlm_analysis_fifo #(channel_packet)   ch_fifo[3];
  uvm_tlm_analysis_fifo #(hbus_transaction) hbus_fifo;

  //------------------------------------------------------------
  // Router control/status
  //------------------------------------------------------------
  bit router_en;
  int max_pkt_size;

  //------------------------------------------------------------
  // Counters
  //------------------------------------------------------------
  int packets_in, compare_ok, compare_fail;
  int dropped_en, dropped_addr, dropped_size;

  //------------------------------------------------------------
  // Constructor
  //------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //------------------------------------------------------------
  // Build Phase
  //------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    yapp_fifo = new("yapp_fifo", this);
    hbus_fifo = new("hbus_fifo", this);
    foreach (ch_fifo[i])
      ch_fifo[i] = new($sformatf("ch_fifo[%0d]", i), this);
  endfunction

  //------------------------------------------------------------
  // Run Phase - main compare & HBUS monitor
  //------------------------------------------------------------
  task run_phase(uvm_phase phase);
    yapp_packet yp;
    channel_packet cp;
    hbus_transaction ht;

    fork
      // HBUS configuration monitor
      forever begin
        hbus_fifo.get(ht);
        if (ht.hwr_rd == 1) begin
          case (ht.haddr)
            'h1000: max_pkt_size = ht.hdata;
            'h1001: router_en    = ht.hdata[0];
          endcase
        end
      end

      // Compare loop
      forever begin
        yapp_fifo.get(yp);
        packets_in++;

        if (!router_en) begin
          dropped_en++;
          continue;
        end

        if (yp.addr > 2) begin
          dropped_addr++;
          continue;
        end

        if (yp.payload.size() > max_pkt_size) begin
          dropped_size++;
          continue;
        end

        ch_fifo[yp.addr].get(cp);

        if (compare_simple(yp, cp))
          compare_ok++;
        else
          compare_fail++;
      end
    join_none
  endtask

  //------------------------------------------------------------
  // Helper: compare_simple
  //------------------------------------------------------------
  function bit compare_simple(yapp_packet yp, channel_packet cp);
    if (yp.addr != cp.addr) return 0;
    if (yp.length != cp.length) return 0;
    foreach (yp.payload[i])
      if (yp.payload[i] != cp.payload[i]) return 0;
    if (yp.parity != cp.parity) return 0;
    return 1;
  endfunction

  //------------------------------------------------------------
  // Check Phase
  //------------------------------------------------------------
  function void check_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Checking FIFO Scoreboard status", UVM_LOW)
    if (yapp_fifo.is_empty() &&
        ch_fifo[0].is_empty() &&
        ch_fifo[1].is_empty() &&
        ch_fifo[2].is_empty() &&
        hbus_fifo.is_empty())
      `uvm_info(get_type_name(), "All FIFOs empty - OK", UVM_LOW)
    else
      `uvm_error(get_type_name(), "Some FIFOs not empty at end of sim")
  endfunction

  //------------------------------------------------------------
  // Report Phase
  //------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "=== Router Scoreboard FIFO Summary ===", UVM_NONE)
    `uvm_info(get_type_name(),
      $sformatf(
        "Packets In=%0d OK=%0d FAIL=%0d Dropped(dis/en/size)=%0d/%0d/%0d",
        packets_in, compare_ok, compare_fail,
        dropped_addr, dropped_en, dropped_size),
      UVM_LOW)
  endfunction

endclass
