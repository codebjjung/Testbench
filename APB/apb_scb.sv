class scoreboard;
   mailbox scb_mbx;

   task run();
      $display("[%0t] [Scoreboard] Scoreboard starting..", $time);

      forever begin
         Packet pc;
         scb_mbx.get(pc);

         $display("[%0t] [Scoreboard] addr : %0h pwdata : %0h prdata : %0h", pc.paddr, pc.pwdata, pc.prdata);
         if (pc.pwdata) begin
            $display("Write PASS");
            end

         if (pc.prdata) begin
            $display("Read PASS");
         end
      end
   endtask
endclass
