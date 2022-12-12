`define DRIV_IF vif.DRIVER.driver_cb
typedef virtual cthulhu_interface ct_vif;


class cthulhu_driver extends uvm_driver #(cthulhu_transaction);
    `uvm_component_utils(cthulhu_driver)
    
    ct_vif vif;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(ct_vif)::get(this, "", "vif", vif))
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase
 

    virtual task run_phase(uvm_phase phase);
        forever begin
        seq_item_port.get_next_item(req);
        drive();
        seq_item_port.item_done();
        end
    endtask : run_phase
    

    virtual task drive();
        `DRIV_IF.write_en <= 0;
        @(posedge vif.DRIVER.clk);
        
        `DRIV_IF.addr <= req.addr;

        `DRIV_IF.valid <= 1;
        `DRIV_IF.write_en <= req.write_en;
        if(req.write_en) begin
            `DRIV_IF.data_w <= req.data_w;
            @(posedge vif.DRIVER.clk);
        end
        else begin
        @(posedge vif.DRIVER.clk);
            `DRIV_IF.valid <= 0;
            @(posedge vif.DRIVER.clk);
            req.data_r = `DRIV_IF.data_r;
        end
        `DRIV_IF.valid <= 0;
        
    endtask : drive

endclass : cthulhu_driver