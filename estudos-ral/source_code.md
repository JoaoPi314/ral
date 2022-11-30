+++
title = "Source Code"
+++

# Source Code

\toc

## dnd\_register\_reg.sv

```cpp
class dnd_player_reg extends uvm_reg;
    `uvm_object_utils(dnd_player_reg)

    //Fields declaration
    rand uvm_reg_field max_health;
    rand uvm_reg_field current_health;
    rand uvm_reg_field is_dead;
    rand uvm_reg_field initiative;


    function new(string name="dnd_player_reg");
        super.new(.name(name), .n_bits(16), .has_coverage(UVM_NO_COVERAGE));
    endfunction : new

    virtual function void build();
            // Building the field (Same way that we build every object in UVM)
            max_health = uvm_reg_field::type_id::create("max_health")

            // Configuring the field
            max_health.configure(
                .parent(this), //Just repeat this :D
                .size(6), // The size of field is defined here, in bits
                .lsb_pos(10), // The position of LSB bit of the field
                .access("RO"), // Access policy. In this case, it is Read Only
                .volatile(1), // Tells if this field can be changed internally
                .reset(0), // Defines the reset value of the field
                .has_reset(1), // Tells if the field resets when a reset is applied
                .is_rand(1), // Allows field randomization
                .individually_accessible(0) // When write() is called, the entire register is written
            );
            current_health.configure(
               .parent(this),
               .size(6),
               .lsb_pos(4),
               .access(RW),
               .volatile(0),
               .reset(0),
               .has_reset(1),
               .is_rand(1),
               .individually_accessible(0)
            );
            is_dead.configure(
               .parent(this),
               .size(1),
               .lsb_pos(3),
               .access(RO),
               .volatile(1),
               .reset(0),
               .has_reset(1),
               .is_rand(1),
               .individually_accessible(0)
            );
            initiative.configure(
               .parent(this),
               .size(3),
               .lsb_pos(0),
               .access(RO),
               .volatile(1),
               .reset(0),
               .has_reset(1),
               .is_rand(1),
               .individually_accessible(0)
            );

    endfunction : build

endclass : dnd_player_reg

```

## dnd\_reg\_block.sv

```cpp

class dnd_reg_block extends uvm_reg_block;
    `uvm_object_utils(dnd_reg_block)

    // Instantiates register models
    rand dnd_player_reg reg_player;
    rand dnd_actions_reg reg_actions;
    rand dnd_inventory_reg reg_inventory;

    // Instantiates memory map
    uvm_reg_map reg_map;


    // Constructor
    function new(string name="dnd_reg_block");
        super.new(.name(name), .has_coverage(UVM_NO_COVERAGE));
    endfunction : new

    // Build function
    virtual function void build();

        // Define, configure and build. Repeat to every register
        reg_player = dnd_player_reg::type_id::create("reg_player");
        reg_player.configure(.blk_parent(this));
        reg_player.build();

        reg_actions = dnd_actions_reg::type_id::create("reg_actions");
        reg_actions.configure(.blk_parent(this));
        reg_actions.build();

        reg_inventory = dnd_inventory_reg::type_id::create("reg_inventory");
        reg_inventory.configure(.blk_parent(this));
        reg_inventory.build();

      
        // Map creation
        reg_map.create_map(
            .name("reg_map"), // Just the name bro
            .base_addr(12'h100), // The base address of memory map '
            .n_bytes(2), // The number of bytes of each register
            .endian(UVM_LITTLE_ENDIAN) // Defines order of storage values in fields
        );

        // Adding Registers
        reg_map.add_reg(
            .rg(reg_player), //Register instance
            .offset(8'h0), //Address offset '
            .rights("RW") //Access Policy
        );

        reg_map.add_reg(
            .rg(reg_actions),
            .offset(8'h2),
            .rights("RW")
        );

        reg_map.add_reg(
            .rg(reg_inventory), 
            .offset(8'h4), 
            .rights("RW")
        );

    endfunction : build

endclass : dnd_reg_block


```

## dnd\_reg\_adapter.sv

```cpp

class dnd_reg_adapter extends uvm_reg_adapter;
    `uvm_object_utils(dnd_reg_adapter)


    function new(string name = "dnd_reg_adapter");
        super.new(.name(name));
    endfunction : new

    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw) //Const protects from changing
        
        // Instantiates the transaction
        dnd_seq_item tx;
        tx = dnd_seq_item::type_id::create("tx");

        // Sets the command
        tx.write_en = (rw.kind == UVM_WRITE)

        // Sets the address
        tx.data_addr = rw.addr;


        // Sets the data
        if(tx.write_en)
            tx.data_w = rw.data;
        else
            tx.data_r = rw.data;

        return tx;

    endfunction : reg2bus

    virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw); // Note that now the rw will be modified, so the const wasn't used

        dnd_seq_item tx;

        // Casting the bus_item into the tx

        assert($cast(tx, bus_item))
            else `uvm_fatal("", "Something happened and I cannot convert the bus_item into the uvm_sequence_item tx")

        // Setting values into registers

        if(tx.wr_en == 1'b1)
            rw.kind = UVM_WRITE;
        else
            rw.kind == UVM_READ;

        rw.addr = tx.data_addr;
        rw.data = tx.rdata; // We do'nt need to worry about the wdata, the bus2reg will only receive the output from DUT, so the rdata

        rw_status = UVM_IS_OK;

    endfunction : bus2reg

endclass : dnd_reg_adapter



```


## dnd\_agent.sv


```cpp
    
typedef uvm_sequencer#(dnd_transaction) dnd_sequencer;

class dnd_agent extends uvm_agent;
    `uvm_component_utils(dnd_agent)

    uvm_analysis_port#(dnd_transaction) dnd_ap;

    dnd_driver dnd_drv;
    dnd_monitor dnd_mon;
    dnd_sequencer dnd_sqr;

    dnd_reg_adapter dnd_adapter;


    function new(string name="dnd_agent");
        super.new(.name(name));
        dnd_ap = new("dnd_ap");
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        dnd_drv = dnd_driver::type_id::create("dnd_drv", this);
        dnd_mon = dnd_monitor::type_id::create("dnd_mon", this);
        dnd_sqr = dnd_sequencer::type_id::create("dnd_sqr", this);

        dnd_adapter = dnd_reg_adapter.type_id::create("dnd_adapter");
    endfunction : build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        dnd_drv.seq_item_port.connect(dnd_sqr.seq_item_export);
        dnd_mon.dnd_ap.connect(dnd_ap);

    endfunction : connect_phase
endclass : dnd_agent

```

## dnd\_environment.sv

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
## dnd\_if.sv

```c
interface dnd_if(input logic clk, rst_n);

    logic        write_en;
    logic [31:0] data_w;
    logic [11:0] data_addr;
    logic [31:0] data_r;



    // Driver clocking block

    clocking drv_cb @(posedge clk);
        default input #1 output #1;

        output write_en;
        output data_w;
        output data_addr;
        input  data_r;
    endclocking

    // Monitor clocking block

    clocking mon_cb @(posedge clk);
        default input #1 output #1;

        output data_r;
        input  write_en;
        input data_w;
        input data_addr;
    endclocking 

    // Modports
    modport mst (clocking drv_cb, input clk, rst_n);

    modport slv(clocking mon_cb, input clk, rst_n);

endinterface : dnd_if

```

## dnd\_driver.sv

```c
typedef virtual dnd_if dnd_vif;

class dnd_driver extends uvm_driver #(dnd_transaction);
    `uvm_component_utils(dnd_driver)

    dnd_vif vif;

    function new (string name = "dnd_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(dnd_vif)::get(this, "", "vif", vif))
            `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase


    virtual task run_phase(uvm_phase phase);
        dnd_transaction dnd_tr;
        forever begin
            seq_item_port.get_next(dnd_tr);
            drive_tr(dnd_tr);
            seq_item_port.item_done();
        end
    endtask : run_phase


    virtual task drive_tr(dnd_transaction dnd_tr);

        vif.mst.drv_cb.write_en <= dnd_tr.write_en;
        vif.mst.drv_cb.data_addr <= dnd_tr.data_addr;
        vif.mst.drv_cb.data_w <= dnd_tr.data_w;

        @posedge(vif.mst.drv_cb.clk);
    endtask : drive_tr

endclass : dnd_driver

```

## dnd\_monitor.sv

```c

class dnd_monitor extends uvm_monitor;
    `uvm_component_utils(dnd_monitor)

    uvm_analysis_port #(dnd_transaction) dnd_ap;    

    dnd_vif vif;

    function new (string name = "dnd_monitor", uvm_component parent);
        super.new(name, parent);
        dnd_ap = new("dnd_ap", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase


    virtual task run_phase(uvm_phase phase);
        forever begin
            dnd_transaction dnd_tr;
            @posedge(vif.slv.clk);
            dnd_tr = dnd_transaction::type_id::create(.name("dnd_tr"));
            
            if(vif.monitor_cb.write_en) begin
                dnd_tr.write_en = vif.monitor_cb.write_en;
                dnd_tr.data_w = vif.monitor_cb.data_w;
                dnd_tr.data_addr = vif.monitor_cb.data_addr;
            end else
                dnd_tr.data_r = vif.monitor_cb.data_r;

            dnd_ap.write(dnd_tr);
        end
    endtask : run_phase

endclass : dnd_monitor

```


