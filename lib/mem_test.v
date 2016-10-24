module mem_test();
   reg mode, clk, reset;
   reg [63:0] data_in;
   reg [4:0] addr;

   wire [63:0] data_out;

   mem m0 (
           .clk (clk),
           .reset (reset),
           .mode (mode),
           .addr (addr),
           .data_in (data_in),
           .data_out (data_out)
           );

   integer     tries, seed;

   initial begin
      clk = 0;

      seed <= 1964;
      tries <= 0;
      addr <= 0;
      mode <= 0;
      forever #5 clk = ~clk;
   end

   // THis shoudl wokr ! ;; This doe s work!
   always @(posedge clk) begin
      if (tries < 10) begin
         // Read please
         if (mode) begin
            $display("%d> %h <- (%b)", tries, data_out, addr);
            mode = ~mode;
            tries <= tries + 1;
            addr <= tries;
         end
         // Write please
         else begin
            data_in <= $random(seed) & 'hffffff;
            $display("%d> %h -> (%b)", tries, data_in, addr);
            #1 mode = ~mode;
         end // else: !if(mode)
      end
      else begin
         $display("Feels so damn good");
         $finish;
      end
   end // always @ (posedge clk)

endmodule
