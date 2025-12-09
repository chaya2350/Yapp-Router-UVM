class router_tb extends uvm_env;

	`uvm_component_utils(router_tb)

	clock_and_reset_env clock_and_reset;

	yapp_env yapp;

	channel_env chan0;
	channel_env chan1;
	channel_env chan2;

	hbus_env hbus;

        router_mcsequencer mcseqr;
	router_scoreboard sb;

	function new(string name, uvm_component parent);
          super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	 `uvm_info("MSG","Testbench build phase executed",UVM_HIGH);
	 yapp = yapp_env::type_id::create("yapp", this);
         
	 //channel UVC 
	 uvm_config_int::set(this, "chan0", "channel_id", 0);
	 uvm_config_int::set(this, "chan1", "channel_id", 1);
	 uvm_config_int::set(this, "chan2", "channel_id", 2);

	 chan0 = channel_env::type_id::create("chan0",this);
	 chan1 = channel_env::type_id::create("chan1",this);
	 chan2 = channel_env::type_id::create("chan2",this);
	
	//mcseq
	 mcseqr = router_mcsequencer::type_id::create("mcseqr", this);
	 sb = router_scoreboard::type_id::create("sb", this);
    

	 //HBUS UVC
	 uvm_config_int::set(this, "hbus", "num_masters", 1);
	 uvm_config_int::set(this, "hbus" , "num_slaves" , 0);
	 hbus = hbus_env::type_id::create("hbus",this);

	 //clock and reset UVC
	 clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset",this);


	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
  	  super.connect_phase(phase);

	  mcseqr.hbus_seqr = hbus.masters[0].sequencer;
          mcseqr.yapp_seqr = yapp.tx_agent.sequencer;
          yapp.tx_agent.monitor.item_collected_port.connect(sb.yapp_imp);
	  chan0.rx_agent.monitor.item_collected_port.connect(sb.ch0_imp);
 	  chan1.rx_agent.monitor.item_collected_port.connect(sb.ch1_imp);
          chan2.rx_agent.monitor.item_collected_port.connect(sb.ch2_imp);

	endfunction

endclass:router_tb


