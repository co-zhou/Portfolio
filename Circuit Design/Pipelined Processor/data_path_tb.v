module data_path_tb;
	reg clk, reset;

	data_path dut(
		.clk(clk),
		.reset(reset)
	);

	initial begin
		clk = 0;
		reset = 1;
		#200;

		reset = 0;
		#65000;

		$stop;
	end

	always #100 clk = ~clk;
endmodule