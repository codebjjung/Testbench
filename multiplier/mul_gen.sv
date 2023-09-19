class generator;
	event drv_done;
	mailbox drv_mbx;

	task run();
		for (i=1; i < 10; i++) begin
			Packet pkt = new;
			pkt.randomize();
			$display("[%0t] [Generator] %0d/10 create item", $time, i);
			drv_mbx.get(pkt);
			$display("[%0t] [Generator] Generate complete", $time);
			@(drv_done)
		end
	endtask
endclass
		
		
