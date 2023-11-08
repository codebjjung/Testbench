module calculator (
   input clk,
   input rst,
   input st,
   input [1:0] op,
   input [3:0] a,
   input [3:0] b,
   output reg [3:0] result,
   output reg carry
);

reg [3:0] result_tmp;
reg carry_tmp;

always @(posedge clk or negedge rst) begin
   if(!rst) begin
      result <= 4'b0;
      carry <= 1'b0;
   end else begin
      if (st) begin
         result <= result_tmp;
         carry <= carry_tmp;
      end
   end
end

always @(*) begin
   case(op)
      2'b00:
      {carry_tmp, result_tmp} = a + b;
      2'b01:
      {carry_tmp, result_tmp} = a - b;
      2'b10:
      {carry_tmp, result_tmp} = a * b;
      2'b11:
      {carry_tmp, result_tmp} = a / b;
      default:
      {carry_tmp, result_tmp} = a + b;
   endcase
end
endmodule

property add;
   @(posedge clk) (st==1 && op == 00) |=> {carry,result} = a + b;
endproperty

assert property add;
$display("pass");
