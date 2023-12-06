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
