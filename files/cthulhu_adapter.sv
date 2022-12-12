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