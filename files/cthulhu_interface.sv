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