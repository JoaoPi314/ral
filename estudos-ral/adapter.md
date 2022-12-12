+++
title = "The Adapter"
hascode = true
rss = "A short description of the page which would serve as **blurb** in a `RSS` feed; you can use basic markdown here but the whole description string must be a single line (not a multiline string). Like this one for instance. Keep in mind that styling is minimal in RSS so for instance don't expect maths or fancy styling to work; images should be ok though: ![](https://upload.wikimedia.org/wikipedia/en/b/b0/Rick_and_Morty_characters.jpg)"
rss_title = "More goodies"
rss_pubdate = Date(2019, 5, 1)

tags = ["syntax", "code", "image"]
+++

# The Adapter

\toc


## Overview

Okay, now we have the registers modeled using the `uvm_reg` and `uvm_reg_block`. However, our UVM ambient uses transactions to
communicate between components. The UVM ports transport transactions, and the register models are not transactions. So, we need a way
to easily convert the registers to transactions and vice versa, and this is the main function of an adapter.

## Writting an adapter

Basically, an adapter will have two functions:
- `uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw)`
- `void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw)`

> Just to remember, the `ref` means that the value is passed by reference, and not by copy
### reg2bus

The reg2bus will convert a **RAL transaction** to an **Interface transaction**. It receives as argument an `uvm_reg_bus_op`.
This is a struct with the following fields:
- kind (read or write)
- address (Bus address)
- data (Data to write)
- n\_bits (Number of bits of `uvm_reg_item::value` transferred by this transaction)
- byte\_en (Enables for the byte lanes on the bus). I will confess that I didn't undestand this, but we won't use in this Hands'on
- status (Result of transaction: `UVM_IS_OK`, `UVM_HAS_X`, `UVM_NOT_OK`)

So, let's code this function:

```verilog
function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
	cthulhu_transaction tx;    
	tx = cthulhu_transaction::type_id::create("tx");
	
	tx.write_en = (rw.kind == UVM_WRITE);
	tx.addr  = rw.addr;
	if (tx.write_en)  tx.data_w = rw.data;
	if (!tx.write_en) tx.data_r = rw.data;

	return tx;
endfunction : reg2bus
```

> When a register is read/written, the `uvm_reg_map` calls the `uvm_sequence_base::start_item()`, passing the object returned by `reg2bus()` function. 

### bus2reg

It's the opposite idea of the `reg2bus()`. This function will convert a **Interface transaction** into a **RAL transaction**. Let's code:

```verilog
function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
	cthulhu_transaction tx;
	
	assert( $cast(tx, bus_item) )
	else `uvm_fatal("", "A bad thing has just happened in my_adapter")

	rw.kind = tx.write_en ? UVM_WRITE : UVM_READ;
	rw.addr = tx.addr;
	rw.data = tx.data_r;
	
	rw.status = UVM_IS_OK;
endfunction : bus2reg

```

So, the rest of class is similar to every component of UVM. The complete code is shown below:

```verilog
class cthulhu_adapter extends uvm_reg_adapter;
	`uvm_object_utils (cthulhu_adapter)

	function new(string name = "cthulhu_adapter");
		super.new(name);
	endfunction

	function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		cthulhu_transaction tx;    
		tx = cthulhu_transaction::type_id::create("tx");
		
		tx.write_en = (rw.kind == UVM_WRITE);
		tx.addr  = rw.addr;
		if (tx.write_en)  tx.data_w = rw.data;
		if (!tx.write_en) tx.data_r = rw.data;

		return tx;
	endfunction : reg2bus

	function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		cthulhu_transaction tx;
		
		assert( $cast(tx, bus_item) )
		else `uvm_fatal("", "A bad thing has just happened in my_adapter")

		rw.kind = tx.write_en ? UVM_WRITE : UVM_READ;
		rw.addr = tx.addr;
		rw.data = tx.data_r;
		
		rw.status = UVM_IS_OK;
	endfunction : bus2reg
endclass : cthulhu_adapter

```

Okay, now our ambient is a little morre colorful:

![UVM environment](/assets/some_percent_diagram_02.png)
