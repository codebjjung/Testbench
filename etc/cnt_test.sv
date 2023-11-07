module my_noc(
   input [63:0] awdata,
   output [63:0] to_dol_awdata
);

assign to_dol_awdata = awdata;
endmodule

module my_dol(
   input [63:0] to_dol_awdata,
   output [63:0] data
);

assign awdata = to_dol_awdata;
endmodule

module tb;
logic to_dol_awdata;
logic awdata;
logic data;
my_noc noc(awdata(.awdata), to_dol_awdata(.to_dol_awdata));
my_dol dol(awdata(.awdata), data(.data));
