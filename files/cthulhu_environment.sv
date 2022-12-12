typedef uvm_reg_predictor#(cthulhu_transaction) cthulhu_reg_predictor;

class cthulhu_environment extends uvm_env;
	`uvm_component_utils(cthulhu_environment)
  
	cthulhu_agent      		cthulhu_agnt;
	cthulhu_reg_predictor 	cthulhu_pred;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cthulhu_agnt = cthulhu_agent::type_id::create("cthulhu_agnt", this);
	
		cthulhu_pred = cthulhu_reg_predictor::type_id::create("cthulhu_pred", this);
		
	endfunction : build_phase
	

	function void connect_phase(uvm_phase phase);
		cthulhu_pred.adapter = cthulhu_agnt.m_adapter;
		cthulhu_agnt.cthulhu_ap.connect(cthulhu_pred.bus_in);
	endfunction : connect_phase

endclass : cthulhu_environment