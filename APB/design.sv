`timescale 1ns/1ps

`define BASE_ADDR 32'hA200_0000
`define MEM_SIZE 16
`define AXI4_MO 16

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

int mem[`MEM_SIZE];

wire pready;
reg [1:0] st,n_rst;
wire trans;
wire [DATA_WIDTH-1:0] s_pwdata;

assign pready = psel;
assign trans = psel;
assign s_pwdata = prot[1] ? 32'h0 : pwdata & {{8{pstrb[3]}}, {8{pstrb[2]}}, {8{pstrb[1]}}, {8{pstrb[0]}}};

always @(posedge clk or negedge n_rst) begin
	if(!n_rst) begin
		prdata <= 0;
		st <= 0;
		nst <= 0;
	end else begin
		st <= n_rst;
	end

	if(st == ACCESS) begin
		if(psel & penable & pready) begin
			if(pwrite) begin
				mem[paddr - `BASE_ADDR] <= s_pwdata;
			end else begin
				prdata <= mem[paddr - `BASE_ADDR];
			end
		end
	end
end

always @(posedge clk or negedge n_rst) begin
	case(st)
		IDLE : begin
			if(psel)
				n_rst <= SETUP;
			else
				n_rst <= IDLE;
		end
		SETUP : begin
				nst <= ACCESS;
		end
		ACCESS : begin
			if(psel & penable) begin
				if(pready)
					if(trans)
						nst <= SETUP;
					else
						nst <= IDLE;
				else
					nst <= ACCESS;
			end
		end
	endcase
end
endmodule
