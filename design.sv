// Code your design here
///////////////////////////////////////////////////////////////////////////
// MODULE               : MEM +ALU                                       //
//                                                                       //
// DESIGNER             : feras                                          //
//                                                                       //
// system Verilog code for MEM +ALU                                      //
//																		 //
//                                                                       //
/////////////////////////////////////////////////////////////////////////////
`include "ALU.sv"
`include "memory.sv"
module ALU_With_Memory (inf.DUT i_inf);       // Output result from ALU


  logic [7:0] A_reg, B_reg,execute,operation_reg;      
  logic[16:0] ALU_res_out;

  
  memory mem (.clk(i_inf.clk), .rst(i_inf.rst), .enable(i_inf.enable), .rd_wr(i_inf.rd_wr), .addr(i_inf.addr), .wr_data(i_inf.wr_data), .rd_data(i_inf.rd_data), .OPER(operation_reg) , .A_reg(A_reg) ,.B_reg(B_reg) , .execute(execute) );

    


  ALU alu (.A(mem.A_reg),.B(mem.B_reg),.OPER(mem.OPER), .execute(mem.execute), .res_out(ALU_res_out));
  
  
/*  always_ff @(posedge i_inf.clk ) begin
    $display("- execute = %d",alu.execute);
    $display("- OPER = %d",alu.OPER);
    $display("- A_reg = %d",alu.A);
    $display("- b_reg = %d",alu.B);
 //   $display("- ALU_res_out = %d",alu.res_out);
    if( i_inf.enable)
    i_inf.res_out = alu.res_out ;
  end    
 */
 assign i_inf.res_out = i_inf.enable ?  ALU_res_out :i_inf.res_out ;

endmodule
