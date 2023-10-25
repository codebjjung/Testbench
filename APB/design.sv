`timescale 1ns/1ps

`define BASE_ADDR 32'hA200_0000
`define MEM_SIZE 16
`define AXI4_MO 16

module APB_SLAVE
	#(ADDR_WIDTH = 32,
	DATA_WIDTH = 32,
	DATA_STRB = (DATA_WIDTH/8))
(
	input clk,
	input nrst,
	input [ADDR_WIDTH-1:0] paddr,
	input [2:0] prot,
	input pwrite,
	input psel,
	input penable,
	input [DATA_WIDTH-1:0] pwdata,
	input [DATA_STRB-1:0] pstrb,
	output pready,
	output reg slverr=0, //temp
	output reg [DATA_WIDTH-1:0] prdata	
);

parameter IDLE = 2'b00;
parameter SETUP = 2'b01;
parameter ACCESS = 2'b10;

//MEM SAVE
int mem[`MEM_SIZE];

wire pready;
reg [1:0] st;
wire [DATA_WIDTH-1:0] s_pwdata;

assign pready = psel;
assign s_pwdata = prot[1] ? 32'h0 : pwdata & {{8{pstrb[3]}}, {8{pstrb[2]}}, {8{pstrb[1]}}, {8{pstrb[0]}}};

always @(posedge clk or negedge nrst) begin
	if(!nrst) begin
		prdata <= 0;
		st <= 0;
	end

   if(psel & penable & pready) begin
      if(pwrite) begin
         mem[paddr] <= s_pwdata;
      end else begin
         prdata <= mem[paddr];
      end
   end
end

//APB FSM
always @(posedge clk or negedge nrst) begin
	case(st)
		IDLE : begin
			if(psel & !penable)
				st <= SETUP;
			else
				st <= IDLE;
		end
		SETUP : begin
         if(psel & penable)
				st <= ACCESS;
		end
      ACCESS : begin
         if(pready)
            st <= IDLE;
         else
            st <= ACCESS;
      end
	endcase
end
endmodule
