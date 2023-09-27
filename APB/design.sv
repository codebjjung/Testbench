module APB_SLAVE
(
	input clk,
	input n_rst,
	input [ADDR_WIDTH-1:0] paddr,
	input [2:0] prot,
	input pwrite,
	input psel,
	input penable,
	input [DATA_WIDTH-1:0] pwdata,
	input [DATA_STRB-1:0] pstrb,
	output pready,
	output reg slverr,
	output reg [DATA_WIDTH-1:0] prdata	
);

reg [1:0] IDLE = 2'b00;
reg [1:0] SETUP = 2'b01;
reg [1:0] ACCESS = 2'b10;
