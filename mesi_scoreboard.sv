//-------------------------------------------------------------------------
//						mem_scoreboard - www.verificationguide.com 
//-------------------------------------------------------------------------

class mesi_scoreboard extends uvm_scoreboard;
  
  //---------------------------------------
  // declaring pkt_qu to store the pkt's recived from monitor
  //---------------------------------------
  mesi_seq_item pkt_queue[$];//$ -> significa tamaño dinamico
  
  //---------------------------------------
  // sc_mesi 
  //---------------------------------------

    parameter modified=0;
    parameter exclusive=1;
    parameter shared=2;
    parameter invalid=3;
    bit [1:0] state = 2'd0;
    bit [1:0] next_state = 2'd0;

  
  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(mesi_seq_item, mesi_scoreboard) item_collected_export; //puerto donde conecto el monitor
  `uvm_component_utils(mesi_scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize el puerto
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
      state=2'd0;
      //next_state=2'd0;
  endfunction: build_phase
  
  //---------------------------------------
  // write task - recives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write(mesi_seq_item pkt);
    pkt.print();//imprime la informacion del paquete
    pkt_queue.push_back(pkt);
  endfunction : write

  //---------------------------------------
  // run_phase - compare's the read data with the expected data(stored in local memory)
  // local memory will be updated on the write operation.
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    mesi_seq_item data;
    
    forever begin
        wait(pkt_queue.size()>0)
        data=pkt_queue.pop_front();
      
        case(state)
          invalid: 
            if(data.BW || data.BR) 
              next_state=invalid;
            else if(data.PR && data.S)
              next_state=shared;
            else if(data.PR && ~data.S)
              next_state=exclusive;
            else if(data.PW && data.S)
              next_state=exclusive;
            else if(data.PW && ~data.S)
              next_state=modified;
            else
              next_state=invalid;
           shared:
             if(data.PR||data.BR) 
              next_state=shared;
            else if(data.BW)
              next_state=invalid;
            else if(data.PW)
              next_state=exclusive;
            else
              next_state=shared;
           exclusive:
            if(data.PR)
              next_state=exclusive;
            else if(data.BW)
              next_state=invalid;
            else if(data.BR)
              next_state=shared;
            else if(data.PW)
              next_state=modified;
            else
              next_state=exclusive;
           modified:
             if(data.PR||data.PW) 
              next_state=modified;
            else if(data.BR)
              next_state=shared;
            else if(data.BW)
              next_state=invalid;
            else
              next_state=modified;
           default:
              next_state=invalid;
      	endcase

      if(data.state == next_state) begin
        `uvm_info(get_type_name(),$sformatf("------ :: STATE Match :: ------"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Expected state: %0h Actual state: %0h",next_state,data.state),UVM_LOW)
        `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
        end
      else begin
          `uvm_error(get_type_name(),"------ :: STATE MisMatch :: ------")
          `uvm_info(get_type_name(),$sformatf("Expected state: %0h Actual state: %0h",next_state,data.state),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------\n",UVM_LOW)
        end
      state=data.state;
      
        case (state)
          0: `uvm_info(get_type_name(),$sformatf("0 - MODIFIED"),UVM_LOW)
            1: `uvm_info(get_type_name(),$sformatf("1 - EXCLUSIVE"),UVM_LOW)
            2: `uvm_info(get_type_name(),$sformatf("2 - SHARED"),UVM_LOW)
            3: `uvm_info(get_type_name(),$sformatf("3 - INVALID"),UVM_LOW)
        endcase     
    end
  endtask : run_phase
endclass : mesi_scoreboard