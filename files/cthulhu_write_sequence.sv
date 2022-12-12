class cthulhu_write_sequence extends uvm_sequence#(cthulhu_transaction);
  
    `uvm_object_utils(cthulhu_write_sequence)
     
    function new(string name = "cthulhu_write_sequence");
        super.new(name);
    endfunction : new
    
    virtual task body();
        `uvm_do_with(req,{req.write_en==1;})
    endtask : body
endclass : cthulhu_write_sequence