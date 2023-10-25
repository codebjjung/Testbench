//Generator
class generator;
   mailbox drv_mbx;

   task run();
      for (int i = 0; i < 20; i++) begin
         Packet pc = new;
         pc.randomize();
         if (i <= 9) begin
            pc.paddr = i;
         end else begin
            pc.paddr = i - 10;
         end
         drv_mbx.put(pc);
         $display("[%0t] [Generator] [%0d/10] Randomizing..", $time, i);
      end
   endtask
endclass
