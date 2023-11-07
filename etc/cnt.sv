task cnt_test(input bit i);
   logic [63:0] tb.DOL_AWUSER;
   logic [63:0] tb.NOC_AWUSER;

   force tb.DOL_AWUSER = tb.NOC_AWUSER;

   //input 1 test
   tb.NOC_AWUSER[i] = 1;

   if(tb.DOL_AWUSER == 1) begin
      $display("pass");
   end else begin
      $display("fail");
   end
   
   //input 0 test
   tb.NOC_AWUSER[i] = 0;

   if(tb.DOL_AWUSER == 0) begin
      $display("pass");
   end else begin
      $display("fail");
   end

endtask

module tb;
initial begin
   cnt_test(0);
   cnt_test(1);
   cnt_test(2);
   cnt_test(3);
   cnt_test(4);
   cnt_test(5);
   cnt_test(6);
   cnt_test(7);
   cnt_test(8);
   cnt_test(9);
   cnt_test(10);
   cnt_test(11);
   cnt_test(12);
   cnt_test(13);
   cnt_test(14);
   cnt_test(15);
   cnt_test(16);
   cnt_test(17);
   cnt_test(18);
   cnt_test(19);
   cnt_test(20);
   cnt_test(21);
   cnt_test(22);
   cnt_test(23);
   cnt_test(24);
   cnt_test(25);
   cnt_test(26);
   cnt_test(27);
   cnt_test(28);
   cnt_test(29);
   cnt_test(30);
   cnt_test(31);
   cnt_test(32);
   cnt_test(33);
   cnt_test(34);
   cnt_test(35);
   cnt_test(36);
   cnt_test(37);
   cnt_test(38);
   cnt_test(39);
   cnt_test(40);
   cnt_test(41);
   cnt_test(42);
   cnt_test(43);
   cnt_test(44);
   cnt_test(45);
   cnt_test(46);
   cnt_test(47);
   cnt_test(48);
   cnt_test(49);
   cnt_test(50);
   cnt_test(51);
   cnt_test(52);
   cnt_test(53);
   cnt_test(54);
   cnt_test(55);
   cnt_test(56);
   cnt_test(57);
   cnt_test(58);
   cnt_test(59);
   cnt_test(60);
   cnt_test(61);
   cnt_test(62);
   cnt_test(63);
endmodule
