module mem_test();
   reg mode;
   reg [63:0] data_in;
   reg [63:0] data_out;
   reg [63:0] addr;

   mem m0 (
           .mode (mode),
           .address (addr),
           .dataIn (data_in),
           .dataOut (data_out)
           );

   initial begin
      $display("-- to the sun --");

      mode = 0;
      addr = 64'b0;
      data_in = 64'd2017;
      #10;

      mode = 1;
      addr = 64'b0;
      #10 $finish;
   end

   initial begin
      $monitor($time, "STAMP: <%b> %d -> %h, [%d]", mode, data_in, add, data_out);
   end
endmodule
