module float_addsub_test();
   reg [63:0] a;
   reg [63:0] b;
   reg        sop;
   wire [63:0]  sum;

   float_addsub x0 (
                    .a (a),
                    .b (b),
                    .sop (sop),
                    .sum (sum)
                    );

   initial begin
      b = 64'd10;
      a = 64'd10;
      a[63] = 1;
      sop = 1;

      #10;
      b[63] = 1;
   end

   initial begin
      //$monitor($time, "(%b %b %b)", sum[63], sum[62:52], sum[51:0]);
   end
endmodule
