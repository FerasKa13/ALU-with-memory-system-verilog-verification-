// Code your design here
///////////////////////////////////////////////////////////////////////////
// MODULE               : memory                                        //
//                                                                       //
// DESIGNER             : feras                               //
//                                                                       //
// system Verilog code for memroy                                       //
//	 //
//                                                                       //
///////////////////////////////////////////////////////////////////////////


module memory #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 2) (
    input clk,
    input rst,
    input enable,
    input rd_wr,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data,
    output reg [DATA_WIDTH-1:0] A_reg,
    output reg [DATA_WIDTH-1:0] B_reg,
    output reg [DATA_WIDTH-1:0] OPER,
    output reg [16:0] execute 
);
//output reg [DATA_WIDTH-1:0] rd_data;
//input [ADDR_WIDTH-1:0] addr;
//input[DATA_WIDTH-1:0] wr_data;
//input clk, rst, enable,rd_wr;=
// Define a memory array with 8 locations, each 8 bits wide

reg [DATA_WIDTH-1:0] mem[0:2**ADDR_WIDTH-1];
//reg [DATA_WIDTH-1:0] current_data_ref ;

integer  j; 
always @(posedge clk or posedge rst) begin
 
    if (rst) begin
        for (j = 0; j < 2**ADDR_WIDTH; j = j + 1) begin
            mem[j] = 8'hFF;
        end
    end
    else if (enable) begin
        if (!rd_wr) begin    // enable =1 , rst=1 , wr =0 // Write case
            mem[addr] <= wr_data;
	end
	else begin  		//   enable =1 , rst=1 , wr =0 // Read case
 	rd_data <= mem[addr] ;
 	end
       end
   //  current_data_ref <= mem[addr];   //refernce to the current data
    end

//////////////////////////////ALU inputs ////////////////////////////////
always_ff @(posedge i_inf.clk or posedge i_inf.rst) begin
    if (i_inf.rst) begin
            A_reg         <= 8'b0;
            B_reg         <= 8'b0;
            OPER		  <= 8'b0;
            execute       <= 8'b0;
        end 
    else if (i_inf.enable && i_inf.rd_wr == 1'b1) begin  // Read from memory
            case (i_inf.addr)
                2'd0: A_reg         <= mem[addr]; // Read value for A
                2'd1: B_reg         <= mem[addr]; // Read value for B
                2'd2: OPER 			<= mem[addr]; // Read operation
                2'd3: execute       <= mem[addr]; // Read execute flag
            endcase
        end
    /*  $display("A = %d",A_reg);
      $display("Ab = %d",B_reg);
       $display("OPER = %d",OPER[2:0]);
      $display("execute = %d",execute[0]);*/
  
    end

 
 

endmodule 