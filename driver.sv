//gets the packet from the generator and drives the transaction packet items into the interface 
//the interface is connected to the DUT, so that items driven into the interface will be driven 
//into the DUT

class driver;
  
  //count the number of transactions
  int num_transactions;
  
  //create virtual interface handle
  virtual inf vinf;
  
  //create mailbox handle
  mailbox gen2drv;
  
  //constructor
  function new(virtual inf vinf, mailbox gen2drv);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from env 
    this.gen2drv = gen2drv;
  endfunction
        
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
    wait(vinf.rst);
    $display("[ --DRIVER-- ] ----- Reset Started -----");
    vinf.enable <= 0;
    vinf.rd_wr <= 0;
	vinf.addr <= 0;
	vinf.wr_data <= 0;
	
    wait(!vinf.rst);
    $display("[ --DRIVER-- ] ----- Reset Ended   -----");
  endtask
  
  //drives the transaction items into interface signals
  task main;
    forever begin
      transaction trans;
      gen2drv.get(trans);
      @(posedge vinf.clk)begin
      vinf.enable <= 1;
	  vinf.rd_wr      <= trans.rd_wr;
      vinf.addr      <= trans.addr;
	  vinf.wr_data      <= trans.wr_data;
	  end
      @(posedge vinf.clk) begin
      vinf.enable <= 0;
      trans.rd_data <= vinf.rd_data ;
	  trans.res_out <= vinf.res_out ;
        @(posedge vinf.clk);  
      trans.display("[ --Driver-- ]");
      num_transactions++;
	  end
    end
  endtask
  
endclass
