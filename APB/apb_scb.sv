class scoreboard;
   mailbox scb_mbx;

   task run();
      $display("[%0t] [Scoreboard] Scoreboard starting..", $time);

      forever begin
         Packet pc;
         #30
         scb_mbx.get(pc);

         $display("[%0t] [Scoreboard] addr : %0h pwdata : %0h prdata : %0h", pc.paddr, pc.pwdata, pc.prdata);
         if (pc.pwdata == mem[pc.paddr]) begin
            $display("Write PASS");
            end

         if (pc.prdata == mem[pc.paddr]) begin
            $display("Read PASS");
         end
      end
   endtask
endclass
