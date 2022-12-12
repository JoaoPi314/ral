class cthulhu_reg_sequence extends uvm_sequence;
	`uvm_object_utils(cthulhu_reg_sequence)
	
	cthulhu_reg_block regmodel;
	

	function new(string name = ""); 
		super.new(name);    
	endfunction
	
	//---------------------------------------
	// Sequence body 
	//---------------------------------------      
	task body;  
		uvm_status_e   status;
		uvm_reg_data_t incoming;
		bit [7:0]      data_r;
		
		if (starting_phase != null)
		starting_phase.raise_objection(this);
		
		//Write to the Registers
		regmodel.ct_sanity_reg.write(status, 8'F5);
		regmodel.ct_life_reg.write(status, 8'F0);
		
		//Read from the registers
		regmodel.ct_status_reg.read(status, data_r);
		
		if (starting_phase != null)
			starting_phase.drop_objection(this);  
		
	endtask
endclass : cthulhu_reg_sequence