class base_test extends uvm_test;

	`uvm_component_utils(base_test)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction:new

	router_tb tb;

	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
	  uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase","default_sequence", yapp_5_packets::get_type());
	  tb = new("tb", this);	  
	 `uvm_info("MSG","Test build phase executed",UVM_HIGH);
	endfunction:build_phase

	function void end_of_elaboration_phase(uvm_phase phase);
	  uvm_top.print_topology();
        endfunction: end_of_elaboration_phase


endclass:base_test
