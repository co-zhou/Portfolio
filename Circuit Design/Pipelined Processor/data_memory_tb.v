module data_memory_tb;
	reg clk, write, MemToRegM;
  reg [31:0] address, write_data;
  wire [31:0] read_data;
	wire memstall;

  data_memory dut(
  	.clk(clk),
  	.write(write),
  	.MemToRegM(MemToRegM),
		.address(address),
		.write_data(write_data),
		.read_data(read_data),
		.memstall(memstall)
  );

  initial begin
    clk = 0;
		write = 0;
		MemToRegM = 0;
		address = 32'h00000000;
		write_data = 32'hffffffff;
		#200; // Try to write without enable

		write = 1; // Write with enable
		#4200;

		address = 32'h00000004;
		write_data = 32'heeeeeeee;
		#1000;

		address = 32'h0000400c;
		write_data = 32'haaaaaaaa;
		#4200;

		address = 32'h0000800c;
		write_data = 32'hbbbbbbbb;
		#4200;

		address = 32'h00000004;
		write = 0;
		MemToRegM = 1;
		#4200;

		$stop;
  end

  always #100 clk = ~clk;
endmodule
