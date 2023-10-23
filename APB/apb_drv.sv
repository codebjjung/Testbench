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
      d_vif.nrst = 0;
      d_vif.paddr = 0;
      d_vif.pstrb = 4'b1111;
      d_vif.pwrite = 0;
      d_vif.psel = 0;
      d_vif.penable = 0;
      @ (posedge clk_vif.clk);
      d_vif.nrst = 1;
   endtask
