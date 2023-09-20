class scoreboard;
	mailbox scb_mbx;

	task run();
		forever begin
			Packet pkt, s_pkt;
			scb_mbx.get(pkt);
			pkt.print("Scoreboard");

			s_pkt = new();
			s_pkt.copy(pkt);

			if (s_pkt.y == pkt.y) begin
				$display("[%0t] IN : %0d / OUT : %0d Scoreboard PASS", $time, s_pkt.y, pkt.y);

			end else begin
				$display("[%0t] IN : %0d / OUT : %0d Scoreboard FAIL", $time, s_pkt.y, pkt.y);
			end
		end
	endtask
endclass
