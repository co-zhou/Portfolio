module multiplier_tb;
	reg [31:0] a, b;
	reg clk, start, is_signed, reset;
	wire [63:0] s;
	wire mult_active;

  multiplier dut(
  	.a(a),
		.b(b),
		.clk(clk),
		.start(start),
		.is_signed(is_signed),
		.reset(reset),
		.s(s),
		.mult_active(mult_active)
  );

	initial begin
    clk = 0;
		start = 0;
		#200;

		is_signed = 0;
		start = 1;
		a = 32'h6;
		b = 32'h3;
		#200;

		start = 0;
		#7000;

		start = 1;
		a = 32'h6;
		b = 32'hfffffffd;
		#200;

		start = 0;
		#7000;

		start = 1;
		a = 32'hfffffffa;
		b = 32'h3;
		#200;

		start = 0;
		#7000;

		start = 1;
		a = 32'hfffffffa;
		b = 32'hfffffffd;
		#200;

		start = 0;
		#7000;


		is_signed = 1;
		start = 1;
		a = 32'h6;
		b = 32'h3;
		#200;

		start = 0;
		#7000;

		start = 1;
		a = 32'h6;
		b = 32'hfffffffd;
		#200;

		start = 0;
		#7000;

		start = 1;
		a = 32'hfffffffa;
		b = 32'h3;
		#200;

		start = 0;
		#7000;

		start = 1;
		a = 32'hfffffffa;
		b = 32'hfffffffd;
		#200;

		start = 0;
		#7000;

		$stop;
  end

  always #100 clk = ~clk;

endmodule