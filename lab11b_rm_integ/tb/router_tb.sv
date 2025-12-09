class router_tb extends uvm_env;

	clock_and_reset_env clock_and_reset;

	yapp_env yapp;

	channel_env chan0;
	channel_env chan1;
	channel_env chan2;

	hbus_env hbus;

        router_mcsequencer mcseqr;
	//router_scoreboard sb;
	router_module_env router_env;

    yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5  yapp_rm;
    hbus_reg_adapter    reg2hbus;

    `uvm_component_utils_begin(router_tb)
            `uvm_field_object(yapp_rm, UVM_ALL_ON) 
	`uvm_component_utils_end


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
	 //sb = router_scoreboard::type_id::create("sb", this);
	router_env = router_module_env::type_id::create("router_env", this);

	 //HBUS UVC
	 uvm_config_int::set(this, "hbus", "num_masters", 1);
	 uvm_config_int::set(this, "hbus" , "num_slaves" , 0);
	 hbus = hbus_env::type_id::create("hbus",this);

	 //clock and reset UVC
	 clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset",this);

	 yapp_rm = yapp_router_regs_vendor_Cadence_Design_Systems_library_Yapp_Registers_version_1_5::type_id::create("yapp_rm",this);
	 yapp_rm.build();
	 yapp_rm.lock_model();
	 yapp_rm.set_hdl_path_root("hw_top.dut");
     yapp_rm.default_map.set_auto_predict(1); 
	 reg2hbus= hbus_reg_adapter::type_id::create("reg2bus",this);

	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
  	  super.connect_phase(phase);

	  mcseqr.hbus_seqr = hbus.masters[0].sequencer;
          mcseqr.yapp_seqr = yapp.tx_agent.sequencer;

          //yapp.tx_agent.monitor.item_collected_port.connect(sb.yapp_imp);
	  //chan0.rx_agent.monitor.item_collected_port.connect(sb.ch0_imp);
 	  //chan1.rx_agent.monitor.item_collected_port.connect(sb.ch1_imp);
          //chan2.rx_agent.monitor.item_collected_port.connect(sb.ch2_imp);

	  //yapp.tx_agent.monitor.item_collected_port.connect(router_env.reference.yapp_imp);
	  //hbus.masters[0].monitor.item_collected_port.connect(router_env.reference.hbus_imp);
	  //chan0.rx_agent.monitor.item_collected_port.connect(router_env.sb.ch0_imp);
	  //chan1.rx_agent.monitor.item_collected_port.connect(router_env.sb.ch1_imp);
	  //chan2.rx_agent.monitor.item_collected_port.connect(router_env.sb.ch2_imp);

	  // === Lab 9C: connect monitors to router_env exports ===
	  yapp.tx_agent.monitor.item_collected_port.connect(router_env.yapp_export);
	  hbus.masters[0].monitor.item_collected_port.connect(router_env.hbus_export);
	  chan0.rx_agent.monitor.item_collected_port.connect(router_env.chan0_export);
	  chan1.rx_agent.monitor.item_collected_port.connect(router_env.chan1_export);
	  chan2.rx_agent.monitor.item_collected_port.connect(router_env.chan2_export);

	  yapp_rm.default_map.set_sequencer(hbus.masters[0].sequencer, reg2hbus);

	endfunction

endclass:router_tb


