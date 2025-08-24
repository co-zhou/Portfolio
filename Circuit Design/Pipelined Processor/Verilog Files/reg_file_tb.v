module reg_file_tb;
	reg clk, write, reset;
	reg [4:0] pr1, pr2, wr;
  reg [31:0] wd;
  wire [31:0] rd1, rd2;

  reg_file dut(
  	.clk(clk),
  	.write(write),
		.reset(reset),
		.pr1(pr1),
		.pr2(pr2),
		.wr(wr),
		.wd(wd),
		.rd1(rd1),
		.rd2(rd2)
  );

  initial begin
    clk = 0;
		write = 0;
		reset = 1;
		pr1 = 5'd0;
		pr2 = 5'd16;
		wr = 5'd16;
		wd = 32'hffffffff;
		#200; // reset to 0
		
		reset = 0;
		#200;

		write = 1; // write 32'hffffffff to $16
		#200;

		reset = 1;
		write = 0; // reset $16 to 0
		#200;

		$stop;
  end

  always #100 clk = ~clk;
endmodule