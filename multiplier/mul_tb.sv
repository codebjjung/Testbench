`timescale 1ns/1ps
`include "design.sv"
`include "mul_if.sv"
`include "mul_tr.sv"
`include "mul_gen.sv"
`include "mul_drv.sv"
`include "mul_mon.sv"
`include "mul_scb.sv"
`include "mul_env.sv"
`include "mul_test.sv"

module tb;
	bit tb_clk;

	clk_if my_clk_if();
	mul_if my_if;
	mul dut(my_if);

	initial begin
		teset t0;

		t0 = new;
		t0.e0.e_vif = my_if;
		t0.e0.e_clk_vif = my_clk_if;
		t0.run();

		#50 $finish;
	end

	initial begin
		$fsdbDumpfile("dump.fsdb");
		$fsdbDumpvars;
	end
endmodule
