module ALU_tb;
	reg [31:0] in1, in2; 
	reg [3:0] func;
	wire [31:0] out;

  ALU dut(
  	.in1(in1),
		.in2(in2),
		.func(func),
		.out(out)
  );

  initial begin
		in1 = 32'hfffffff0;
		in2 = 32'h7ffffff1;
		func = 4'b0000; // AND
		#100;

		func = 4'b0001; // OR
		#100;

		func = 4'b0010; // ADD
		#100;

		func = 4'b1010; // SUB
		#100;

		func = 4'b0101; // XOR
		#100;

		func = 4'b1101; // XNOR
		#100;

		func = 4'b0110; // LUI
		#100;

		func = 4'b0111; // MFHI, MFLO
		#100;

		func = 4'b1011; // SLTU
		#100;

		func = 4'b1100; // SLT
		#100;

		$stop;
  end

endmodule
