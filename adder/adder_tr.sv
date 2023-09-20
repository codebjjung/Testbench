class Packet;
	rand bit rstn;
	rand bit[7:0] a;
	rand bit[7:0] b;
	bit[7:0]		sum;

	function void print(string tag="");
		$display ("T=%0t %s a=0x%0h b=0x%0h sum=0x%0h carry=0x%0h", $time, tag, a, b, sum, carry);
	endfunction

	function void copy(Packet pkt);
		this.a = pkt.a;
		this.b = pkt.b;
`		this.sum = pkt.sum;
		this.carry = pkt.carry;
	endfunction

endclass
