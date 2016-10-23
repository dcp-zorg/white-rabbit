module mem(
	input mode, // '1' - read, '0' - write
	input [63:0] address,
	input [63:0] dataIn,

	output [63:0] dataOut
);

	reg [63:0] bank[1023:0];

	always @* begin
		$display("address - (%b)", address);

		if (mode == 1)
			begin
				// read from address
				dataOut = bank[address];	
			end
		else
			begin
				// wtrite to mem by address
				bank[address] = dataIn;
			end
	end
endmodule