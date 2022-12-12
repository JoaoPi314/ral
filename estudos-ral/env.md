+++
title = "The Environment"
+++


# The Environment

If we look at our diagram, the only RAL component that is inside the environment is the explicit predictor.

There are three thing we must do to implement the predictor in environment:
1. Instantiate
2. Build
3. Connect the predictor adapter with our adapter instantiated in agent


```cpp
typedef uvm_reg_predictor#(cthulhu_transaction) cthulhu_reg_predictor;

class cthulhu_environment extends uvm_env;
	`uvm_component_utils(cthulhu_environment)
  
	cthulhu_agent		cthulhu_agnt;
	// Instantiates predictor
	cthulhu_reg_predictor	cthulhu_pred;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cthulhu_agnt = cthulhu_agent::type_id::create("cthulhu_agnt", this);
		// Build predictor
		cthulhu_pred = cthulhu_reg_predictor::type_id::create("cthulhu_pred", this);
		
	endfunction : build_phase
	

	function void connect_phase(uvm_phase phase);
		// Connect predictor adapter to agent adapter
		cthulhu_pred.adapter = cthulhu_agnt.m_adapter;
		// Connect predictor to monitor
		cthulhu_agnt.cthulhu_ap.connect(cthulhu_pred.bus_in);
	endfunction : connect_phase

endclass : cthulhu_environment

```

And that is our environment. Our diagram now is:


![UVM diagram](/assets/some_percent_diagram_04.png)