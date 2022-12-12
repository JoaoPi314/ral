class cthulhu_reg_test extends cthulhu_base_test;
  	`uvm_component_utils(cthulhu_reg_test)

  	cthulhu_reg_sequence reg_seq;


	function new(string name = "cthulhu_reg_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new


	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		reg_seq = cthulhu_reg_sequence::type_id::create("reg_seq");
	endfunction : build_phase
	

	task run_phase(uvm_phase phase);
		
		phase.raise_objection(this);
		if ( !reg_seq.randomize() ) `uvm_error("", "Randomize failed")
		reg_seq.regmodel       = regmodel;
		reg_seq.starting_phase = phase;
		reg_seq.start(env.cthulhu_agnt.sequencer); 
		phase.drop_objection(this);
		
		//set a drain-time for the environment if desired
		phase.phase_done.set_drain_time(this, 50);
	endtask : run_phase
  
endclass : cthulhu_reg_test