
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
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
	                   "default_sequence",clk10_rst5_seq::type_id::get());
    uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
	                   "default_sequence",router_simple_mcseq::type_id::get() );
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
	                   "default_sequence",channel_rx_resp_seq::type_id::get() );


    super.build_phase(phase);
  endfunction:build_phase

endclass:router_mcseq_test


