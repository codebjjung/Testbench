class monitor;
   virtual my_apb_if m_vif;
   virtual my_clk_if clk_vif;
   mailbox scb_mbx;

   task run();
      $display("[%0t] [Monitor] Monitor starting..", $time);

      for (int i=0; i<10; i++) begin
         Packet pc = new();
         pc.paddr = m_vif.paddr;
         pc.pwdata = m_vif.pwdata;
         pc.prdata = m_vif.prdata;
         scb_mbx.put(pc);
      end
   endtask
endclass
