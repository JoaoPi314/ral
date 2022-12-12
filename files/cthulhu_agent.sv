class cthulhu_agent extends uvm_agent;
	`uvm_component_utils(cthulhu_agent)

	typedef uvm_sequencer#(cthulhu_transaction) cthulhu_sequencer;

	cthulhu_driver      driver;
	cthulhu_sequencer   sequencer;
	cthulhu_monitor     monitor;
	cthulhu_adapter     m_adapter;

	uvm_analysis_port#(cthulhu_transaction) cthulhu_ap;

	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cthulhu_ap = new(.name("cthulhu_ap"), .parent(this));

		monitor = cthulhu_monitor::type_id::create("monitor", this);

		if(get_is_active() == UVM_ACTIVE) begin
			driver    = cthulhu_driver::type_id::create("driver", this);
			sequencer = cthulhu_sequencer::type_id::create("sequencer", this);
		end
		
		m_adapter = cthulhu_adapter::type_id::create("m_adapter",, get_full_name());

	endfunction : build_phase
	

	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE) begin
			driver.seq_item_port.connect(sequencer.seq_item_export);
		end
		
		monitor.item_collected_port.connect(cthulhu_ap);
		
	endfunction : connect_phase

endclass : cthulhu_agent