//============================================================
// router_scoreboard.sv
//============================================================

class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)

  // Declare TLM analysis implementations
  `uvm_analysis_imp_decl(_yapp)
  `uvm_analysis_imp_decl(_ch0)
  `uvm_analysis_imp_decl(_ch1)
  `uvm_analysis_imp_decl(_ch2)

  // Analysis port instances
  uvm_analysis_imp_yapp#(yapp_packet, router_scoreboard) yapp_imp;
  uvm_analysis_imp_ch0#(channel_packet, router_scoreboard) ch0_imp;
  uvm_analysis_imp_ch1#(channel_packet, router_scoreboard) ch1_imp;
  uvm_analysis_imp_ch2#(channel_packet, router_scoreboard) ch2_imp;

  // Internal queues for comparison
  yapp_packet sb_queue0[$];
  yapp_packet sb_queue1[$];
  yapp_packet sb_queue2[$];

  // Counters
  int packets_in, in_dropped;
  int packets_ch0, compare_ch0, mismatch_ch0, dropped_ch0;
  int packets_ch1, compare_ch1, mismatch_ch1, dropped_ch1;
  int packets_ch2, compare_ch2, mismatch_ch2, dropped_ch2;

  // Comparison policy
  typedef enum { SIMPLE, UVM } comp_t;
  comp_t compare_policy = SIMPLE;
  bit ok;
  bit status = 1;

  // Constructor
  function new(string name = "router_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    yapp_imp = new("yapp_imp", this);
    ch0_imp  = new("ch0_imp", this);
    ch1_imp  = new("ch1_imp", this);
    ch2_imp  = new("ch2_imp", this);
  endfunction : new


  //============================================================
  // Helper compare functions
  //============================================================

  function bit compare_simple(yapp_packet yp, channel_packet cp);
    if (yp.addr != cp.addr) begin
      `uvm_error("COMPARE", $sformatf("Addr mismatch: YAPP=%0d CH=%0d", yp.addr, cp.addr))
      return 0;
    end
    if (yp.length != cp.length) begin
      `uvm_error("COMPARE", $sformatf("Length mismatch: YAPP=%0d CH=%0d", yp.length, cp.length))
      return 0;
    end
    foreach (yp.payload[i]) begin
      if (yp.payload[i] != cp.payload[i]) begin
        `uvm_error("COMPARE", $sformatf("Payload[%0d] mismatch: YAPP=%0d CH=%0d", i, yp.payload[i], cp.payload[i]))
        return 0;
      end
    end
    if (yp.parity != cp.parity) begin
      `uvm_error("COMPARE", $sformatf("Parity mismatch: YAPP=%0d CH=%0d", yp.parity, cp.parity))
      return 0;
    end
    return 1;
  endfunction : compare_simple


  function bit compare_uvm(yapp_packet yp, channel_packet cp, uvm_comparer comparer = null);
    if (comparer == null)
      comparer = new();

    status &= comparer.compare_field("addr", yp.addr, cp.addr, 2);
    status &= comparer.compare_field("length", yp.length, cp.length, 6);

    foreach (yp.payload[i]) begin
      string field_name;
      $sformat(field_name, "payload[%0d]", i);
      status &= comparer.compare_field(field_name, yp.payload[i], cp.payload[i], 8);
    end

    status &= comparer.compare_field("parity", yp.parity, cp.parity, 8);
    return status;
  endfunction : compare_uvm


  //============================================================
  // Write implementations
  //============================================================

  // Incoming YAPP packets
  virtual function void write_yapp(yapp_packet packet);
    yapp_packet pkt_clone;
    $cast(pkt_clone, packet.clone());
    packets_in++;

    case (pkt_clone.addr)
      0: sb_queue0.push_back(pkt_clone);
      1: sb_queue1.push_back(pkt_clone);
      2: sb_queue2.push_back(pkt_clone);
      default: begin
        `uvm_warning(get_type_name(), $sformatf("Packet dropped: bad address=%0d", pkt_clone.addr))
        in_dropped++;
      end
    endcase
  endfunction : write_yapp


  // Channel 0
  virtual function void write_ch0(channel_packet packet);
    handle_channel_compare(packet, sb_queue0, packets_ch0, compare_ch0, mismatch_ch0, dropped_ch0, 0);
  endfunction

  // Channel 1
  virtual function void write_ch1(channel_packet packet);
    handle_channel_compare(packet, sb_queue1, packets_ch1, compare_ch1, mismatch_ch1, dropped_ch1, 1);
  endfunction

  // Channel 2
  virtual function void write_ch2(channel_packet packet);
    handle_channel_compare(packet, sb_queue2, packets_ch2, compare_ch2, mismatch_ch2, dropped_ch2, 2);
  endfunction


  //============================================================
  // Core compare procedure (shared by all channels)
  //============================================================
  virtual function void handle_channel_compare(
      channel_packet p,
      ref yapp_packet q[$],
      inout int pkt_cnt,
      inout int cmp_cnt,
      inout int mis_cnt,
      inout int drp_cnt,
      input int channel_id);

    pkt_cnt++;

    if (q.size() == 0) begin
      `uvm_error(get_type_name(), $sformatf("Unexpected packet on channel %0d\n%s", channel_id, p.sprint()))
      drp_cnt++;
      return;
    end


    if (compare_policy == UVM)
      ok = compare_uvm(q[0], p);
    else
      ok = compare_simple(q[0], p);

    if (ok) begin
      void'(q.pop_front());
      cmp_cnt++;
      `uvm_info(get_type_name(), $sformatf("Packet match on channel %0d", channel_id), UVM_MEDIUM)
    end
    else begin
      mis_cnt++;
      `uvm_error(get_type_name(), $sformatf("Packet mismatch on channel %0d", channel_id))
    end
  endfunction : handle_channel_compare


  //============================================================
  // Phases
  //============================================================

  function void check_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Checking Router Scoreboard", UVM_LOW)
    if (sb_queue0.size() || sb_queue1.size() || sb_queue2.size())
      `uvm_error(get_type_name(),
        $sformatf("Scoreboard queues not empty: ch0=%0d ch1=%0d ch2=%0d",
          sb_queue0.size(), sb_queue1.size(), sb_queue2.size()))
    else
      `uvm_info(get_type_name(), "All queues empty, good job!", UVM_LOW)
  endfunction : check_phase


  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "=== Router Scoreboard Summary ===", UVM_NONE)
    `uvm_info(get_type_name(), $sformatf(
      "YAPP in=%0d dropped=%0d\nCh0: cmp=%0d mis=%0d drop=%0d\nCh1: cmp=%0d mis=%0d drop=%0d\nCh2: cmp=%0d mis=%0d drop=%0d",
      packets_in, in_dropped,
      compare_ch0, mismatch_ch0, dropped_ch0,
      compare_ch1, mismatch_ch1, dropped_ch1,
      compare_ch2, mismatch_ch2, dropped_ch2),
      UVM_LOW)
  endfunction : report_phase

endclass : router_scoreboard
