class yapp_tx_monitor extends uvm_monitor;
  `uvm_component_utils(yapp_tx_monitor)

  function new (string name , uvm_component parent);
    super.new(name, parent);
  endfunction: new

  task run_phase (uvm_phase phase);
    `uvm_info(get_type_name(),"Inside the monitor",UVM_LOW)
  endtask: run_phase

endclass: yapp_tx_monitor
