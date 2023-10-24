`timescale 1ns/1ps

module tb;
reg clk;
reg nrst;
reg [31:0] paddr;
reg [2:0] prot;
reg [31:0] pwdata;
reg pwrite;
reg psel;
reg penable;
reg [3:0] pstrb;
reg pready;
wire slverr;
wire [31:0] prdata;

assign clk = clk_if.clk;
assign nrst = apb_if.nrst;
assign prot = apb_if.prot;
assign paddr = apb_if.paddr;
assign pwdata = apb_if.pwdata;
assign pwrite = apb_if.pwrite;
assign psel = apb_if.psel;
assign penable = apb_if.penable;
assign pstrb = apb_if.pstrb;
assign apb_if.prdata = prdata;
apb_slave dut (.clk(clk), .nrst(nrst), .paddr(paddr), .prot(prot), .pwrite(write), .psel(psel), .penable(penable), .pwdata(pwdata), .pstrb(pstrb), .pready(pready), .slverr(slverr), .prdata(prdata));
my_apb_if apb_if();
my_clk_if clk_if();

initial begin
   test t0;
   t0 = new();
   t0.e0.apb_vif = apb_if;
   t0.e0.clk_vif = clk_if;
   t0.run();
   #10000;
   $finish;
end
endmodule
