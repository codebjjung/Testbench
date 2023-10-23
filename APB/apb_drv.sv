//Driver
class driver;
   virtual my_apb_if d_vif;
   virtual my_clk_if clk_vif;
   mailbox drv_mbx;

   task run();
      $display("[%0t] [Driver] Driver starting..", $time);
      forever begin
         Packet pc;
         $display("[%0t] [Driver] Waiting item", $time);
         drv_mbx.get(pc);
         boot();
         apb_write(pc.paddr, pc.pwdata);
         apb_read(pc.paddr);
      end
   endtask

   task boot;
      clk_vif.clk = 0;

