+++
title = "A little breath"
+++


\toc

# The missing inner components

Let's take a breath with all the new RAL stuff to see something that we already know:
- Interface
- DUT
- Monitor
- Driver
- Transaction

This entire page can be skipped and the full code can be obtained at **Source Code** page if your only goal is to learn the RAL components. But I
think it is important to know at least the interface and transaction, once the RAL commmunicates with this last one.

## The Interface

The interface is very simple. The block diagram is shown below:


![Interface diagram](/assets/interface.png)


The functionality is very intuitive. If `valid = 1'b1`:

- If the `write_en` rises, then the `addr` and `data_w` must be passed together.
- If the `write_en` is at low level, the output `data_r` will send the reading from the addr passed by `addr`.

The interface will have two clocking blocks, one to driver and another to monitor. It will also have two modports, a master and slave.


```verilog
interface cthulhu_interface(input logic clk,rst_n);
  
  logic [11:0] addr;
  logic        write_en;
  logic        valid;
  logic [7:0]  data_w;
  logic [7:0]  data_r;
  
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output addr;
    output write_en;
    output valid;
    output data_w;
    input  data_r;  
  endclocking
  

  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input addr;
    input write_en;
    input valid;
    input data_w;
    input data_r;  
  endclocking
  

  modport DRIVER  (clocking driver_cb,input clk,rst_n);
  modport MONITOR (clocking monitor_cb,input clk,rst_n);
  
endinterface : cthulhu_interface

```

## The DUT

Okay, I'm not a Designer, I'm a Verifier, so ignore any bad practice in this implementation. The DUT will consist in basically two `always_ff`, the first will write/read from registers. The second will update the Read-only values given some conditions explained at [Register Block](/register_block/) page.
So, the code will be like:

```verilog
module cthulhu_manager(
    input         clk,
    input         rst_n,
    input  [11:0] addr,
    input         write_en,
    input         valid,
    input  [7:0]  data_w,
    output [7:0]  data_r
);

    life_st life; 
    sanity_st sanity;
    status_st status;
	
  	logic [7:0] t_data;
  
  	
    assign data_r = t_data;
    
  
    always_ff@(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            life   <= 0;
            sanity <= 0;
        end
        else if(write_en & valid) begin
            case(addr)
                12'h100: life   <= data_w;
                12'h200: sanity <= data_w;
                default: life   <= data_w;
            endcase
        end
      	else if (!write_en & valid) begin
        	case(addr)
              12'h300: t_data <= status;
              default: t_data <= 8'b0;
            endcase
      	end
    end

    always_ff@(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            status <= 0;
        end
        else begin
            if(life.current_health == 'h0) begin
                status.is_dead <= 1'b1;
                status.is_wounded <= 1'b0;
                status.is_healthy <= 1'b0;
            end else if(life.current_health < life.max_health/2) begin
                status.is_dead <= 1'b0;
                status.is_wounded <= 1'b1;
                status.is_healthy <= 1'b0;
            end else begin
                status.is_dead <= 1'b0;
                status.is_wounded <= 1'b0;
                status.is_healthy <= 1'b1;
            end

            if(sanity.current_sanity == 'h0) begin
                status.is_mad <= 1'b1;
                status.is_going_mad <= 1'b0;
                status.is_sane <= 1'b0;
            end else if(sanity.current_sanity <= sanity.max_sanity/2) begin
                status.is_mad <= 1'b0;
                status.is_going_mad <= 1'b1;
                status.is_sane <= 1'b0;
            end else begin
                status.is_mad <= 1'b0;
                status.is_going_mad <= 1'b0;
                status.is_sane <= 1'b1;
            end

        end
    end


endmodule : cthulhu_manager

```

## The Driver and monitor

There is no big deal with Driver and monitor. The complete code will be available at [Source Code](/source_code/).

## Transaction

The transaction also is very simple:

```verilog
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

```

Now, our diagram is more colored:

![UVM diagram](/assets/some_percent_diagram_05.png)