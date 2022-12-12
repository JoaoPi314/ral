+++
title = "The Agent"
+++


# The Agent

Okay, focusing in the RAL components that will be in agent, we have basically two main objectives:

1. Instantiate the adapter
2. Build it in `build_phase()`

This is very simple, the agent with only these two elements:


```cpp
	
class cthulhu_agent extends uvm_agent;
	`uvm_component_utils(cthulhu_agent)

	cthulhu_adapter     m_adapter;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		m_adapter = cthulhu_adapter.type_id::create("m_adapter");

	endfunction : build_phase

```

We can see that it is the same proccess to insert any component in agent. The complete code of agent is located in [Source Code](/source_code/) page. Now, the ambient is something like this:

![UVM environment](/assets/some_percent_diagram_03.png)
