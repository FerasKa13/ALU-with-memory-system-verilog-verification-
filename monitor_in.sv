//Samples the interface signals, captures the transaction packet 
//and sends the packet to scoreboard.

class monitor_in;
  
  //create virtual interface handle
  virtual inf vinf;
  
  //create mailbox handle
  mailbox mon2scbin;
  
  //constructor
  function new(virtual inf vinf,mailbox mon2scbin);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from environment 
    this.mon2scbin = mon2scbin;
  endfunction
  
  //Samples the interface signal and sends the sampled packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vinf.clk)begin
      if(vinf.enable )begin
      trans.rd_wr   = vinf.rd_wr;
      trans.addr   = vinf.addr;
	  trans.wr_data   = vinf.wr_data;
	  trans.enable   = vinf.enable;
    //  trans.count = vinf.count ;
      trans.display("[ --Monitor_in-- ]");
        @(posedge vinf.clk);
      mon2scbin.put(trans);
	  end  
    end
    end
  endtask
  
endclass