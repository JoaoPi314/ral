class cthulhu_base_test extends uvm_test;
    `uvm_component_utils(cthulhu_base_test)
    
  
    cthulhu_environment env;
    cthulhu_reg_block   regmodel;   
  
  
    function new(string name = "cthulhu_base_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new
  
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        regmodel = cthulhu_reg_block::type_id::create("regmodel", this);
        regmodel.build();
         
        env = cthulhu_environment::type_id::create("env", this);
    endfunction : build_phase

    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    
        env.cthulhu_pred.map = regmodel.reg_map;
        regmodel.reg_map.set_sequencer(.sequencer(env.cthulhu_agnt.sequencer), .adapter(env.cthulhu_agnt.m_adapter) );
        regmodel.default_map.set_base_addr('h100);      
    endfunction : connect_phase
    

    virtual function void end_of_elaboration();
        print();
    endfunction
  

   function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    
    svr = uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
        `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    endfunction 
  
endclass : cthulhu_base_test
  