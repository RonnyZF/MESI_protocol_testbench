//-------------------------------------------------------------------------
//						mem_sequencer - www.verificationguide.com
//-------------------------------------------------------------------------

class mesi_sequencer extends uvm_sequencer#(mesi_seq_item);

  `uvm_component_utils(mesi_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass