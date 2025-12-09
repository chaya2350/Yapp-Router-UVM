//router_module_env.sv


class router_module_env extends uvm_env;
  `uvm_component_utils(router_module_env)

  router_reference   reference;
  router_scoreboard  sb;

 function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

 function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    reference = router_reference::type_id::create("reference", this);
    sb  = router_scoreboard::type_id::create("sb",  this);
  endfunction : build_phase

 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect valid YAPP packets from reference model to scoreboard
    reference.valid_yapp_port.connect(sb.yapp_imp);

    `uvm_info("ROUTER_ENV_CONNECT",
      "Router module environment connections established.",
      UVM_LOW)
  endfunction : connect_phase

  function void report_phase(uvm_phase phase);
    `uvm_info("ROUTER_ENV_REPORT",
      "Router module environment report phase complete.",
      UVM_LOW)
  endfunction : report_phase

endclass : router_module_env
