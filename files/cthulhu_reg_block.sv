class cthulhu_reg_block extends uvm_reg_block;
    `uvm_object_utils(cthulhu_reg_block)
    
    //---------------------------------------
    // register instances 
    //---------------------------------------
    
    cthulhu_life_reg ct_life_reg;
    cthulhu_sanity_reg ct_sanity_reg;
    cthulhu_status_reg ct_status_reg;

    uvm_reg_map reg_map;
    
    //---------------------------------------
    // Constructor 
    //---------------------------------------
    function new (string name = "");
      super.new(.name(name), .has_coverage(UVM_NO_COVERAGE));
    endfunction
  
    //---------------------------------------
    // Build Phase 
    //---------------------------------------
    virtual function void build();
      
      //---------------------------------------
      //reg creation
      //---------------------------------------
      ct_life_reg = cthulhu_life_reg::type_id::create("ct_life_reg");
      ct_life_reg.build();
      ct_life_reg.configure(this);
   
      ct_sanity_reg = cthulhu_sanity_reg::type_id::create("ct_sanity_reg");
      ct_sanity_reg.build();
      ct_sanity_reg.configure(this);
      
      ct_status_reg = cthulhu_status_reg::type_id::create("ct_status_reg");
      ct_status_reg.build();
      ct_status_reg.configure(this);
    
      
      //---------------------------------------
      //Memory map creation and reg map to it
      //---------------------------------------
      reg_map = create_map("my_map", 0, 4, UVM_LITTLE_ENDIAN); // name, base, nBytes
      reg_map.add_reg(ct_life_reg	, 'h000, "WO");  // reg, offset, access
      reg_map.add_reg(ct_sanity_reg	, 'h100, "WO");
      reg_map.add_reg(ct_status_reg	, 'h200, "RO");
      
      lock_model(); 
    endfunction : build
  endclass : cthulhu_reg_block