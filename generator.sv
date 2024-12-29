class generator;
  
  //declare transaction class 
  rand transaction trans;
  
  //repeat count, to indicate number of items to generate
  int  repeat_count;
  
  //declare mailbox, to send the packet to the driver
  mailbox gen2drv;
  
  //declare event, to indicate the end of transaction generation
  event ended;
  
  //constructor
  function new(mailbox gen2drv);
    //get the mailbox handle from env, in order to share the transaction packet 
    //between the generator and the driver the same mailbox is shared between both.
    this.gen2drv = gen2drv;
  endfunction
  
  //main task, generates (create and randomizes) the repeat_count 
  //number of transaction packets and puts them into the mailbox
  task main();
    
    repeat(repeat_count) begin
      trans = new();
      if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      trans.display("[ --Generator-- ]");
      gen2drv.put(trans);
    end
    -> ended; //trigger end of generation

  endtask
  
endclass
