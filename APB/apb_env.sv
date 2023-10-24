class env;
   generator g0;
   driver d0;
   monitor m0;
   scoreboard s0;
   mailbox drv_mbx;
   mailbox scb_mbx;
   virtual my_apb_if apb_vif;
   virtual my_clk_if clk_vif;

   function new();
      g0 = new;
      d0 = new;
      m0 = new;
      s0 = new;
      drv_mbx = new;
      scb_mbx = new();
   endfunction

   virtual task run();
      d0.d_vif = apb_vif;
      m0.m_vif = apb_vif;

      d0.clk_vif = clk_vif;
      m0.clk_vif = clk_vif;

      g0.drv_mbx = drv_mbx;
      d0.drv_mbx = drv_mbx;

      m0.scb_mbx = scb_mbx;
      s0.scb_mbx = scb_mbx;

      fork
         g0.run();
         d0.run();
         m0.run();
         s0.run();
      join_any
   endtask
endclass
