module addsub_test();
   reg [7:0] x;
   reg [7:0] y;
   reg sub;
   reg cin;
   reg carry;
   wire [7:0]res;
   wire cout;
   
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

      #10
      x = 8'd42;
      y = 8'd69;
      sub = 0;
      cin = 0;
      carry = 0;

      #10

      x = 8'd52;
      y = 8'd10;
      sub = 1;

      #10 $finish;
   end

   initial begin
      $monitor($time, "%d (%b) %d = %d", x, sub, y, res);
   end
endmodule

