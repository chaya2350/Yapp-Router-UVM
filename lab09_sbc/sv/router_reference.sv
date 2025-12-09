
class router_reference extends uvm_component;
  `uvm_component_utils(router_reference)

  `uvm_analysis_imp_decl(_yapp)
  `uvm_analysis_imp_decl(_hbus)

  uvm_analysis_imp_yapp #(yapp_packet, router_reference) yapp_imp;
  uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_imp;

  uvm_analysis_port #(yapp_packet) valid_yapp_port;

  int maxpktsize;
  bit router_en;

  int dropped_by_size;
  int dropped_by_enable;
  int dropped_by_addr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    yapp_imp        = new("yapp_imp", this);
    hbus_imp        = new("hbus_imp", this);
    valid_yapp_port = new("valid_yapp_port", this);

    maxpktsize      = 63;   // default reset value
    router_en       = 0;    // router disabled by default
    dropped_by_size = 0;
    dropped_by_enable = 0;
    dropped_by_addr = 0;
  endfunction

  function void write_hbus(hbus_transaction tr);
    case (tr.haddr)
      'h1000:  // ctrl_reg: bits[5:0] = maxpktsize
        maxpktsize = tr.hdata[5:0];
      'h1001:  // en_reg: bit[0] = router_en
        router_en = tr.hdata[0];
      default: ;
    endcase
    `uvm_info("ROUTER_REF", $sformatf("HBUS write: addr=0x%0h data=0x%0h (maxpktsize=%0d, router_en=%0b)",
               tr.haddr, tr.hdata, maxpktsize, router_en), UVM_MEDIUM)
  endfunction

  function void write_yapp(yapp_packet pkt);
    yapp_packet pkt_copy;
    bit valid = 1;
   if (pkt == null) begin
        `uvm_error("ROUTER_REF", "Received NULL yapp_packet in write_yapp")
        return;
    end
    

    if (!router_en) begin
      valid = 0;
      dropped_by_enable++;
    end
    else if (pkt.length > maxpktsize) begin
      valid = 0;
      dropped_by_size++;
    end
    else if (pkt.addr == 3) begin
      valid = 0;
      dropped_by_addr++;
    end

    if (valid) begin
    
     // pkt_copy = pkt.clone();
     pkt_copy = yapp_packet::type_id::create("pkt_copy", this);
     pkt_copy.copy(pkt);
      valid_yapp_port.write(pkt_copy);
      `uvm_info("ROUTER_REF", $sformatf("Forwarding valid packet (addr=%0d, len=%0d)",
                 pkt.addr, pkt.length), UVM_LOW)
    end
    else begin
      `uvm_info("ROUTER_REF", $sformatf("Dropped packet: en=%0b len=%0d max=%0d addr=%0d",
                 router_en, pkt.length, maxpktsize, pkt.addr), UVM_LOW)
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("ROUTER_REF_REPORT",
      $sformatf("Dropped packets - enable:%0d size:%0d addr:%0d",
                 dropped_by_enable, dropped_by_size, dropped_by_addr),
      UVM_NONE)
  endfunction
endclass