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
            .offset(8'h0), 
            .rights("RW")
        );

    endfunction : build

endclass : dnd_reg_block


```