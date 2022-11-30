+++
title = "Register Blocks"
hascode = true
date = Date(2019, 3, 22)
rss = "A short description of the page which would serve as **blurb** in a `RSS` feed; you can use basic markdown here but the whole description string must be a single line (not a multiline string). Like this one for instance. Keep in mind that styling is minimal in RSS so for instance don't expect maths or fancy styling to work; images should be ok though: ![](https://upload.wikimedia.org/wikipedia/en/3/32/Rick_and_Morty_opening_credits.jpeg)"

tags = ["syntax", "code"]
+++


# Register Blocks with RAL

\toc


## Overview

Okay, one thing that I like is RPG, so I did this Hands-on about RAL focused in a small register bank with RPG theme.

The bank is very simple. It has only three address (three registers), and it can be observed below:

![Register bank](/assets/memory_map.png)

Where each value is described in following tables:
- To **PLAYER** register:


|    **Field**   | **Position**|                                                **Description**                                             | **Access** |
|:--------------:|:-----------:|:----------------------------------------------------------------------------------------------------------:|:----------:|
| MAX_HEALTH     | [15:10]     | Max Health Points to Player                                                                                | RO         |
| CURRENT_HEALTH | [9:4]       | Current Health Points of Player                                                                            | WR         |
| IS_DEAD        | 3           | 1 -> Fallen Player \\ 0 -> Player alive                                                                    | RO         |
| INITIATIVE     | [2:0]       | Each value represents a modifier:\\ 3'b000 -> +0\\ 3'b001 -> +1\\ 3'b010 -> +2\\ And so on...              | RO         |


- To **ACTIONS** register:

| **Field** | **Position**|                                                                      **Description**                                                                   | **Access** |
|:---------:|:-----------:|:------------------------------------------------------------------------------------------------------------------------------------------------------:|------------|
| Reserved  | [15:6]      | Reserved space                                                                                                                                         | --         |
| DEBUFFS   | [5:4]       | DEBUFF list:\\ 2'b00 -> None\\ 2'b01 -> Stunned\\ 2'b10 -> Sleeping\\ 2'b11 -> Poisoned                                                            | WR         |
| BUFFS     | [3:2]       | BUFF list:\\ 2'b00 -> None\\ 2'b01 -> Haste\\ 2'b10 -> Saving throws advantage \\2'b11 -> Temp. life                                 | WR         |
| ACTION    | [1:0]       | Action list:\\ 2'b00 -> Do nothing 2'b01 -> Move 2'b10 -> Attack 2'b11 -> Take damage                                                                  | WR         |

- To **INVENTORY** register:

| **Field** | **Position**|                                 **Description**                                                    | **Access** |
|:---------:|:-----------:|:--------------------------------------------------------------------------------------------------:|------------|
| DAMAGE    | [15:10]     | Weapon damage.                                                                                     | RO         |
| WEAPON    | [9:0]       | Weapon used. Each number represents a weapon (Not mapped to a name, but use your damn imagination) | WR         |

Okay, so now we can start talking about modeling these registes with RAL. But before, let's take a look in our ambient:

![UVM environment](/assets/zero_percent_diagram.png)

Everything is red because we didn't implement any component, so let's start coloring this diagram.

> You don't need to start the entire ambient with RAL components, in this case I'm doing this because the main goal of this Hands-on is to guide you into insert RAL in your ambient, explaining how each component works. The more general components won't be detailed, but the complete code will be shown somewhere in the hands-on.

## Register_fields

Fields are used to represent contiguous bit sequences. One single register can contain more than one field, and each one have your particular access policy.

In SystemVerilog, we declare a field using the keyword `uvm_reg_field`. so, let's start modeling our register bank declaring the respective fields. This will be done in a register file, that will be
explained in the following sections. I'm gonna show how it is done to the **PLAYER** register, and you can implement to the other registers following the same logic. The complete code will be available at **Source Code** page.

```cpp
class dnd_player_reg extends uvm_reg;
    `uvm_object_utils(dnd_player_reg)

    //Fields declaration
    rand uvm_reg_field max_health;
    rand uvm_reg_field current_health;
    rand uvm_reg_field is_dead;
    rand uvm_reg_field initiative;

    ...

```
The rest you will discover in the next section, and it is now!

## Register

A register is basically a group of fields in a same address in a given memory map. Taking our example, we have three registers. Each one will be modeled in a class that will
extend the `uvm_reg` class from UVM. At this class, first we declare the fields (Already done), then we define the constructor of the class. The `super.new()` will receive some parameters, as show below:

```cpp

    function new(string name="dnd_player_reg");
        super.new(.name(name), .n_bits(16), .has_coverage(UVM_NO_COVERAGE));
    endfunction : new

```

the first parameter doesn't need explanation, it is just the name associated to the object. The second parameter (`n_bits`) will tell the size of that register in bits, and the last parameter (`has_coverage`) will tell if this register will be mapped to a coverage.

Now that we have declared our fields and defined the Constructor of our register, let's configure the fields using the following function:

> Do not think that this `build()` is related to the `build_phase()` function of `uvm_component`. The `uvm_reg` is not an `uvm_component`, it is an `uvm_object` (A parent class of `uvm_component`, so it doesn't have the methods of child).


```cpp
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
            .individually_accessible(1) // When write() is called, the entire register is written
        );


    endfunction : build

```

At this point, you may have noticed that the process is repetitive and boooring. We are enginneers, and we are programmers. Everything that is repetitive and boring we can transform into code to automatize. Let's automatize the configure write with a little script in julia language.

```julia:./register_auto.jl
current_health = ["current_health", "this", "6", "4", "RW", "0", "0", "1", "1", "1"]
is_dead = ["is_dead", "this", "1", "3", "RO", "1", "0", "1", "1", "1"]
initiative = ["initiative", "this", "3", "0", "RO", "1", "0", "1", "1", "1"]

player = [current_health, is_dead, initiative]

for field in player
    println("```cpp")
    println("$(field[1]).configure(")
    println("   .parent($(field[2])),")
    println("   .size($(field[3])),")
    println("   .lsb_pos($(field[4])),")
    println("   .access($(field[5])),")
    println("   .volatile($(field[6])),")
    println("   .reset($(field[7])),")
    println("   .has_reset($(field[8])),")
    println("   .is_rand($(field[9])),")
    println("   .individually_accessible($(field[10]))")
    println(");")
    println("```")
end
```

\textoutput{./register_auto.jl}


Note that with these lines we just have to write the values of each field, run a loop and the program writes the file to us :D. The inputs can came from a csv file, by example, and all register can be written this way.

Now, we have our first file. The **dnd\_player\_reg.sv**

## Register Block

A Register block is a major module that will encapsulate the registers of a given DUT. Each register class created until here will be instantiated inside the Register Block class. This class can also be called Register Package. The steps to create a register block are described below:
- Extends `uvm_reg_block`
- Instantiates registers
- Instantiates memory map
- Create constructor
- Build registers
- Build memory map associting each register to a given address

Let's go step by step. First, let's instantiate all register and the memory map

```cpp
class dnd_reg_block extends uvm_reg_block;
    `uvm_object_utils(dnd_reg_block)

    // Instantiates register models
    rand dnd_player_reg reg_player;
    rand dnd_actions_reg reg_actions;
    rand dnd_inventory_reg reg_inventory;

    // Instantiates memory map
    uvm_reg_map reg_map;

    ...

```

Now, the next steps will be creating the constructor and then building the registers. It is very simple to do this:

```cpp

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

        ...

    endfunction : build

```

We are almost finishing the Register modeling part of RAL. The last thing we must do is build the memory map. We will use the function `create_map()` to create the memory map. Then,
we will use the function `add_reg()` to add each register.


```cpp
        
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
And now, we have our first component written, the UVM diagram now is:


![UVM environment](/assets/some_percent_diagram_01.png)


In the next section, we will se what is the adapter and how it works.