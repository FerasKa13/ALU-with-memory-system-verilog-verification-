`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"
class environment;
  
  //generator and driver instance
  generator 	gen;
  driver    	drv;
  monitor_in   	mon_in;
  monitor_out  	mon_out;
  scoreboard	scb;
  
  //mailbox handle's
  mailbox gen2drv;
  mailbox mon2scbin;
  mailbox mon2scbout;
  
  //virtual interface
  virtual inf vinf;
  
  //constructor
  function new(virtual inf vinf);
    //get the interface from test
    this.vinf = vinf;
    
    //creating the mailbox (Same handle will be shared 
    //across generator and driver)
    gen2drv = new();
    mon2scbin = new();
    mon2scbout = new();
    
    //creating generator and driver
    gen = new(gen2drv);
    drv = new(vinf,gen2drv);
    mon_in = new(vinf,mon2scbin);
    mon_out = new(vinf,mon2scbout);
    scb = new(mon2scbin,mon2scbout);
  endfunction
  
  //test activity
  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork 
      gen.main();
      drv.main();
      mon_in.main();
      mon_out.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen.ended.triggered);
    wait(gen.repeat_count == drv.num_transactions); //Optional
    wait(gen.repeat_count == scb.num_transactions);
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass
