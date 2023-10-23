//Generator
class generator;
   mailbox drv_mbx;

   task run();
      for (int i = 0; i < 10; i++) begin
         Packet pc = new;
         pc.randomize();
         drv_mbx.put(pc);
         $display("[%0t] [Generator] [%0d/10] Randomizing..", $time, i);
      end
   endtask
endclass
