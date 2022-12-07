//-------------------------------------------------------------------------
//						dma_agent - www.verificationguide.com 
//-------------------------------------------------------------------------

`include "dma_agent_files.sv"
`include "dma_adapter.sv"


class dma_agent extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  dma_driver    driver;
  dma_sequencer sequencer;
  dma_monitor   monitor;
  dma_adapter    m_adapter;

  
  uvm_analysis_port#(dma_seq_item) dma_ap;

  
  `uvm_component_utils(dma_agent)
  
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
    dma_ap = new(.name("dma_ap"), .parent(this));

    monitor = dma_monitor::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = dma_driver::type_id::create("driver", this);
      sequencer = dma_sequencer::type_id::create("sequencer", this);
    end
    
    m_adapter = dma_adapter::type_id::create("m_adapter",, get_full_name());

  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    
    monitor.item_collected_port.connect(dma_ap);
    
  endfunction : connect_phase

endclass : dma_agent