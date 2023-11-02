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

always@(*) begin
   case(state)
      idle :
      tx_done = 1'b0;
      tx = 1'b1;
      tx_reg = {(8){1'b0}};
      tx_err = 0;
      if(tx_start)
         next_state = start_bit;
      else
         next_state = idle;

      start_bit :
      tx_reg = tx_data;
      tx = start_b;
      next_state = send_data;

      send_data :
      if(count < (lendth -1)) begin
         next_state = send_data;
         tx = tx_reg[count];
      end
      else if(parety_en) begin
         tx = tx_reg[count];
         next_state = send_parity;
      end
      else begin
         tx = tx_reg[count];
         next_state = send_first_stop;
      end

      send_parity :
      tx = parity_bit;
      next_state = send_first_stop;

      send_first_stop :
      tx = stop_b;
      if(stop2)
         next_state = send_sec_stop;
      else
         next_state = done;
      
      send_sec_stop :
      tx = stop_b;
      next_state = done;

      done :
      tx_done = 1'b1;
      next_state = idle;

      default : next_state = idle;

   endcase
end

always @(posedge tx_clk) begin
   case(state)
      idle :
      count <=0;

      start_bit :
      count <= 0;

      send_data :
      count <= count + 1;

      send_parity :
      count <= 0;

      send_first_stop :
      count <= 0;

      send_sec_stop :
      count <= 0;

      done :
      count <= 0;

      default :
      count <= 0;
   endcase
end
endmodule

module uart_rx(
   input rx_clk, rx_start,
   input rst, rx,
   input [3:0] length,
   input parity_type, parity_en,
   input stop2,
   output reg [7:0] rx_out,
   output logic rx_done, rx_error
);

logic parity = 0;
logic [7:0] datard = 0;
int count = 0;
int bit_count = 0;

typedef enum bit [2:0] { idle = 0, start_bit = 1, recv_data = 2, check_parity = 3, check_first_stop = 4, check_sec_stop = 5, done = 6} state_type;
state_type state = idle, next_state = idle;

always @(posedge rx_clk) begin
   if(rst)
      state <= idle;
   else
      state <= next_state;
end

always @(posedge rx_clk) begin
   case(state)
      idle :
      rx_done = 0;
      rx_error = 0;
      if (rx_start && !rx)
         next_state = start_bit;
      else
         next_state = idle;
      
      start_bit :
      if(count == 7 && rx)
         next_state = idle;
      else if (count == 15)
         next_state = recv_data;
      else
         next_state = start_bit;

      recv_data :
      datard[7:0] = {rx, datard[7:1]};
      else if(count == 15 && bit_count == (length - 1))
      case(length)
         5: rx_out = datard[7:3];
         6: rx_out = datard[7:2];
         7: rx_out = datard[7:1];
         8: rx_out = datard[7:0];
         default : rx_out = 8'h00;
      endcase

      if (parity_type)
         parity = ^datard;
      else
         parity = !^datard;

      if (parity_en)
         next_state = check_parity;
      else
         next_state = check_first_stop;
      else
         next_state = recv_data;

      check_parity :
      if (count < 15)
         count <= count + 1;
      else
         count <= 0;

      check_first_stop :
      if (count < 15)
         count <= count + 1;
      else
         count <= 0;

      check_sec_stop :
      if (count < 15)
         count <= count + 1;
      else
         count <= 0;

      done :
      count <= 0;
      bit_count <= 0;
   endcase
endmodule

module uart_top
(
   input clk, rst,
   input tx_start, rx_start,
   input [7:0] tx_data,
   input [16:0] baud,
   input [3:0] length,
   input parity_type, parity_en,
   input stop2,
   output tx_done, rx_done, tx_err, rx_err,
   output [7:0] rx_out
);

wire tx_clk, rx_clk;
wire tx_rx;

clk_gen clk_dut (clk, rst, baud, tx_clk, rx_clk);
uart_tx tx_dut (tx_clk, tx_start, rst, tx_data, length, parity_type, parity_en, stop2, tx_rx, tx_done, tx_err);
uart_rx rx_dut (rx_clk, rx_start, rst, tx_rx, length, parity_type, parity_en, stop2, rx_out, rx_done, rx_err);


endmodule
