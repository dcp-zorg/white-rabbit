module addsub_test();
   `include "lib/config.vh"

   reg [7:0] x;
   reg [7:0] y;
   reg sub;
   reg cin;
   reg carry;
   wire [7:0] res;
   wire cout;

   defparam addsub0.WORD_SIZE = 8;

   addsub addsub0 (
      .x (x),
      .y (y),
      .sub (sub),
      .cin (cin),
      .carry (carry),
      .sum (res),
      .cout (cout)
   );

   initial begin
      $display("~~ to the sun ~~");

      x = 8'd42;
      y = 8'd69;
      sub = 0;
      cin = 0;
      carry = 0;

      #1
      x = 8'd52;
      y = 8'd10;
      sub = 1;

      #1;
      x = 8'b11111111;
      y = 8'b00000001;
      sub = 1;

      #1;
      sub = 0;
      #1 $finish;
   end

   initial begin
      $monitor($time, " -- %d (%b) %d = %d", x, sub, y, res);
   end
endmodule
