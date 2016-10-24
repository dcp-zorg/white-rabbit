module mem(
           input                  clk, reset, mode, // '1' - read, '0' - write
	         input [ADDR_SIZE-1:0]  addr,
	         input [WORD_SIZE-1:0]  data_in,
	         output [WORD_SIZE-1:0] data_out
           );

   `include "lib/params.vh"

   // mem size (as in depth )
   parameter MEM_SIZE = 32;
   // cause log2(MEM_SIZE)
   parameter ADDR_SIZE = 5;

	 reg [WORD_SIZE-1:0] bank[MEM_SIZE-1:0];

   reg [WORD_SIZE-1:0] data_out;

   integer i;

   always @(posedge reset) begin
      if (reset) begin
         for (i=0;i<MEM_SIZE;i=i+1) bank[i] <= 0;
      end
   end

   always @(clk) begin
      if (mode)
         data_out <= bank[addr];
      else
         bank[addr] <= data_in;
   end
endmodule
