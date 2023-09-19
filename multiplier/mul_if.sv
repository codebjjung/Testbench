interface mul_if;
	logic [3:0] a;
	logic [3:0] b;
	logic [7:0] y;
endinterface

interface clk_if;
	logic tb_clk;

	initial tb_clk <= 0;

	always #10 tb_clk = ~tb_clk;
endinterface
