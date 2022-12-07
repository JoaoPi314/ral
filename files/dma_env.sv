//-------------------------------------------------------------------------
//						dma_env - www.verificationguide.com
//-------------------------------------------------------------------------
`include "dma_reg.sv"
`include "dma_reg_sequence.sv"
`include "dma_agent.sv"

typedef uvm_reg_predictor#(dma_seq_item) dma_reg_predictor;

class dma_model_env extends uvm_env;
  
  //---------------------------------------
  // agent and scoreboard instance
  //---------------------------------------
  dma_agent      dma_agnt;
  
  //---------------------------------------
  // Reg Model and Adapter instance
  //---------------------------------------  
//   dma_reg_model  regmodel;   
  dma_reg_predictor dma_pred;
  
  `uvm_component_utils(dma_model_env)
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - create the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    dma_agnt = dma_agent::type_id::create("dma_agnt", this);
    
    //---------------------------------------
    // Register model and adapter creation
    //---------------------------------------
//     regmodel = dma_reg_model::type_id::create("regmodel", this);
//     regmodel.build();
    
    dma_pred = dma_reg_predictor::type_id::create("dma_pred", this);
    
  endfunction : build_phase
  
  //---------------------------------------
  // connect_phase - connecting regmodel sequencer and adapter with 
  //                             mem agent sequencer and adapter
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    
//     dma_pred.map = regmodel.reg_map;
    dma_pred.adapter = dma_agnt.m_adapter;
    dma_agnt.dma_ap.connect(dma_pred.bus_in);
    
//     regmodel.reg_map.set_sequencer( .sequencer(dma_agnt.sequencer), .adapter(dma_agnt.m_adapter) );
//     regmodel.default_map.set_base_addr('h400);        
    //regmodel.add_hdl_path("tbench_top.DUT");
  endfunction : connect_phase

endclass : dma_model_env