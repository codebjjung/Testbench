//Interface
interface my_apb_if;
   logic nrst;
   logic [31:0] paddr;
   logic [31:0] pwdata;
   logic pwrite;
   logic psel;
   logic penable;
   logic [3:0] pstrb;
   logic [31:0] prdata;
endinterface

interface my_clk_if;
   logic clk;

   initial clk <= 0;

   always #5 clk = ~clk;
endinterface
