class Packet;
	rand bit [3:0] a;
	rand bit [3:0] b;
	bit [7:0] y;

	function new(string tag="");
		$display ("[%0t] [%s] a=%0d b=%0d y=%0d", $time, tag, a, b, y);
	endfunction

	function void copy(Packet tmp);
		this.a = tmp.a;
		this.b = tmp.b;
		this.y = tmp.y;
	endfunction
endclass
