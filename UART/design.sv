`timescale 1ns/1ps

//clk_generator
module clk_gen(
   input clk, rst,
   input [16:0] baud,
   output reg tx_clk, rx_clk
);

int rx_max = 0, tx_max = 0;
int rx_count = 0, tx_count = 0;

always@(posedge clk) begin
   if(rst) begin
      rx_max <= 0;
      tx_max <= 0;
   end
   else begin
      case(baud)
         4800 : begin
            rx_max <= 11'd651;
            tx_max <= 14'd10416;
         end

         9600 : begin
            rx_max <= 11'd325;
            tx_max <= 14'd5208;
         end

         14400 : begin
            rx_max <= 11'd217;
            tx_max <= 14'd3472;
         end

         19200 : begin
            rx_max <= 11'd163;
            tx_max <= 14'd2604;
         end

         38400 : begin
            rx_max <= 11'd81;
            tx_max <= 14'd1302;
         end

         57600 : begin
            rx_max <= 11'd54;
            tx_max <= 14'd868;
         end

         115200 : begin
            rx_max <= 11'd27;
            tx_max <= 14'd434;
         end

         128000 : begin
            rx_max <= 11'd24;
            tx_max <= 14'd392;
         end

         default : begin
            rx_max <= 11'd325;
            tx_max <= 14'd5208;
         end
      endcase
   end
end

always @(posedge clk)
begin
   if(rst) begin
      rx_max <= 0;
      rx_count <= 0;
      rx_clk <= 0;
   end else begin
      if(rx_count <= rx_max/2) begin
         rx_cound <= rx_cound + 1;
      end
      else begin
         rx_clk <= ~rx_clk;
         rx_cound <= 0;
      end
   end
end

always @(posedge clk) begin
   if(rst) begin
      tx_max <= 0;
      tx_count <= 0;
      tx_clk <= 0;
   end else begin
      if (tx_count <= tx_max/2) begin
         tx_count <= tx_count + 1;
      end else begin
         tx_clk <= ~tx_clk;
         tx_count <= 0;
      end
   end
end
endmodule

//tx
module uart_tx(
   input tx_clk, tx_start,
   input rst,
   input [7:0] tx_data,
   input [3:0] length,
   input parity_type, parity_en,
   input stop2,
   output reg tx, tx_done, tx_err
);

logic [7:0] tx_reg;

logic start_b = 0;
logic stop_b = 1;
logic parity_bit = 0;
integer count = 0;

typedef enum bit [2:0] {idle = 0, start_bit = 1, send_data = 2, send_parity = 3, send_first_stop = 4, send_sec_stop = 5, done = 6} state_type;
state_type state = idle, next_state = idle;

//parity setting
always@ (posedge tx_clk) begin
   if(parity_type == 1'b1)
   case(length)
      4'd5 : parity_bit = ^(tx_data[4:0]);
      4'd6 : parity_bit = ^(tx_data[5:0]);
      4'd7 : parity_bit = ^(tx_data[6:0]);
      4'd8 : parity_bit = ^(tx_data[7:0]);
      default : parity_bit = 1'b0;
   endcase
   else
   case(length)
      4'd5 : parity_bit = ~^(tx_data[4:0]);
      4'd6 : parity_bit = ~^(tx_data[5:0]);
      4'd7 : parity_bit = ~^(tx_data[6:0]);
      4'd8 : parity_bit = ~^(tx_data[7:0]);
      default : parity_bit = 1'b0;
   endcase
end

//reset setting
always @(posedge tx_clk) begin
   if(rst)
      state <= idle;
   else
      state <= next_state;
end
