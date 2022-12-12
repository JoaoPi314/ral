class cthulhu_transaction extends uvm_sequence_item;

    rand bit [11:0] addr;
    rand bit        write_en;
    rand bit [7:0]  data_w;
    rand bit [7:0]  data_r;
    

    `uvm_object_utils_begin(cthulhu_transaction)
        `uvm_field_int(addr,UVM_ALL_ON)
        `uvm_field_int(write_en,UVM_ALL_ON)
        `uvm_field_int(data_w,UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "cthulhu_transaction");
        super.new(name);
    endfunction
    
endclass