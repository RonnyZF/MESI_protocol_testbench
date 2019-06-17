//-------------------------------------------------------------------------
//						agent for interface of the MESI FSM
//-------------------------------------------------------------------------

`include "mesi_seq_item.sv"
`include "mesi_sequencer.sv"
`include "mesi_sequence_lib.sv"
`include "mesi_driver.sv"
`include "mesi_monitor.sv"

class mesi_agent extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  mesi_driver    driver;
  mesi_sequencer sequencer;
  mesi_monitor   monitor;

  `uvm_component_utils(mesi_agent)
  
  //---------------------------------------
  // constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = mesi_monitor::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = mesi_driver::type_id::create("driver", this);
      sequencer = mesi_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : mesi_agent