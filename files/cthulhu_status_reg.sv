class cthulhu_status_reg extends uvm_reg;
	`uvm_object_utils(cthulhu_status_reg)
   
	//---------------------------------------
	// fields instance 
	//--------------------------------------- 
	rand uvm_reg_field is_dead;
	rand uvm_reg_field is_wounded;
    rand uvm_reg_field is_healthy;
    rand uvm_reg_field is_mad;
    rand uvm_reg_field is_going_mad;
    rand uvm_reg_field is_sane;
    rand uvm_reg_field reserved;

	

	
	function new (string name = "cthulhu_status_reg");
		super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
	endfunction

	//---------------------------------------
	// At build_phase - TODO list:
	//    1. Create the fields
	//    2. Configure the fields
	//---------------------------------------  
	function void build; 
		
		is_dead = uvm_reg_field::type_id::create("is_dead");   
		is_dead.configure(.parent(this), 
						.size(1), 
						.lsb_pos(0), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 

	
		is_wounded = uvm_reg_field::type_id::create("is_wounded");   
		is_wounded.configure(.parent(this), 
						.size(1), 
						.lsb_pos(1), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 


		is_healthy = uvm_reg_field::type_id::create("is_healthy");   
		is_healthy.configure(.parent(this), 
						.size(1), 
						.lsb_pos(2), 
						.access("RO"),  
						.volatile(1), 
						.reset(1'b1), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1));

		is_mad = uvm_reg_field::type_id::create("is_mad");   
		is_mad.configure(.parent(this), 
						.size(1), 
						.lsb_pos(3), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 

	
		is_going_mad = uvm_reg_field::type_id::create("is_going_mad");   
		is_going_mad.configure(.parent(this), 
						.size(1), 
						.lsb_pos(4), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 


		is_sane = uvm_reg_field::type_id::create("is_sane");   
		is_sane.configure(.parent(this), 
						.size(1), 
						.lsb_pos(5), 
						.access("RO"),  
						.volatile(1), 
						.reset(1'b1), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 
    endfunction : build
endclass : cthulhu_status_reg
