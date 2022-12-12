class cthulhu_monitor extends uvm_monitor;
	`uvm_component_utils(cthulhu_monitor)


	ct_vif vif;
	uvm_analysis_port #(cthulhu_transaction) item_collected_port;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
		item_collected_port = new("item_collected_port", this);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ct_vif)::get(this, "", "vif", vif))
		`uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
	endfunction: build_phase
	

	virtual task run_phase(uvm_phase phase);
		forever begin
		cthulhu_transaction trans_collected;
		trans_collected = new();
		@(posedge vif.MONITOR.clk);
		wait(vif.monitor_cb.valid);
			trans_collected.addr = vif.monitor_cb.addr;
			trans_collected.write_en = vif.monitor_cb.write_en;
		
		if(vif.monitor_cb.write_en) begin
			trans_collected.write_en = vif.monitor_cb.write_en;
			trans_collected.data_w = vif.monitor_cb.data_w;
			@(posedge vif.MONITOR.clk);
		end
		else begin
			@(posedge vif.MONITOR.clk);
			@(posedge vif.MONITOR.clk);
			trans_collected.data_r = vif.monitor_cb.data_r;
		end
		item_collected_port.write(trans_collected);
		end 
	endtask : run_phase

endclass : cthulhu_monitor