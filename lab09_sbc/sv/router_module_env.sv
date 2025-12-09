//router_module_env.sv


class router_module_env extends uvm_env;
  `uvm_component_utils(router_module_env)

  router_reference   reference;
  router_scoreboard  sb;

  // === Lab 9C: expose TLM exports ===
  uvm_analysis_export #(yapp_packet)      yapp_export;
  uvm_analysis_export #(hbus_transaction) hbus_export;
  uvm_analysis_export #(channel_packet)   chan0_export;
  uvm_analysis_export #(channel_packet)   chan1_export;
  uvm_analysis_export #(channel_packet)   chan2_export;


 function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

 function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    reference = router_reference::type_id::create("reference", this);
    sb  = router_scoreboard::type_id::create("sb",  this);

    // === Lab 9C: create TLM exports ===
    yapp_export  = new("yapp_export",  this);
    hbus_export  = new("hbus_export",  this);
    chan0_export = new("chan0_export", this);
    chan1_export = new("chan1_export", this);
    chan2_export = new("chan2_export", this);

  endfunction : build_phase

 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect valid YAPP packets from reference model to scoreboard
    reference.valid_yapp_port.connect(sb.yapp_imp);

    // === Lab 9C: connect exports to internal imps ===
    yapp_export.connect(reference.yapp_imp);
    hbus_export.connect(reference.hbus_imp);
    chan0_export.connect(sb.ch0_imp);
    chan1_export.connect(sb.ch1_imp);
    chan2_export.connect(sb.ch2_imp);

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
