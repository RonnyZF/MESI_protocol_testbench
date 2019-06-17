//-------------------------------------------------------------------------
//						driver for MESI agent
//-------------------------------------------------------------------------

`define DRIV_IF vif.DRIVER.driver_cb 
//se le assigna el nombre de DRIV_IF a la ruta vif.DRIVER.driver_cb (dentro la de virtual interface ahy un DRIVER que tiene un clocking block )

class mesi_driver extends uvm_driver #(mesi_seq_item);//(REQ,RESP)

  //--------------------------------------- 
  // Virtual Interface
  //--------------------------------------- 
  virtual mesi_if vif;
  `uvm_component_utils(mesi_driver)
    
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mesi_if)::get(this, "", "vif", vif))//revisa que la interfaz virtual existe?
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  //---------------------------------------  
  // run phase -- Envía Datos
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  //---------------------------------------
  // drive - transaction level to signal level
  // drives the value's from seq_item to interface signals
  //---------------------------------------
  virtual task drive();    
      	`DRIV_IF.PW <= 0;
        `DRIV_IF.PR <= 0;
        `DRIV_IF.BW <= 0;
        `DRIV_IF.BR <= 0;
        `DRIV_IF.S <= 0;
    @(posedge vif.DRIVER.clk);//bloquea todo lo que esta abajo hasta q ocurra la condicion
      if(req.PW || req.PR || req.BW || req.BR || req.S )begin
      	`DRIV_IF.PW <= req.PW;
        `DRIV_IF.PR <= req.PR;
        `DRIV_IF.BW <= req.BW;
        `DRIV_IF.BR <= req.BR;
        `DRIV_IF.S <= req.S;
        @(posedge vif.DRIVER.clk);
        req.state = `DRIV_IF.state;
        @(posedge vif.DRIVER.clk);
      end
    
  endtask : drive
endclass : mesi_driver