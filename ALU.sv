// Code your design here
///////////////////////////////////////////////////////////////////////////
// MODULE               : ALU                                            //
//                                                                       //
// DESIGNER             : feras                                          //
//                                                                       //
// system Verilog code for ALU                                           //
//																		 //
//                                                                       //
///////////////////////////////////////////////////////////////////////////
module ALU (
    input  logic [7:0] A, B, OPER ,execute  ,      // Operands A and B (8-bit)
    output logic [15:0] res_out      // Result (16-bit)
);
    always_comb begin
     if (execute[0] == 1'b1) begin  
        case (OPER[2:0])  // Only check the 3 least significant bits
                3'b000: res_out  = 0;                // No operation
                3'b001: res_out = A + B;             // Addition
                3'b010: res_out = A - B;             // Subtraction
                3'b011: res_out = A * B;             // Multiplication
                3'b100: res_out = (B != 0) ? A / B : 16'hDEAD;  // Division (error case handled)
          
                default: res_out = res_out;          // Maintain previous value
            endcase
        
      //      default: res_out = res_out;      // Maintain previous value
        
     end  
     
    //  $display("ALU________res_out = %d",res_out);
    end
endmodule
