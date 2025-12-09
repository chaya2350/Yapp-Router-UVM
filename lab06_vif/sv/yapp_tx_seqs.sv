/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

//SEQUENCE : yapp_1_seq
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new (string name = "yapp_1_seq");
    super.new(name);
  endfunction:new

  virtual task body();
   `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
   `uvm_do_with(req, {req.addr == 2'b01;})
  endtask

endclass : yapp_1_seq



//SEQUENCE : yapp_012_seq

class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new (string name = "yapp_012_seq");
    super.new(name);
  endfunction:new

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, {req.addr == 2'b00;})
    `uvm_do_with(req, {req.addr == 2'b01;})
    `uvm_do_with(req, {req.addr == 2'b10;})
  endtask

endclass : yapp_012_seq



//SEQUENCE : yapp_111_seq

class yapp_111_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_111_seq)

  function new (string name = "yapp_111_seq");
    super.new(name);
  endfunction:new
yapp_1_seq addr_1_seq;
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)
    repeat(3)
    `uvm_do(addr_1_seq)
  endtask

endclass : yapp_111_seq



//SEQUENCE : yapp_repeat_addr_seq

class yapp_repeat_addr_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_repeat_addr_seq)

  function new (string name = "yapp_repeat_addr_seq");
    super.new(name);
  endfunction:new

  rand bit [1:0] seqaddr;
  constraint addr {seqaddr <= 2'b10;}

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)
    repeat(2)
    `uvm_do_with(req, {req.addr == seqaddr;})
  endtask

endclass:yapp_repeat_addr_seq



//SEQUENCE : yapp_incr_payload_seq

class yapp_incr_payload_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_incr_payload_seq)

  function new (string name = "yapp_incr_payload_seq");
    super.new(name);
  endfunction:new

  virtual task body();
    int ok;
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
    `uvm_create(req);
    ok = req.randomize();
    foreach(req.payload[i])
      req.payload[i] = i;
    req.set_parity();
    `uvm_send(req)
  endtask

endclass:yapp_incr_payload_seq


//SEQUENCE : yapp_rand_seq

class yapp_rand_seq extends yapp_base_seq;
 `uvm_object_utils(yapp_rand_seq)
 rand int count;
 constraint count_limit {count inside{[1:10]};}

  function new (string name = "yapp_rand_seq");
    super.new(name);
  endfunction:new

  virtual task body();
    `uvm_info(get_type_name(), $sformatf("Executing yapp_rand_seq %0d times",count), UVM_LOW)
    repeat(count)
    `uvm_do(req)
    
  endtask

endclass:yapp_rand_seq



//SEQUENCE : six_yapp_seq

class six_yapp_seq extends yapp_base_seq;
 `uvm_object_utils(six_yapp_seq)
 
 yapp_rand_seq yrs;


  function new (string name = "six_yapp_seq");
    super.new(name);
  endfunction:new

  virtual task body();
    `uvm_info(get_type_name(),"Executing six_yapp_seq", UVM_LOW)
    `uvm_do_with(yrs,{count==6;})
    
  endtask

endclass:six_yapp_seq


//SEQUENCE : yapp_exhaustive_seq

class yapp_exhaustive_seq extends yapp_base_seq;
 `uvm_object_utils(yapp_exhaustive_seq)

  yapp_012_seq y012;
  yapp_1_seq y1;
  yapp_111_seq y111;
  yapp_repeat_addr_seq yaddr;
  yapp_incr_payload_seq yinc;
  yapp_rand_seq yrs;
  six_yapp_seq sys;



  function new (string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction:new

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_exhaustive_seq sequence", UVM_LOW)
    `uvm_do(y012)
    `uvm_do(y1)
    `uvm_do(y111)
    `uvm_do(yaddr)
    `uvm_do(yinc)
    `uvm_do(yrs)
    `uvm_do(sys)
    
  endtask

endclass:yapp_exhaustive_seq

   




