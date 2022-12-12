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