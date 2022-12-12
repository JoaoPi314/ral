class cthulhu_sanity_reg extends uvm_reg;
	`uvm_object_utils(cthulhu_sanity_reg)
   
	//---------------------------------------
	// fields instance 
	//--------------------------------------- 
	rand uvm_reg_field current_sanity;
	rand uvm_reg_field max_sanity;
	

	
	function new (string name = "cthulhu_sanity_reg");
		super.new(.name(name), .n_bits(8), .has_covergae(UVM_NO_COVERAGE));
	endfunction

	//---------------------------------------
	// At build_phase - TODO list:
	//    1. Create the fields
	//    2. Configure the fields
	//---------------------------------------  
	function void build; 
		
		max_sanity = uvm_reg_field::type_id::create("max_sanity");   
		max_sanity.configure(.parent(this), 
						.size(4), 
						.lsb_pos(4), 
						.access("WO"),  
						.volatile(0), 
						.reset(4'hf), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 

	
		current_sanity = uvm_reg_field::type_id::create("current_sanity");   
		current_sanity.configure(.parent(this), 
						.size(4), 
						.lsb_pos(0), 
						.access("WO"),  
						.volatile(0), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 
    endfunction : build
endclass : cthulhu_sanity_reg
