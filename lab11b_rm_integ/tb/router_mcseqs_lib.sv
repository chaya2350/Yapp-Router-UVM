
class router_simple_mcseq extends uvm_sequence#(uvm_sequence_item);
 
  `uvm_object_utils(router_simple_mcseq)
  `uvm_declare_p_sequencer(router_mcsequencer)

  hbus_small_packet_seq        h_small;
  hbus_read_max_pkt_seq        h_read;
  hbus_set_default_regs_seq    h_large;

  yapp_012_seq                 y_seq;
  six_yapp_seq                 six_yapp;

  function new(string name = "router_simple_mcseq");
    super.new(name);
  endfunction : new

  // raise objection at start (sequence-level pre_body)
  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif

    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  // drop objection at end
  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif

    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

  // main sequence body
  virtual task body();
    `uvm_info(get_type_name(), "Starting router_simple_mcseq body", UVM_LOW)

    `uvm_do_on(h_small, p_sequencer.hbus_seqr)
    `uvm_do_on(h_read,  p_sequencer.hbus_seqr)




for(int i =0; i < 150; i++)
    `uvm_do_on(y_seq, p_sequencer.yapp_seqr)


    `uvm_do_on(h_large, p_sequencer.hbus_seqr)
    `uvm_do_on(h_read,  p_sequencer.hbus_seqr)

    `uvm_do_on(six_yapp, p_sequencer.yapp_seqr)

    `uvm_info(get_type_name(), "Finished router_simple_mcseq body", UVM_LOW)
  endtask : body

endclass : router_simple_mcseq
