//Mesi Test Library

class mesi_test_lib extends mesi_base_test;
  
  `uvm_component_utils(mesi_test_lib)
  
    //---------------------------------------
    // sequence instance 
    //--------------------------------------- 
    test_sequence seq;
    //mesi_sequence seq;
  
    //---------------------------------------
    // constructor
    //---------------------------------------
  	function new(string name = "mesi_test_lib",uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    //---------------------------------------
    // build_phase
    //---------------------------------------
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

    // Create the sequence
    	seq = test_sequence::type_id::create("seq");
        //seq = mesi_sequence::type_id::create("seq");
  		endfunction : build_phase
    //---------------------------------------
  // run_phase - starting the test
  //---------------------------------------
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    	seq.start(env.mesi_agnt.sequencer);
    phase.drop_objection(this);
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 500);
  endtask : run_phase
  
endclass : mesi_test_lib