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
typedef uvm_reg_predictor#(dnd_transaction) dnd_reg_predictor

class dnd_environment extends uvm_env;
	`uvm_component_utils(dnd_environment)

	dnd_agent dnd_agt;

	//Instantiate
	dnd_reg_predictor dnd_pred;

	function new(string name="dnd_environment");
		super.new(.name(name));
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		dnd_agt = dnd_agent::type_id::create("dnd_agt", this);

		// Build
		dnd_pred = dnd_reg_predictor::type_id::create("dnd_pred", this);
	endfunction : build_phase


	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		// Connect adapter
		dnd_pred.adapter = dnd_agt.dnd_adapter;

		// connect analysis port from agent(monitor transaction) to predictor
		dnd_agt.dnd_ap.connect(dnd_pred.bus_in);

	endfunction : connect_phase 

endclass : dnd_environment

```

And that is our environment. Our diagram now is:


![UVM diagram](/assets/some_percent_diagram_04.png)