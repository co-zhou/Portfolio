module inst_memory_tb;
  reg [31:0] address;
  wire [31:0] read_data;
	integer i;

  inst_memory dut(
		.address(address),
		.read_data(read_data)
  );

  initial begin
		$stop;
  end
endmodule