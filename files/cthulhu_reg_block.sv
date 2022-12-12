class cthulhu_reg_block extends uvm_reg_block;
    `uvm_object_utils(cthulhu_reg_block)
    
    //***************************************
    //* Register instantiation              *
    //***************************************
    
    cthulhu_life_reg ct_life_reg;
    cthulhu_sanity_reg ct_sanity_reg;
    cthulhu_status_reg ct_status_reg;

    uvm_reg_map reg_map;
    
   
    function new (string name = "");
      super.new(.name(name), .has_coverage(UVM_NO_COVERAGE));
    endfunction
  

    virtual function void build();
      
      // Creation, build and configuration
      ct_life_reg = cthulhu_life_reg::type_id::create("ct_life_reg");
      ct_life_reg.build();
      ct_life_reg.configure(this);
   
      ct_sanity_reg = cthulhu_sanity_reg::type_id::create("ct_sanity_reg");
      ct_sanity_reg.build();
      ct_sanity_reg.configure(this);
      
      ct_status_reg = cthulhu_status_reg::type_id::create("ct_status_reg");
      ct_status_reg.build();
      ct_status_reg.configure(this);
    

      // Map creation
      reg_map.create_map(
          .name("reg_map"), // Just the name bro
          .base_addr(12'h100), // The base address of memory map '
          .n_bytes(1), // The number of bytes of each register
          .endian(UVM_LITTLE_ENDIAN) // Defines order of storage values in fields
      );

      // Adding Registers
      reg_map.add_reg(
          .rg(ct_life_reg), //Register instance
          .offset('h000),   //Address offset '
          .rights("WO")     //Access Policy
      );

      reg_map.add_reg(
          .rg(ct_sanity_reg),
          .offset('h100),
          .rights("WO")
      );

      reg_map.add_reg(
          .rg(ct_status_reg), 
          .offset('h200), 
          .rights("RO")
      );

    lock_model();
    endfunction : build
  endclass : cthulhu_reg_block