/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
// import the UVM library
// include the UVM macros
import uvm_pkg::*;
`include "uvm_macros.svh"

// import the YAPP package
import yapp_pkg::*;
yapp_packet packet ;
int ok;
initial begin
	repeat(5)
begin
	packet =  new ($sformatf("packet_%0d, i"));
	ok=packet.randomize();
	packet.print();
end
end

// generate 5 random packets and use the print method
// to display the results

// experiment with the copy, clone and compare UVM method
endmodule : top
