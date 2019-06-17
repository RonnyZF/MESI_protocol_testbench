//-------------------------------------------------------------------------
//						mesi_seq_item - www.verificationguide.com 
//-------------------------------------------------------------------------

class mesi_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit       PW;
  rand bit       PR;
  rand bit       BW;
  rand bit       BR;
  rand bit		 S;
       bit [1:0] state;
  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(mesi_seq_item)
    `uvm_field_int(PW,UVM_ALL_ON)
    `uvm_field_int(PR,UVM_ALL_ON)
    `uvm_field_int(BW,UVM_ALL_ON)
    `uvm_field_int(BR,UVM_ALL_ON)
    `uvm_field_int(S,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "mesi_seq_item");
    super.new(name);
  endfunction
  
  
endclass