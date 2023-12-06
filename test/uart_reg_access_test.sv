`include "boot_seq.sv"
   int fp, status;
   bit [31:0] offset;
   bit [31:0] offset_q[$];

   string reg_name;
   string reg_name_q[$];

   string reg_base;
   string reg_base_q[$];

   bit [31:0] reset_value;
   bit [31:0] reset_value_q[$];

   bit [31:0] mask;
   bit [31:0] mask_q[$];

   bit [31:0] wdata, rdata;

   int i, err_count;

   //reset value test
   task rst_test(input int i);
      ca53_read(`UART0_BASE + offset_q[i], rdata);
      if((rdata & mask_q[i]) == (reset_value_q[i] & mask_q[i])) begin
         $display("pass, rdata = %0h reset_value = %0h", rdata, reset_value_q[i]);
      end else begin
         $display("fail, rdata = %0h reset_value = %0h", rdata, reset_value_q[i]);
         err_count++;
      end
   endtask

   //write 0 test
   task write_0_test(input int i);
      ca53_write(`UART0_BASE + offset_q[i], wdata);
      ca53_read(`UART0_BASE + offset_q[i], rdata);
      if((rdata & mask_q[i]) == (wdata & mask_q[i])) begin
         $display("pass");
      end else begin
         if(reg_type[i] == "R") begin
            $display("waive");
         end else begin
            $display("fail");
            err_count++;
         end
      end
   endtask


