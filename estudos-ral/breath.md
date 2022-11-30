+++
title = "A little breath"
+++


\toc

# The missing inner components


Let's take a breath with all the new RAL stuff to see something that we already know:
- Monitor
- Driver
- Interface
- Transaction


This entire page can be skipped and the full code can be obtained at **Source Code** page if your only goal is to learn the RAL components. But I
think it is important to know at least the interface and transaction, once the RAL commmunicates with this last one.



## The Interface

The interface is very simple. The block diagram is shown below:


![Interface diagram](/assets/interface.png)


The functionality is very intuitive:

- If the _write\_en_ rises, then the _data\_addr_ and _data\_w_ must be passed together.
- If the _write\_en_ is at low level, the output _data\_r_ will send the reading from the addr passed by _data\_addr_.

The interface will have two clocking blocks, one to driver and another to monitor. It will also have two modports, a master and slave.


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

## The DUT

Okay, I'm not a Designer, I'm a Verifier, so ignore any bad practice in this implementation. The DUT will consist in basically two `always_ff`, the first will write/read from registers. The second will update the Read-only values given some conditions. The conditions are:

- If **CURRENT\_HEALTH** is less than zero, then **IS_DEAD** will store 1'b1;
- **INITIATIVE** will be +2 by default. If **BUFFS** is equal to _Haste_, then the **INITIATIVE** will be equal to +4;
- **MAX_HEALTH** will be always 'd50;
- **DAMAGE** will have one value to each of these **WEAPON_TYPES**:
    - 'd0 &rarr; 'd5;
    - 'd1 &rarr; 'd10;
    - 'd2 &rarr; 'd20;
    - default: &rarr; 'd5;
- **CURRENT_HEALTH** will update if the **ACTION** is take damage, decreasing 1 of current value.

So, the code will be like:

```c
module dnd_character_management(
    input        clk,
    input        rst_n,
    input        write_en,
    input [15:0] data_w,
    input [11:0] data_addr,

    output [31:0] data_r
);

    logic [15:0] data_t;

    //Registers
    logic [15:0] player_reg;
    logic [15:0] actions_reg;
    logic [15:0] inventory_reg;

    // Reset
    always @(negedge rst_n) begin
        player_reg <= {6'd50, 6'd50, 1'b0, 3'b10};
        actions_reg <= 'd0;
        inventory_reg <= {6'd5, 10'd0};
    end

    assign data_r = data_t;

    always_ff@(posedge clk) begin
        if(wr_en) begin
            case data_addr
                12'h100 : player_reg[9:4] <= data_w[9:4];
                12'h102 : actions_reg <= data_w;
                12'h104 : inventory_reg[9:0] <= data_w[9:0];
                default: begin
                    player_reg[9:4] <= 6'd0;
                    actions_reg <= 16'd0;
                    inventory_reg[9:0] <= 10'd0;
                end
            endcase
        end else begin
            case data_addr
                12'h100: t_data = player_reg;
                12'h102: t_data = actions_reg;
                12'h104: t_data = inventory_reg;
            endcase
        end
    end


    always_ff@(posedge clk) begin
        
        // First condition
        if(player_reg[9:4] <= 0)
            player_reg[3] <= 1'b1;
        else
            player_reg[3] <= 1'b0;

        // Second condition
        if(actions_reg[3:2] == 2'b01)
            player_reg[2:0] <= 3'b010;
        else
            player_reg[2:0] <= 3'b100;
        
        // Third condition
        case inventory_reg[9:0]
            10'd0: inventory_reg[15:10] <= 'd5;
            10'd1: inventory_reg[15:10] <= 'd10;
            10'd2: inventory_reg[15:10] <= 'd20;
            default: inventory_reg[15:10] <= 'd5;
        endcase

        // Fourth condition

        if(actions_reg[1:0] == 2'b11)
            player_reg[9:4] <= player_reg[9:4] - 1'b1;


    end
    

endmodule : dnd_character_management

```