//-------------------------------------------------------------------------
//						mesi_interface
//-------------------------------------------------------------------------

interface mesi_if(input logic clk,reset);
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------
  logic PW;
  logic PR;
  logic BW;
  logic BR;
  logic S;
  logic [1:0] state;
    
  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    default input #1 output #1;//define a partir de que momento empieza a cambiar las señales
    output PW;
    output PR;
    output BW;
    output BR;
    output S;
    input  state;  
  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;//retardo en la captura de datos "CLOCK SKEW"
    input PW;
    input PR;
    input BW;
    input BR;
    input S;
    input state;    
  endclocking
  
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  //---------------------------------------
  //monitor modport  
  //---------------------------------------
  modport MONITOR (clocking monitor_cb,input clk,reset);
    
  //---------------------------------------
  //Functional Coverage Collection
  //---------------------------------------
    
    covergroup mesi_coverage @(posedge PW or posedge PR or posedge BW or posedge BR);
      state_cov : coverpoint state{
        bins M = {0};
        bins E = {1};
        bins S = {2};
        bins I = {3};
        //bins M_to_E = (0=>1); -No existe este cambio en MESI
        bins M_to_S = (0=>2);
        bins M_to_I = (0=>3);
        bins E_to_M = (1=>0);
        bins E_to_S = (1=>2);
        bins E_to_I = (1=>3);
        //bins S_to_M = (2=>0); -No existe este cambio en MESI
        bins S_to_E = (2=>1);
        bins S_to_I = (2=>3);
        bins I_to_M = (3=>0);
        bins I_to_E = (3=>1);
        bins I_to_S = (3=>2);
      }
      PR_cov : coverpoint PR {
        bins no_PR = {0};
        bins set_PR = {1};
      }
      PW_cov : coverpoint PW {
        bins no_PW = {0};
        bins set_PW = {1};
      }
      BR_cov : coverpoint BR {
        bins no_BR = {0};
        bins set_BR = {1};
      }
      BW_cov : coverpoint BW {
        bins no_BW = {0};
        bins set_BW = {1};
      }
      S_cov : coverpoint S {
        bins no_S = {0};
        bins set_S = {1};
      }
      cross_PW_S_cov : cross PW_cov, S_cov;
      cross_PR_S_cov : cross PR_cov, S_cov;
      cross_state_PW_cov : cross state_cov, PW_cov;
      cross_state_PR_cov : cross state_cov, PR_cov;
      cross_state_BW_cov : cross state_cov, BW_cov;
      cross_state_BR_cov : cross state_cov, BR_cov;
      cross_state_S_cov  : cross state_cov, S_cov;
    endgroup
    
    mesi_coverage coverage_collection = new();
  
endinterface