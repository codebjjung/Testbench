module my_noc(output araddr);
endmodule

module my_dol(input awaddr);
endmodule

module tb;
   logic addr;
   my_noc noc(.araddr(addr));
   my_dol dol(.awaddr(addr));
   
   initial begin
      addr = 1;
   $display("%0d = %0d",noc.araddr, dol.awaddr));
   end
endmodule


