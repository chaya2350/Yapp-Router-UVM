
class base_test extends uvm_test;

	`uvm_component_utils(base_test)
  router_tb tb;

	function new(string name, uvm_component parent);
		super.new(name,parent);
  endfunction

	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
	 uvm_config_int::set( this, "*", "recording_detail", 1);
	  tb = router_tb::type_id::create("tb", this);	  
	 `uvm_info("MSG","Test build phase executed",UVM_HIGH);
	endfunction:build_phase

	task run_phase (uvm_phase phase); 
          uvm_objection obj = phase.get_objection();
          obj.set_drain_time(this, 200ns);
        endtask:run_phase

	function void end_of_elaboration_phase(uvm_phase phase);
	  uvm_top.print_topology();
        endfunction: end_of_elaboration_phase

	function void check_phase (uvm_phase phase);
          check_config_usage();
        endfunction:check_phase

endclass:base_test

/*class short_packet_test extends base_test;
  `uvm_component_utils(short_packet_test)
  
  function new (string name , uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase","default_sequence", yapp_5_packets::get_type());
    super.build_phase(phase);

  endfunction:build_phase

endclass:short_packet_test

class set_config_test extends base_test;
  `uvm_component_utils(set_config_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    uvm_config_int::set(this, "tb.yapp.tx_agent", "is_active", UVM_PASSIVE);
    super.build_phase(phase);
  endfunction:build_phase

endclass:set_config_test

    
class incr_payload_test extends base_test;
 `uvm_component_utils(incr_payload_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
	                   "default_sequence",yapp_incr_payload_seq::type_id::get() );
    super.build_phase(phase);
  endfunction:build_phase

endclass:incr_payload_test
  

class exhaustive_seq_test extends base_test;
  `uvm_component_utils(exhaustive_seq_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
	                   "default_sequence",yapp_exhaustive_seq::type_id::get() );
    super.build_phase(phase);
  endfunction:build_phase

endclass:incr_payload_test


class short_yapp_012 extends base_test;
  `uvm_component_utils(short_yapp_012)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
	                   "default_sequence",yapp_012_seq::type_id::get() );
    super.build_phase(phase);
  endfunction:build_phase

endclass:short_yapp_012*/

class simple_test extends base_test;
  `uvm_component_utils(simple_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, 
          "tb.yapp.tx_agent.sequencer.run_phase",
	          "default_sequence",yapp_012_seq::type_id::get() );
   
    uvm_config_wrapper::set(this,
          "tb.chan*.rx_agent.sequencer.run_phase",
	        "default_sequence",channel_rx_resp_seq::type_id::get() );

    uvm_config_wrapper::set(this,
          "tb.clock_and_reset.agent.sequencer.run_phase",
	          "default_sequence",clk10_rst5_seq::type_id::get() );
   
    super.build_phase(phase);
  endfunction:build_phase


endclass:simple_test




class router_mcseq_test extends base_test;
  `uvm_component_utils(router_mcseq_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    //yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
	                   "default_sequence",clk10_rst5_seq::type_id::get());
    uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
	                   "default_sequence",router_simple_mcseq::type_id::get() );
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
	                   "default_sequence",channel_rx_resp_seq::type_id::get() );


    super.build_phase(phase);
  endfunction:build_phase

endclass:router_mcseq_test


class  uvm_reset_test extends base_test;
    uvm_reg_hw_reset_seq reset_seq;

  `uvm_component_utils(uvm_reset_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
	                   "default_sequence",clk10_rst5_seq::type_id::get());
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     super.run_phase(phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     reset_seq.model = tb.yapp_rm;
     reset_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
  endtask

endclass : uvm_reset_test


class  uvm_mem_walk_test extends base_test;
    uvm_mem_walk_seq  mem_walk_seq;

  `uvm_component_utils(uvm_mem_walk_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      mem_walk_seq = uvm_mem_walk_seq::type_id::create("mem_walk_seq");
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
	                   "default_sequence",clk10_rst5_seq::type_id::get());
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     super.run_phase(phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     mem_walk_seq.model = tb.yapp_rm;
     mem_walk_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
  endtask

endclass : uvm_mem_walk_test


class  reg_access_test  extends base_test;
    uvm_reg_hw_reset_seq  reset_seq;
    yapp_regs_c yapp_reg_c;

  `uvm_component_utils(reg_access_test )

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
	                   "default_sequence",clk10_rst5_seq::type_id::get());
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     uvm_status_e status;
     uvm_reg_data_t rdata;
     super.run_phase(phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     reset_seq.model = tb.yapp_rm;
     reset_seq.start(null);

  //en_reg - RW
     // כתיבה ב-frontdoor
     yapp_reg_c.en_reg.write(status, 8'hA5, UVM_FRONTDOOR);
     `uvm_info("REG_ACCESS", $sformatf("Wrote 0xA5 to en_reg (frontdoor)"), UVM_NONE)

     // קריאה ב-peek (backdoor)
     yapp_reg_c.en_reg.peek(status, rdata);
     `uvm_info("REG_ACCESS", $sformatf("Peeked en_reg, got 0x%0h", rdata), UVM_NONE)

     // כתיבה ב-poke (backdoor)
     yapp_reg_c.en_reg.poke(status, 8'h3C);
     `uvm_info("REG_ACCESS", $sformatf("Poked 0x3C to en_reg (backdoor)"), UVM_NONE)

     // קריאה ב-frontdoor
     yapp_reg_c.en_reg.read(status, rdata, UVM_FRONTDOOR);
     `uvm_info("REG_ACCESS", $sformatf("Read en_reg (frontdoor), got 0x%0h", rdata), UVM_NONE)

  //addr0_cnt_reg - router
     //  Poke a unique value (backdoor)
     yapp_reg_c.addr0_cnt_reg.poke(status, 8'h55);
     `uvm_info("REG_ACCESS", $sformatf("Poked 0x55 to addr0_cnt_reg (backdoor)"), UVM_NONE)

     // Front-door read and check the value matches
     yapp_reg_c.addr0_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
     `uvm_info("REG_ACCESS", $sformatf("Read addr0_cnt_reg (frontdoor), got 0x%0h", rdata), UVM_NONE)

     // Front-door write a new value (אמור להיכשל או להתעלם)
     yapp_reg_c.addr0_cnt_reg.write(status, 8'hAA, UVM_FRONTDOOR);
     `uvm_info("REG_ACCESS", "Tried to write 0xAA to addr0_cnt_reg (frontdoor, RO)", UVM_NONE)

     // Peek and check the DUT value has not changed
     yapp_reg_c.addr0_cnt_reg.peek(status, rdata);
     `uvm_info("REG_ACCESS", $sformatf("Peeked addr0_cnt_reg, got 0x%0h (should still be 0x55)", rdata), UVM_NONE)

     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
  endtask

  function void connect_phase(uvm_phase phase);
    yapp_reg_c = tb.yapp_rm.router_yapp_regs;
  endfunction : connect_phase

endclass : reg_access_test 


class reg_function_test extends base_test;
  uvm_reg_hw_reset_seq reset_seq;
  yapp_regs_c yapp_reg_c;

  yapp_tx_sequencer yapp_seqr;
  yapp_012_seq yapp_seq_inst;

  `uvm_component_utils(reg_function_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
    reset_seq = uvm_reg_hw_reset_seq::type_id::create("reset_seq");
    yapp_seq_inst = yapp_012_seq::type_id::create("yapp_seq_inst");
    
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
      "default_sequence", clk10_rst5_seq::type_id::get());
    
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
     "default_sequence", channel_rx_resp_seq::type_id::get());
    
    super.build_phase(phase);
  endfunction

  function void connect_phase(uvm_phase phase);
    yapp_reg_c = tb.yapp_rm.router_yapp_regs;
    yapp_seqr = tb.yapp.tx_agent.sequencer;
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_status_e status;
    uvm_reg_data_t rdata;

    super.run_phase(phase);
    phase.raise_objection(this, "Start reg_function_test");

    reset_seq.model = tb.yapp_rm;
    reset_seq.start(null);

    yapp_reg_c.en_reg.write(status, 8'h01, UVM_FRONTDOOR);
    yapp_reg_c.en_reg.read(status, rdata, UVM_FRONTDOOR);
    `uvm_info("REG_FUNC", $sformatf("en_reg = 0x%0h (expect 0x01)", rdata), UVM_MEDIUM)
    assert (rdata == 8'h01)
      else `uvm_error("ASSERT", $sformatf("en_reg mismatch: got 0x%0h expected 0x01", rdata))

    yapp_seq_inst.start(yapp_seqr);

    yapp_reg_c.addr0_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata == 8'h00)
      else `uvm_error("ASSERT", $sformatf("addr0_cnt_reg incremented unexpectedly: 0x%0h", rdata))

    yapp_reg_c.addr1_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata == 8'h00)
      else `uvm_error("ASSERT", $sformatf("addr1_cnt_reg incremented unexpectedly: 0x%0h", rdata))

    yapp_reg_c.addr2_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata == 8'h00)
      else `uvm_error("ASSERT", $sformatf("addr2_cnt_reg incremented unexpectedly: 0x%0h", rdata))

    yapp_reg_c.addr3_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata == 8'h00)
      else `uvm_error("ASSERT", $sformatf("addr3_cnt_reg incremented unexpectedly: 0x%0h", rdata))


    yapp_reg_c.en_reg.write(status, 8'hFF, UVM_FRONTDOOR);
    yapp_reg_c.en_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata == 8'hFF)
      else `uvm_error("ASSERT", $sformatf("en_reg mismatch after full enable: got 0x%0h", rdata))

    yapp_seq_inst.start(yapp_seqr);
    yapp_seq_inst.start(yapp_seqr);

    yapp_reg_c.addr0_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata > 0)
      else `uvm_error("ASSERT", "addr0_cnt_reg did not increment")

    yapp_reg_c.addr1_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata > 0)
      else `uvm_error("ASSERT", "addr1_cnt_reg did not increment")

    yapp_reg_c.addr2_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata > 0)
      else `uvm_error("ASSERT", "addr2_cnt_reg did not increment")

    yapp_reg_c.addr3_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata > 0)
      else `uvm_error("ASSERT", "addr3_cnt_reg did not increment")


    yapp_reg_c.parity_err_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata == 0)
      else `uvm_error("ASSERT", $sformatf("parity_err_cnt_reg not zero: 0x%0h", rdata))

    yapp_reg_c.oversized_pkt_cnt_reg.read(status, rdata, UVM_FRONTDOOR);
    assert (rdata == 0)
      else `uvm_error("ASSERT", $sformatf("oversized_pkt_cnt_reg not zero: 0x%0h", rdata))

    phase.drop_objection(this, "End reg_function_test");
  endtask

endclass : reg_function_test
