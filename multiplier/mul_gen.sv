class generator;
	mailbox drv_mbx;
	virtual clk_if g_clk_if;

	task run();
		for (int i=1; i<=10; i++) begin
			Packet pkt = new();
			@ (negedge g_clk_if.tb_clk);
			pkt.randomize();
			$display("[%0t] [Generator] Creating pkt %0d/10", $time, i);
			drv_mbx.get(pkt);
			$display("[%0t] [Generator] Finish generating", $time);
		end
	endtask
endclass


