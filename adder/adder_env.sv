class env;
	generator	g0;
	driver		d0;
	monitor		m0;
	scoreboard	s0;
	mailbox		scb_mbx;
	virtual adder_if	m_adder_vif;
	virtual clk_if		m_clk_vif;

	event drv_done;
	mailbox drv_mbx;

	function new();
		d0 = new;
		m0 = new;
		s0 = new;
		scb_mbx = new();
		g0 = new;
		drv_mbx = new;
	endfunction

	virtual task run();

		d0.m_adder_vif = m_adder_vif;
		m0.m_adder_vif = m_adder_vif;
		d0.m_clk_vif = m_clk_vif;
		m0.m_clk_vif = m_clk_vif;

		d0.drv_mbx = drv_mbx;
		g0.drv_mbx = drv_mbx;

		m0.scb_mbx = scb_mbx;
		s0.scb_mbx = scb_mbx;

		d0.drv_done = drv_done;
		g0.drv_done = drv_done;

		fork
			s0.run();
			d0.run();
			m0.run();
			g0.run();
		join_any
	endtask
endclass
