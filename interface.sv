interface inf(input logic clk,rst);
  
  //declare the signals
  logic       enable;
  logic       rd_wr;
  logic [1:0] addr;
  logic [7:0] wr_data;
  logic [7:0] rd_data;
  logic [15:0] res_out;               // Output result from ALU

  modport DUT  (input clk, rst, enable, rd_wr, addr,wr_data, output rd_data,res_out);
  
endinterface


