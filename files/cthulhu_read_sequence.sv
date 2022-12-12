class cthulhu_read_sequence extends uvm_sequence#(cthulhu_transaction);
  
    `uvm_object_utils(cthulhu_read_sequence)

    function new(string name = "cthulhu_read_sequence");
        super.new(name);
    endfunction : new
    
    virtual task body();
        `uvm_do_with(req,{req.write_en==0;})
    endtask : body
endclass : cthulhu_read_sequence