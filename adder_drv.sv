class driver;
	virtual adder_if d_vif;
	virtual clk_if d_clk_vif;
	event drv_done;
	mailbox drv_mbx;

	task run();
		$display ("T=%0t [Driver] driver start", $time);

		forever begin
			Packet pkt;
			$display ("T=%0t [Driver] getting item ready", $time);
			drv_mbx.get(pkt);
			@ (posedge d_clk_vif.tb_clk);
			pkt.print("Driver");
			d_vif.rstn <= pkt.rstn;
			d_vif.a <= pkt.a;
			d_vif.b <= pkt.b;
			d_vif.sum <= pkt.sum;
			d_vif.carry <= pkt.carry;
			->drv_done;
		end
	endtask
endclass
