class monitor;
	virtual mul_if m_vif;
	virtual clk_if m_clk_vif;
	mailbox scb_mbx;

	task run();
		forever begin
			Packet m_pkt = new();
			@ (posedge m_clk_vif.tb_clk);
			#1;
			m_pkt.a = m_vif.a;
			m_pkt.b = m_vif.b;
			m_pkt.y = m_vif.y;
			m_pkt.print("Monitor");
			scb_mbx.put(m_pkt);
		end
	endtask
endclass
