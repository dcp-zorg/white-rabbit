module mem(
           input                  clk, reset, mode, // 0 read, 1 write
	         input [ADDR_WIDTH-1:0] addr,
	         input [WIDTH-1:0]      data_in,
	         output [WIDTH-1:0]     data_out
           );

   `include "lib/config.vh"

   reg [WIDTH-1:0] bank[MEMORY_DEPTH-1:0];
   reg [WIDTH-1:0] data_out;

   initial begin
      $readmemh(PROGRAM_DATA, bank, 0, (DATA_OFFSET/4)-1);
   end

   integer i;
   always @(posedge reset) begin
      for (i = 0; i < MEMORY_DEPTH; i = i + 1) bank[i] <= 0;
   end

   always @(clk) begin
      if (mode)
        bank[addr] <= data_in;
      else
        data_out <= bank[addr];
   end
endmodule
