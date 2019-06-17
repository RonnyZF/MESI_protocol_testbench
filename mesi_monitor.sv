//-------------------------------------------------------------------------
//						Monitor for the MESI agent
//-------------------------------------------------------------------------

class mesi_monitor extends uvm_monitor;

  //---------------------------------------
  // Virtual Interface 
  // Connection between monitor and DUT
  //---------------------------------------
  virtual mesi_if vif;

  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(mesi_seq_item) item_collected_port;
  //puerto por el que va a pasar un dato de tipo mesi_seq_item que se llama item_collected_port
  
  //---------------------------------------
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  mesi_seq_item collected_data; //paquete de datos donde se almacena la informacion capturada del DUT

  `uvm_component_utils(mesi_monitor)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    collected_data = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  //---------------------------------------
  // build_phase - getting the interface handle
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mesi_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  //---------------------------------------
  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.MONITOR.clk);
      
      //se colecta la información cuando cualquiera de las entradas cambia
      if(vif.monitor_cb.PW || vif.monitor_cb.PR ||
         vif.monitor_cb.BW || vif.monitor_cb.BR ||
         vif.monitor_cb.S) begin
        
        collected_data.PW	 = vif.monitor_cb.PW;
        collected_data.PR	 = vif.monitor_cb.PR;
        collected_data.BW	 = vif.monitor_cb.BW;
        collected_data.BR	 = vif.monitor_cb.BR;
        collected_data.S	 = vif.monitor_cb.S;
        @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk);
        collected_data.state = vif.monitor_cb.state;
      	end
      item_collected_port.write(collected_data);
      end 
  endtask : run_phase

endclass : mesi_monitor
