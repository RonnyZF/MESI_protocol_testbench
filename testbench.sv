// Compile options
//-timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog -ova_cov -cm line+cond+fsm+tgl+path+assert+branch+property_path -cm_pp -cm_report unencrypted_hierarchies+svpackages+noinitial -lca 
//Run Options
//-cm line+cond+fsm+tgl+path+assert+branch+property_path +UVM_TESTNAME=mesi_test_lib
//-------------------------------------------------------------------------
//				testbench.sv
//-------------------------------------------------------------------------
//---------------------------------------------------------------
//including interface and testcase files
`include "mesi_interface.sv"
`include "mesi_base_test.sv"
`include "mesi_test_lib.sv"
//---------------------------------------------------------------

module tbench_fsm;

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit clk;
  bit reset;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 clk = ~clk;
  
  //---------------------------------------
  //reset Generation
  //---------------------------------------
  initial begin
    reset = 1;
    #5 reset =0;
    #620 reset = 1;
    #5 reset =0;
  end
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  mesi_if intf(clk,reset);
  
  //---------------------------------------
  //DUT instance
  //---------------------------------------
  mesi_fsm DUT (
    .clk(intf.clk),
    .reset(intf.reset),
    .PW(intf.PW),
    .PR(intf.PR),
    .BW(intf.BW),
    .BR(intf.BR),
    .S(intf.S),
    .state(intf.state)
   );
  
  //---------------------------------------
  //passing the interface handle to lower heirarchy using set method 
  //and enabling the wave dump
  //---------------------------------------
  initial begin 
    uvm_config_db#(virtual mesi_if)::set(uvm_root::get(),"*","vif",intf);//Sirve para instanciar la interface en otros modulos internos
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin 
    run_test();
  end
  
endmodule