// Slow
// But
// Easy
module float_addsub(
                    input [63:0]  a,
                    input [63:0]  b,
                    input         sop,
                    output [63:0] sum
                    );

   assign seff = a[63] ^ b[63] ^ sop;

   always @* begin
      $display("(s e f) a - (%b %b %b)", a[63], a[62:52], a[51:0]);
      $display("(s e f) b - (%b %b %b)", b[63], b[62:52], b[51:0]);
      $display("add? - %b", sop);
      $display("bseff: %b", seff);
   end

   assign sum = a;

endmodule
