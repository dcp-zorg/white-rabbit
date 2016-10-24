module addsub(
   input                      sub,
   input                      cin,
   input wire [WORD_SIZE-1:0] y,
   input wire [WORD_SIZE-1:0] x,
   input                      carry,
   output [WORD_SIZE-1:0]     sum,
   output                     cout
);

   `include "lib/params.vh"

   wire [WORD_SIZE-1:0] real_y = sub ? ~y : y;

   reg real_cin;

   always @* begin
      if (sub)
         real_cin = 1'b1;
      else if (carry)
         real_cin = cin;
      else
         real_cin = 1'b0;
   end

   wire [WORD_SIZE:0] big_sum = x + real_y + real_cin;

   assign cout = big_sum[WORD_SIZE];
   assign sum  = big_sum[WORD_SIZE-1:0];
endmodule
