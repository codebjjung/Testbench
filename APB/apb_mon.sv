class monitor;
   virtual my_apb_if m_vif;
   virtual my_clk_if clk_vif;
   mailbox scb_mbx;

   task run();
      $display("[%0t] [Monitor] Monitor starting..", $time);

      for (int i=0; i<20; i++) begin
         Packet pc = new();
         if (i == 0) begin
            #40;
         end else begin
            #30;
         end
         pc.paddr = m_vif.paddr;
         pc.pwdata = m_vif.pwdata;
         pc.prdata = m_vif.prdata;
         scb_mbx.put(pc);
         if (pc.prdata)
            $display("[%0t] [Monitor] paddr : %0h prdata : %0h", $time, pc.paddr, pc.prdata);
         else
            $display("[%0t] [Monitor] paddr : %0h pwdata : %0h", $time, pc.paddr, pc.pwdata);
      end
   endtask
endclass
