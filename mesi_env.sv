//-------------------------------------------------------------------------
//						mem_env - www.verificationguide.com
//-------------------------------------------------------------------------

`include "mesi_agent.sv"
`include "mesi_scoreboard.sv"

class mesi_env extends uvm_env;
  
  //---------------------------------------
  // agent and scoreboard instance
  //---------------------------------------
//tipo de clase   nombre
  mesi_agent      mesi_agnt;
  mesi_scoreboard mesi_scb;
  
  `uvm_component_utils(mesi_env)//incluye la clase a la lista de componentes y utilidades
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - crate the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mesi_agnt = mesi_agent::type_id::create("mesi_agnt", this);//string nombre, padre jerarquico
    mesi_scb  = mesi_scoreboard::type_id::create("mesi_scb", this);
  endfunction : build_phase
  
  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    mesi_agnt.monitor.item_collected_port.connect(mesi_scb.item_collected_export);
  endfunction : connect_phase            //la funcion connect permite la conexion entre puertos

endclass : mesi_env