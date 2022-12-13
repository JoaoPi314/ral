+++
title = "Source Code"
+++

# Source Code

\toc

## cthulhu\_life\_reg.sv

```verilog
class cthulhu_life_reg extends uvm_reg;
	`uvm_object_utils(cthulhu_life_reg)
   
	//***************************************
	//* Field instantiation                 *
	//***************************************
	rand uvm_reg_field current_health;
	rand uvm_reg_field max_health;
	

	
	function new (string name = "cthulhu_life_reg");
		super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
	endfunction

	virtual function void build(); 
		
		// Creation of the field
		max_health = uvm_reg_field::type_id::create("max_health");   

		// Configuration of the field
		max_health.configure(.parent(this), 
						.size(4), 
						.lsb_pos(4), 
						.access("WO"),  
						.volatile(0), 
						.reset(4'hf), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 

	
		current_health = uvm_reg_field::type_id::create("current_health");   
		current_health.configure(.parent(this), 
						.size(4), 
						.lsb_pos(0), 
						.access("WO"),  
						.volatile(0), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 
	endfunction : build
endclass : cthulhu_life_reg
```

## cthulhu\_sanity\_reg.sv

```verilog
class cthulhu_sanity_reg extends uvm_reg;
	`uvm_object_utils(cthulhu_sanity_reg)
   
	//***************************************
	//* Field instantiation                 *
	//***************************************
	rand uvm_reg_field current_sanity;
	rand uvm_reg_field max_sanity;
	

	
	function new (string name = "cthulhu_sanity_reg");
		super.new(.name(name), .n_bits(8), .has_covergae(UVM_NO_COVERAGE));
	endfunction

	
	function void build; 
		
		max_sanity = uvm_reg_field::type_id::create("max_sanity");   
		max_sanity.configure(.parent(this), 
						.size(4), 
						.lsb_pos(4), 
						.access("WO"),  
						.volatile(0), 
						.reset(4'hf), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 

	
		current_sanity = uvm_reg_field::type_id::create("current_sanity");   
		current_sanity.configure(.parent(this), 
						.size(4), 
						.lsb_pos(0), 
						.access("WO"),  
						.volatile(0), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(0)); 
    endfunction : build
endclass : cthulhu_sanity_reg

```

## cthulhu\_status_\_reg.sv

```verilog
class cthulhu_status_reg extends uvm_reg;
	`uvm_object_utils(cthulhu_status_reg)
   
	//***************************************
	//* Field instantiation                 *
	//***************************************
	rand uvm_reg_field is_dead;
	rand uvm_reg_field is_wounded;
    rand uvm_reg_field is_healthy;
    rand uvm_reg_field is_mad;
    rand uvm_reg_field is_going_mad;
    rand uvm_reg_field is_sane;
    rand uvm_reg_field reserved;

	
	function new (string name = "cthulhu_status_reg");
		super.new(.name(name), .n_bits(8), .has_coverage(UVM_NO_COVERAGE));
	endfunction


	function void build; 
		
		is_dead = uvm_reg_field::type_id::create("is_dead");   
		is_dead.configure(.parent(this), 
						.size(1), 
						.lsb_pos(0), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 

	
		is_wounded = uvm_reg_field::type_id::create("is_wounded");   
		is_wounded.configure(.parent(this), 
						.size(1), 
						.lsb_pos(1), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 


		is_healthy = uvm_reg_field::type_id::create("is_healthy");   
		is_healthy.configure(.parent(this), 
						.size(1), 
						.lsb_pos(2), 
						.access("RO"),  
						.volatile(1), 
						.reset(1'b1), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1));

		is_mad = uvm_reg_field::type_id::create("is_mad");   
		is_mad.configure(.parent(this), 
						.size(1), 
						.lsb_pos(3), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 

	
		is_going_mad = uvm_reg_field::type_id::create("is_going_mad");   
		is_going_mad.configure(.parent(this), 
						.size(1), 
						.lsb_pos(4), 
						.access("RO"),  
						.volatile(1), 
						.reset(0), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 


		is_sane = uvm_reg_field::type_id::create("is_sane");   
		is_sane.configure(.parent(this), 
						.size(1), 
						.lsb_pos(5), 
						.access("RO"),  
						.volatile(1), 
						.reset(1'b1), 
						.has_reset(1), 
						.is_rand(1), 
						.individually_accessible(1)); 
    endfunction : build
endclass : cthulhu_status_reg

```

## cthulhu\_reg\_block.sv

```verilog
class cthulhu_reg_block extends uvm_reg_block;
    `uvm_object_utils(cthulhu_reg_block)
    
    //***************************************
    //* Register instantiation              *
    //***************************************
    
    cthulhu_life_reg ct_life_reg;
    cthulhu_sanity_reg ct_sanity_reg;
    cthulhu_status_reg ct_status_reg;

    uvm_reg_map reg_map;
    
   
    function new (string name = "");
      super.new(.name(name), .has_coverage(UVM_NO_COVERAGE));
    endfunction
  

    virtual function void build();
      
      // Creation, build and configuration
      ct_life_reg = cthulhu_life_reg::type_id::create("ct_life_reg");
      ct_life_reg.build();
      ct_life_reg.configure(this);
   
      ct_sanity_reg = cthulhu_sanity_reg::type_id::create("ct_sanity_reg");
      ct_sanity_reg.build();
      ct_sanity_reg.configure(this);
      
      ct_status_reg = cthulhu_status_reg::type_id::create("ct_status_reg");
      ct_status_reg.build();
      ct_status_reg.configure(this);
    

      // Map creation
      reg_map.create_map(
          .name("reg_map"), // Just the name bro
          .base_addr(12'h100), // The base address of memory map '
          .n_bytes(1), // The number of bytes of each register
          .endian(UVM_LITTLE_ENDIAN) // Defines order of storage values in fields
      );

      // Adding Registers
      reg_map.add_reg(
          .rg(ct_life_reg), //Register instance
          .offset('h000),   //Address offset '
          .rights("WO")     //Access Policy
      );

      reg_map.add_reg(
          .rg(ct_sanity_reg),
          .offset('h100),
          .rights("WO")
      );

      reg_map.add_reg(
          .rg(ct_status_reg), 
          .offset('h200), 
          .rights("RO")
      );

    lock_model();
    endfunction : build
  endclass : cthulhu_reg_block
```

## cthulhu\_adapter.sv

```verilog

class cthulhu_adapter extends uvm_reg_adapter;
	`uvm_object_utils (cthulhu_adapter)

	function new(string name = "cthulhu_adapter");
		super.new(name);
	endfunction

	function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
		cthulhu_transaction tx;    
		tx = cthulhu_transaction::type_id::create("tx");
		
		tx.write_en = (rw.kind == UVM_WRITE);
		tx.addr  = rw.addr;
		if (tx.write_en)  tx.data_w = rw.data;
		if (!tx.write_en) tx.data_r = rw.data;

		return tx;
	endfunction : reg2bus

	function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
		cthulhu_transaction tx;
		
		assert( $cast(tx, bus_item) )
		else `uvm_fatal("", "A bad thing has just happened in my_adapter")

		rw.kind = tx.write_en ? UVM_WRITE : UVM_READ;
		rw.addr = tx.addr;
		rw.data = tx.data_r;
		
		rw.status = UVM_IS_OK;
	endfunction : bus2reg
endclass : cthulhu_adapter

```


## cthulhu\_agent.sv

```verilog
 class cthulhu_agent extends uvm_agent;
	`uvm_component_utils(cthulhu_agent)

	typedef uvm_sequencer#(cthulhu_transaction) cthulhu_sequencer;

	cthulhu_driver      driver;
	cthulhu_sequencer   sequencer;
	cthulhu_monitor     monitor;
	cthulhu_adapter     m_adapter;

	uvm_analysis_port#(cthulhu_transaction) cthulhu_ap;

	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cthulhu_ap = new(.name("cthulhu_ap"), .parent(this));

		monitor = cthulhu_monitor::type_id::create("monitor", this);

		if(get_is_active() == UVM_ACTIVE) begin
			driver    = cthulhu_driver::type_id::create("driver", this);
			sequencer = cthulhu_sequencer::type_id::create("sequencer", this);
		end
		
		m_adapter = cthulhu_adapter::type_id::create("m_adapter",, get_full_name());

	endfunction : build_phase
	

	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE) begin
			driver.seq_item_port.connect(sequencer.seq_item_export);
		end
		
		monitor.item_collected_port.connect(cthulhu_ap);
		
	endfunction : connect_phase

endclass : cthulhu_agent

```

## cthulhu\_environment.sv

```verilog
typedef uvm_reg_predictor#(cthulhu_transaction) cthulhu_reg_predictor;

class cthulhu_environment extends uvm_env;
	`uvm_component_utils(cthulhu_environment)
  
	cthulhu_agent      		cthulhu_agnt;
	cthulhu_reg_predictor 	cthulhu_pred;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cthulhu_agnt = cthulhu_agent::type_id::create("cthulhu_agnt", this);
	
		cthulhu_pred = cthulhu_reg_predictor::type_id::create("cthulhu_pred", this);
		
	endfunction : build_phase
	

	function void connect_phase(uvm_phase phase);
		cthulhu_pred.adapter = cthulhu_agnt.m_adapter;
		cthulhu_agnt.cthulhu_ap.connect(cthulhu_pred.bus_in);
	endfunction : connect_phase

endclass : cthulhu_environment

```

## cthulhu_interface.sv

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

## cthulhu_transaction.sv

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

## cthulhu\_driver.sv

```verilog
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

```

## cthulhu\_monitor.sv

```verilog
class cthulhu_monitor extends uvm_monitor;
	`uvm_component_utils(cthulhu_monitor)


	ct_vif vif;
	uvm_analysis_port #(cthulhu_transaction) item_collected_port;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
		item_collected_port = new("item_collected_port", this);
	endfunction : new


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(ct_vif)::get(this, "", "vif", vif))
		`uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
	endfunction: build_phase
	

	virtual task run_phase(uvm_phase phase);
		forever begin
		cthulhu_transaction trans_collected;
		trans_collected = new();
		@(posedge vif.MONITOR.clk);
		wait(vif.monitor_cb.valid);
			trans_collected.addr = vif.monitor_cb.addr;
			trans_collected.write_en = vif.monitor_cb.write_en;
		
		if(vif.monitor_cb.write_en) begin
			trans_collected.write_en = vif.monitor_cb.write_en;
			trans_collected.data_w = vif.monitor_cb.data_w;
			@(posedge vif.MONITOR.clk);
		end
		else begin
			@(posedge vif.MONITOR.clk);
			@(posedge vif.MONITOR.clk);
			trans_collected.data_r = vif.monitor_cb.data_r;
		end
		item_collected_port.write(trans_collected);
		end 
	endtask : run_phase

endclass : cthulhu_monitor
```

## cthulhu\_manager.sv

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

## cthulhu\_reg\_sequence.sv

```verilog
class cthulhu_reg_sequence extends uvm_sequence;
	`uvm_object_utils(cthulhu_reg_sequence)
	
	cthulhu_reg_block regmodel;
	

	function new(string name = "cthulhu_reg_sequence"); 
		super.new(name);    
	endfunction
   
	task body;  
		uvm_status_e   status;
		uvm_reg_data_t incoming;
		
		if (starting_phase != null)
			starting_phase.raise_objection(this);
		
		//Write to the Registers
		regmodel.ct_sanity_reg.write(status, 8'F5);
		regmodel.ct_life_reg.write(status, 8'F0);
		
		//Read from the registers
		regmodel.ct_status_reg.read(status, incoming);
		
		if (starting_phase != null)
			starting_phase.drop_objection(this);  
		
	endtask: body
endclass : cthulhu_reg_sequence
```

## cthulhu\_base\_test.sv

```verilog
class cthulhu_base_test extends uvm_test;
    `uvm_component_utils(cthulhu_base_test)
    
  
    cthulhu_environment env;
    cthulhu_reg_block   regmodel;   
  
  
    function new(string name = "cthulhu_base_test",uvm_component parent=null);
        super.new(name,parent);
    endfunction : new
  
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        regmodel = cthulhu_reg_block::type_id::create("regmodel", this);
        regmodel.build();
         
        env = cthulhu_environment::type_id::create("env", this);
    endfunction : build_phase

    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    
        env.cthulhu_pred.map = regmodel.reg_map;
        regmodel.reg_map.set_sequencer(.sequencer(env.cthulhu_agnt.sequencer), .adapter(env.cthulhu_agnt.m_adapter) );
        regmodel.default_map.set_base_addr('h100);      
    endfunction : connect_phase
    

    virtual function void end_of_elaboration();
        print();
    endfunction
  

   function void report_phase(uvm_phase phase);
    uvm_report_server svr;
    super.report_phase(phase);
    
    svr = uvm_report_server::get_server();
    if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
        `uvm_info(get_type_name(), "***************************************", UVM_NONE)
        `uvm_info(get_type_name(), "****   FAILED, YOU ARE GOING MAD   ****", UVM_NONE)
        `uvm_info(get_type_name(), "***************************************", UVM_NONE)
    end
    else begin
        `uvm_info(get_type_name(), "***************************************", UVM_NONE)
        `uvm_info(get_type_name(), "*** PASSED, THE GREAT ONE GOES AWAY ***", UVM_NONE)
        `uvm_info(get_type_name(), "***************************************", UVM_NONE)
    end
    endfunction 
  
endclass : cthulhu_base_test
  
```

## cthulhu\_reg\_test.sv

```verilog
class cthulhu_reg_test extends cthulhu_base_test;
  	`uvm_component_utils(cthulhu_reg_test)

  	cthulhu_reg_sequence reg_seq;


	function new(string name = "cthulhu_reg_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new


	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		reg_seq = cthulhu_reg_sequence::type_id::create("reg_seq");
	endfunction : build_phase
	

	task run_phase(uvm_phase phase);
		
		phase.raise_objection(this);
		if ( !reg_seq.randomize() ) `uvm_error("", "Randomize failed")
		reg_seq.regmodel       = regmodel;
		reg_seq.starting_phase = phase;
		reg_seq.start(env.cthulhu_agnt.sequencer); 
		phase.drop_objection(this);
		
		//set a drain-time for the environment if desired
		phase.phase_done.set_drain_time(this, 50);
	endtask : run_phase
  
endclass : cthulhu_reg_test
```

## testbench.sv

```verilog
module tbench_top;

  bit clk;
  bit rst_n;

  always #5 clk = ~clk;

  initial begin
    rst_n = 1;
    #5 rst_n = 0;
    #5 rst_n = 1;
  end

  cthulhu_interface intf(clk,rst_n);
  

  cthulhu_manager DUT (
    .clk(intf.clk),
    .rst_n(intf.rst_n),
    .addr(intf.addr),
    .write_en(intf.write_en),
    .valid(intf.valid),
    .data_w(intf.data_w),
    .data_r(intf.data_r)
   );
  

  initial begin 
    uvm_config_db#(virtual cthulhu_interface)::set(uvm_root::get(),"*","vif", intf);
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  initial begin 
    run_test();
  end
  
endmodule

```
