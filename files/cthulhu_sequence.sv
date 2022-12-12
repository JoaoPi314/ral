class cthulhu_sequence extends uvm_sequence#(cthulhu_transaction);
  
    `uvm_object_utils(cthulhu_sequence)

    function new(string name = "cthulhu_sequence");
        super.new(name);
    endfunction
    
    `uvm_declare_p_sequencer(cthulhu_sequencer)
    
    virtual task body();
        repeat(2) begin
        req = cthulhu_transaction::type_id::create("req");
        wait_for_grant();
        req.randomize();
        send_request(req);
        wait_for_item_done();
    end 
    endtask : body
  endclass