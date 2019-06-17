//-------------------------------------------------------------------------
//						mesi_sequence_library
//-------------------------------------------------------------------------

//=========================================================================
// mesi_sequence - random stimulus 
//=========================================================================
class mesi_sequence extends uvm_sequence#(mesi_seq_item);
  
  `uvm_object_utils(mesi_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "mesi_sequence");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(mesi_sequencer)
  
  //---------------------------------------
  // create, randomize and send the item to driver
  //---------------------------------------
  virtual task body();
    req = mesi_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
  endtask
endclass
//=========================================================================

//Se crean secuencias basicas para PW,PR,BW,BR

//=========================================================================
//        Processor_Write_Sequence 
//=========================================================================
class PW_sequence extends uvm_sequence#(mesi_seq_item);
  
  `uvm_object_utils(PW_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "PW_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.PW==1;req.PR==0;req.BW==0;req.BR==0;})
  endtask
endclass
//=========================================================================

//=========================================================================
//        Processor_Read_Sequence 
//=========================================================================
class PR_sequence extends uvm_sequence#(mesi_seq_item);
  
  `uvm_object_utils(PR_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "PR_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.PW==0;req.PR==1;req.BW==0;req.BR==0;})
  endtask
endclass
//=========================================================================

//=========================================================================
//        Bus_Write_Sequence 
//=========================================================================
class BW_sequence extends uvm_sequence#(mesi_seq_item);
  
  `uvm_object_utils(BW_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "BW_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.PW==0;req.PR==0;req.BW==1;req.BR==0;})
  endtask
endclass
//=========================================================================

//=========================================================================
//        Bus_Read_Sequence 
//=========================================================================
class BR_sequence extends uvm_sequence#(mesi_seq_item);
  
  `uvm_object_utils(BR_sequence)
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "BR_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.PW==0;req.PR==0;req.BW==0;req.BR==1;})
  endtask
endclass
//=========================================================================

// Se trabaja con una secuencia de secuencias

//=========================================================================
//        Test_sequence
//=========================================================================
class test_sequence extends uvm_sequence#(mesi_seq_item);
  
  //------------------------------------------
  //Declaring sequences
  //------------------------------------------
  PW_sequence pw_seq;
  PR_sequence pr_seq;
  BW_sequence bw_seq;
  BR_sequence br_seq;
  
  `uvm_object_utils(test_sequence);
  
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "test_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      `uvm_do(pw_seq)//45
      `uvm_do(pr_seq)//75
      `uvm_do(bw_seq)//105
      
      `uvm_do(bw_seq)//135
      `uvm_do(br_seq)//165
      `uvm_do(pr_seq)//195
      
      `uvm_do(pr_seq)//225
      `uvm_do(pw_seq)//255

      `uvm_do(br_seq)//285
      `uvm_do(pr_seq)//315
      `uvm_do(pr_seq)//345
      `uvm_do(br_seq)//375
      `uvm_do(pw_seq)//405
      `uvm_do(bw_seq)//435
      
      `uvm_do(pw_seq)//465
      `uvm_do(br_seq)//495
      
      `uvm_do(pr_seq)//525
      `uvm_do(bw_seq)//555
      
      `uvm_do(pw_seq)//585
      `uvm_do(bw_seq)//615
      `uvm_do(pw_seq)//
      `uvm_do(pr_seq)//
      `uvm_do(br_seq)//
    end
  endtask
endclass
