class cthulhu_life_reg extends uvm_reg;
	`uvm_object_utils(cthulhu_life_reg)
   
	//---------------------------------------
	// fields instance 
	//--------------------------------------- 
	rand uvm_reg_field current_health;
	rand uvm_reg_field max_health;
	

	
	function new (string name = "cthulhu_life_reg");
		super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
	endfunction

	//---------------------------------------
	// At build_phase - TODO list:
	//    1. Create the fields
	//    2. Configure the fields
	//---------------------------------------  
	virtual function void build(); 
		
		max_health = uvm_reg_field::type_id::create("max_health");   
		max_health.configure(.parent(this), 
						.size(4), 
						.lsb_pos(4), 
						.access("WO"),  
						.volatile(0), 
						.reset(4'hf), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 

	
		current_health = uvm_reg_field::type_id::create("current_health");   
		current_health.configure(.parent(this), 
						.size(4), 
						.lsb_pos(0), 
						.access("WO"),  
						.volatile(0), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 
	endfunction : build
endclass : cthulhu_life_reg

