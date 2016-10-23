module addsub(
   input [7:0] x,
   input [7:0] y,
   input sub,
   input cin,
   input carry,

   output [7:0] sum,
   output cout
);

   wire [7:0] real_y = sub ? ~y : y;
   reg real_cin;

   always @* begin
      if (sub)
         real_cin = 1'b1;
      else if (carry)
         real_cin = cin;
      else
         real_cin = 1'b0;
   end

   wire [8:0] big_sum = x + real_y + real_cin;

   assign cout = big_sum[8];
   assign sum = big_sum[7:0];
endmodule
