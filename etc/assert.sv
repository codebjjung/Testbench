`timescale 1ns/1ps

module dut(
   input a, b, c,
   output d);

   assign d = a^b;
endmodule

module assertion;
   wire a = tb.a;
   wire b = tb.b;
   wire c = tb.dut.c;
   wire d = tb.dut.d;
   wire clk = tb.clk;

   sequence S1;
      a && b ##[1:3] d;
   endsequence

   sequence S2;
      a ##1 b ##[1:$] c;
   endsequence

   property P1;
      @(posedge clk) S1 |-> S2[*3];
   endproperty

   property P2;
      @(posedge clk) a ##1 b |-> c || d;
   endproperty

A1: assert property (@posedge clk) a && b |-> ##2 c ##1 d)
$display("[%0t], assertion passed", $time);
else
   $warning();

A2: assert property (@(posedge clk) S1 or S2);
A3: assert property (P1 or P2);
endmodule

module tb;
   logic a, b, c, d, clk;

   always #10 clk = ~clk;

   assertion assert_module();

   dut dut_module(a,b,d);

   initial begin
      #0;
      a = 1;
      b = 1;

      #4;
      d = 1;

      #10
      $finish;

   end
endmodule
