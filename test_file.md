+++
title = "The Test"
+++

\toc

If you return to any page that contains the UVM diagram, you will see that the register block is inside the test. So, the first thing that we need to
know is how to insert this component at the test file. There are three things we must do:

1. Register block instantiation;
2. Register block build;
3. Connect the register block map to the predictor map;
4. Configure the sequencer and the adapter of the register block map;
5. Configure the base address of the register block map (the offsets will be computed considering this value)

These five steps are implemented below (The complete Base test code, and the `cthulhu_reg_test` is at [Source Code](/source_code/)).

```verilog
class cthulhu_base_test extends uvm_test;
    `uvm_component_utils(cthulhu_base_test)
    
    cthulhu_environment env;
    cthulhu_reg_block   regmodel;   // 1.
  
  
    function new(string name = "cthulhu_base_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new
  
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        regmodel = cthulhu_reg_block::type_id::create("regmodel", this); // 2.1
        regmodel.build(); // 2.2
         
        env = cthulhu_environment::type_id::create("env", this);
    endfunction : build_phase

    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    
        env.cthulhu_pred.map = regmodel.reg_map; // 3.
        regmodel.reg_map.set_sequencer(.sequencer(env.cthulhu_agnt.sequencer), .adapter(env.cthulhu_agnt.m_adapter)); // 4.
        regmodel.default_map.set_base_addr('h100); // 5.
    endfunction : connect_phase
    
    ...
  
endclass : cthulhu_base_test
  
```

The top file doesn't contain any RAL component, so you can see it at YOU KNOW WHERE YOU CAN FIND SOURCE CODES. Our UVM diagram is finnaly complete:


![UVM environment](/assets/full_diagram.png)

