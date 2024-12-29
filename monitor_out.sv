//Samples the interface output signals, captures the transaction packet
//and sends the packet to scoreboard.

class monitor_out;

  //create virtual interface handle
  virtual inf vinf;

  //create mailbox handle
  mailbox mon2scbout;

  //constructor
  function new(virtual inf vinf,mailbox mon2scbout);
    //get the interface
    this.vinf = vinf;
    //get the mailbox handle from environment
    this.mon2scbout = mon2scbout;
  endfunction

  //Samples the interface signal and sends the sampled packet to scoreboard
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vinf.clk) begin
        if(vinf.enable)begin
      trans.rd_data = vinf.rd_data;
	  trans.res_out = vinf.res_out ;
      trans.display("[ --Monitor_out-- ]");
       @(posedge vinf.clk)
      mon2scbout.put(trans);
	  end
    end
    end
  endtask

endclass