class yapp_tx_monitor extends uvm_monitor;

  yapp_packet pkt;
  int num_pkt_col;
  virtual interface yapp_if vif;

  covergroup collected_pkts_len;
    pkt_len : coverpoint pkt.length {
    illegal_bins ZERO = {0};
    bins MIN = {1};
    bins MAX = {63};
    bins SMALL = {[2:10]};
    bins MEDIUM  = {[11:40]};
    bins LARGE = {[41:62]};
    }
    pkt_addr : coverpoint pkt.addr{
    bins ADDR[] = {[0:2]}; 
    illegal_bins ADDR_3 = {3};
    }

    pkt_parity : coverpoint pkt.parity_type {
    bins NO_ERR = {GOOD_PARITY};
    //bins ERR = {BAD_PARITY};
    }

    

    pkt_len_addr_parity : cross pkt_len , pkt_addr , pkt.parity;
    
  endgroup

  //TLM ports
  uvm_analysis_port #(yapp_packet) item_collected_port;

  `uvm_component_utils_begin(yapp_tx_monitor)
    `uvm_field_int(num_pkt_col, UVM_ALL_ON)
   `uvm_component_utils_end

  function new (string name , uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port",this);
    collected_pkts_len = new();
  endfunction: new

  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this, get_full_name(),"vif",vif))
      `uvm_error("NOVIF", {"Virtual interface must be set for:", get_full_name(), " .vif"})
  endfunction:connect_phase

  // UVM run() phase
  task run_phase(uvm_phase phase);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = yapp_packet::type_id::create("pkt", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join
     
      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      item_collected_port.write(pkt);
      num_pkt_col++;
      collected_pkts_len.sample();
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

endclass: yapp_tx_monitor
