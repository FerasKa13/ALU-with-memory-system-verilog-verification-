//gets the packet from the monitor, generates the expected results 
//and compares with the actual results received from the monitor

class scoreboard;
   
  //create mailbox handle
  mailbox mon2scbin;
  mailbox mon2scbout;
  
  //count the number of transactions
  int num_transactions;
//////////////////////// Reference model //////////////////////////////////////////////

reg [7:0] mem_ref[0:7] = '{default: 8'hFF};
  reg[7:0] ref_addr;
  reg [15:0] ref_out =0 ;
  reg [7:0] ref_A=0, ref_B =0;         // Operands A and B (8-bit)
  reg  [7:0] ref_OPER ;        // Operation code (3-bit)
  reg [7:0] ref_execute =0;

  int err =0 ;
  int corr= 0;
    int err_alu =0 ;
  int corr_alu= 0;

//////////////////////////////////////////////////////////////////
  
  //constructor
  function new(mailbox mon2scbin, mailbox mon2scbout);
    //get the mailbox handle from  environment 
    this.mon2scbin = mon2scbin;
    this.mon2scbout = mon2scbout;

  endfunction
  
  

  
  //Compare the actual results with the expected results
  task main;
    transaction trans_in;
    transaction trans_out;
    forever begin
      mon2scbin.get(trans_in); 
      mon2scbout.get(trans_out);
      if(trans_in.enable ==1 ) 
        if( trans_in.rd_wr == 0) //write case
          mem_ref[trans_in.addr] <= trans_in.wr_data;
      else if(trans_in.rd_wr == 1 ) begin// read case
        ref_addr =mem_ref[trans_in.addr];
		case (trans_in.addr)
                2'd0: ref_A  = mem_ref[trans_in.addr]; // Read value for A
                2'd1: ref_B    = mem_ref[trans_in.addr]; // Read value for B
        	    2'd2: ref_OPER = mem_ref[trans_in.addr]; // Read operation
                2'd3: ref_execute  = mem_ref[trans_in.addr]; // Read execute flag
		endcase	
        
        if(ref_execute[0] == 1'b1) begin 

		 case (ref_OPER[2:0])
            3'b000: ref_out = 0;             // No operation
            3'b001: ref_out = ref_A + ref_B;         // Addition
            3'b010: ref_out = ref_A - ref_B;         // Subtraction
            3'b011: ref_out = ref_A * ref_B;      //Multiplication
            3'b100: ref_out = (ref_B != 0) ? ref_A / ref_B : 16'hDEAD;  // Division (error case handled)
           
          
            default: ref_out = ref_out;      // Maintain previous value	
         
      endcase
          end
       
  /*      $display("- ref_addr = %d",ref_addr);
        $display("- ref_A = %d",ref_A);
        $display("- ref_B = %d",ref_B);
        $display("- ref_execute = %d",ref_execute[0]);
        $display("- ref_OPER = %d",ref_OPER[2:0]);
        $display("- ref_out = %d",ref_out);
        $display("- trans_out.res_out = %d",trans_out.res_out);*/
        
        if (ref_execute[0] == 1'b1 ) begin
		if(ref_out == trans_out.res_out)begin
	    	corr_alu++;
          $display("***********Result ALU is as Expected************");
			end
		else begin
		 err_alu++;
          $error("Wrong alu Result.\n\tExpeced: %0d Actual: %0d",(ref_out ),trans_out.res_out);     
			end
		end //execute =0 
					
		
        if(trans_out.rd_data == mem_ref[trans_in.addr])begin
        	corr++;
          $display("***********Result Mem is as Expected************");
        end
	
        else begin
          err++;
          $error("Wrong Result.\n\tExpeced: %0d Actual: %0d",(mem_ref[trans_in.addr] ),trans_out.rd_data);     
        end
        end
      
      num_transactions++;
      trans_in.display("[ --Scoreboard_in-- ]");
   //    $display("- ref_count = %d",ref_count);
      trans_out.display("[ --Scoreboard_out-- ]");
      $display("- correct  = %0d, ******** error = %0d" , corr ,err );
      $display("- ALU_correct  = %0d, ******** ALU_error = %0d" , corr_alu ,err_alu );
    end
  endtask
  
endclass