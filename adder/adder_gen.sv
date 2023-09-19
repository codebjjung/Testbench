class generator;
	event drv_done;
	mailbox drv_mbx;

	task run();
		for (int i = 0; i < 10; i++) begin
			Packet pkt = new;
			pkt.randomize();
			$display ("T=%0t [Generator] Loop:%0d/10 create next item", $time, i+1);
			drv_mbx.put(item);
			$display ("T=%0t [Generator] Wait driver", $time);
			@(drv_done);
		end
	endtask
endclass
