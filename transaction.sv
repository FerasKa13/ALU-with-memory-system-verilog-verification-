class transaction;
  
  //declare the transaction fields
  rand bit [1:0] addr;
  rand bit [7:0] wr_data;
  rand bit enable ;
  rand bit rd_wr ;
       bit [7:0] rd_data;
	   bit [15:0] res_out;
  constraint enable_dist{
    enable dist{1 := 90,0 := 10};
  }
  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
	$display("- Address = %0d, Enable = %0d, Write Data = %0d, Operation: %s", 
         addr, enable, wr_data, (rd_wr ? "Read" : "Write"));
    $display("- rd_data = %d",rd_data);
    $display("- res_out = %d",res_out);
    $display("-------------------------");
    
  endfunction 
endclass

