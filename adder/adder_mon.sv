class monitor;
	virtual adder_if m_vif;
	virtual clk_if m_clk_vif;

	mailbox scb_mbx;

	task run();
		$display ("T=%0t [Monitor] Start", $time);

		forever begin
			Packet m_pkt = new();
			@(posedge m_clk_vif.tb_clk);
			#1;
				m_pkt.a = m_vif.a;
				m_pkt.b = m_vif.b;
				m_pkt.rstn = m_vif.rstn;
				m_pkt.sum = m_vif.sum;
				m_pkt.carry = m_vif.carry;
				m_pkt.print("Monitor");
			scb_mbx.put(m_pkt);
		end
	endtask
endclass
	
