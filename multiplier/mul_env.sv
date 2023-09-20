class env;
	generator g0;
	driver d0;
	monitor m0;
	scoreboard s0;
	mailbox scb_mbx;
	virtual mul_if e_vif;
	virtual clk_if e_clk_vif;

	mailbox drv_mbx;

	function new();
		g0 = new;
		d0 = new;
		m0 = new;
		s0 = new;
		drv_mbx = new();
		scb_mbx = new();
	endfunction

	virtual task run();
		d0.d_vif = e_vif;
		m0.m_vif = m_vif;

		g0.g_clk_vif = e_clk_vif;
		d0.d_clk_vif = e_clk_vif;
		m0.m_clk_vif = e_clk_vif;

		d0.drv_mbx = drv_mbx;
		g0.drv_mbx = drv_mbx;

		m0.scb_mbx = scb_mbx;
		s0.scb_mbx = scb_mbx;

		fork
			g0.run();
			d0.run();
			m0.run();
			s0.run();
		join_any
	endtask
endclass
