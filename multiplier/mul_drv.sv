class driver;
	virtual mul_if d_vif;
	virtual clk_if d_clk_vif;
	mailbox drv_mbx;

	task run();
		forever begin
			Packet pkt;
			drv_mbx.get(pkt);
			@ (posedge d_clk_vif.tb_clk);
			pkt.print("Driver");
			d_vif.a <= pkt.a;
			d_vif.b <= pkt.b;
			d_vif.y <= pkt.y;
		end
	endtask
endclass
