`timescale 1ns/1ps

`include "design.sv"
//tb
module tb
  #(ADDR_WIDTH = 32,
    DATA_WIDTH = 32,
    DATA_STRB = DATA_WIDTH/8);
  reg                     clk;
  reg                   prstn;
  reg [ADDR_WIDTH-1:0]  paddr;
  reg [2           :0]   prot;
  reg                  pwrite;
  reg                    psel;
  reg                 penable;
  reg [DATA+WIDTH-1:0] pwdata;
  reg [DATA_STRB-1:0]   pstrb;
  wire                 pready;
  wire                 slverr;
  wire [DATA_WIDTH-1:0] prdata;

  int i = 0;
  int mem[`MEM_SIZE]; //array MEM 16

  apb_slave DUT0 (.clk (clk),
                  .prstn (prstn),
                  .paddr (paddr),
                  .prot (prot),
                  .pwrite (pwrite),
                  .psel (psel),
                  .penable (penable),
                  .pwdata (pwdata),
                  .pstrb (pstrb),
                  .pready (pready),
                  .slverr (slverr),
                  .prdata (prdata));

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    prstn = 0;
    paddr = 0;
    prot = 0;
    pwrite = 0;
    psel = 0;
    penable = 0;
    pwdata = 0;
    pstrb = 0;

    //rst off
    #20;
    prstn = 1;
    @(posedge clk)
    #20;

    //make random data
    for (int j=0; j<16; j++) begin
      mem[j] = $urandom();
      $display("Addr : %x / Data : %x", `BASE_ADDR+4j, mem[j]);
    end

    //data write
    $display("APB data write");
    repeat (16) begin
      @(posedge clk) begin
        paddr = #1 (`BASE_ADDR + 4i);
        pwdata = #1 mem[i];
        pstrb = #1 4'b1111;
        pwrite = #1 1;
        psel = #1 1;
      end
      $display("Addr : %x / Data : %x / Pstrb : %x / Pwrite : %x / Psel : %x", `BASE_ADDR+4i, pwdata, pstrb, pwrite, psel);
      @(posedge clk);
      penable = #1 1;
      repeat(3)
        @posedge clk);
      #20;
      i = i+1;
      pwrite = 0;
      psel = 0;
      penable = 0;
    end

    //data read
    $display("APB data read");
    i = 0;

    repeat (16) begin
      @(posedge clk) begin
        paddr = #1 (`BASE_ADDR + 4i);
        pstrb = #1 4'b1111;
        pwrite = #1 0;
        psel = #1 1;
      end
      @(posedge clk);
      penable = #1 1;
      repeat(3)
        @(posedge clk);
      if(mem[i] != prdata)
        $error("ERROR");
      else
        $display("PASS");
      #20;
      i=i+1;
      pwrite = 0;
      psel = 0;
      penable = 0;
    end

    $display("FINISH WRITE, READ TEST");
    $finish;
  end

endmodule
