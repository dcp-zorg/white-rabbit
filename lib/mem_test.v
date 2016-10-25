`timescale 1 s / 10 ns

module mem_test();
   reg mode, clk, reset;
   reg [63:0] data_in;
   reg [6:0] addr;

   wire [63:0] data_out;

   `include "lib/params.vh"

   parameter DATA_OFFSET = 32;

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
      addr <= DATA_OFFSET;
      mode <= 0;
      forever #5 clk = ~clk;
   end

   // God hail functions
   always @(posedge clk) begin
      if (tries < 10) begin
         // Read please
         if (!mode) begin
            $display("%d> %h <- (%b)", tries, data_out, addr);
            mode = ~mode;
            tries <= tries + 1;
            addr <= DATA_OFFSET + tries;
         end
         // Write please
         else begin
            data_in <= $random(seed) & 'hffffff;
            $display("%d> %h -> (%b)", tries, data_in, addr);
            #1 mode = ~mode;
         end // else: !if(mode)
      end
      else begin
         // Read instrucions
         if (!mode) begin
            if (addr > DATA_OFFSET/4) begin
               $display("good bye");
               $finish;
            end
            else begin
               $display("%h <- (%b)", data_out, addr);
               #1 addr <= addr + 1;
            end
         end
         else begin
            mode <= 0;
            addr <= 0;
         end // else: !if(!mode)
      end
   end // always @ (posedge clk)
endmodule
