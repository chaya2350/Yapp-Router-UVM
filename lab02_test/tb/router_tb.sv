class router_tb extends uvm_env;

	`uvm_component_utils(router_tb)

	function new(string name, uvm_component parent);
          super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	 `uvm_info("MSG","Testbench build phase executed",UVM_HIGH);
	endfunction : build_phase

	

endclass:router_tb


