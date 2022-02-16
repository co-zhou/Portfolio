module controller_tb;
	reg [5:0] op, func;
	reg eq_ne;
  wire memwrite, regwrite, regdst, start_mult, mult_sign, memtoreg, output_branch;
	wire [1:0] PC_source, ALUSrc;
	wire [3:0] ALU_op;

	controller dut(
		.op(op),
		.func(func),
		.eq_ne(eq_ne),
		.memwrite(memwrite),
		.regwrite(regwrite),
		.ALUSrc(ALUSrc),
		.regdst(regdst),
		.start_mult(start_mult),
		.mult_sign(mult_sign),
		.memtoreg(memtoreg),
		.output_branch(output_branch),
		.PC_source(PC_source),
		.ALU_op(ALU_op)
	);

	initial begin
		op = 6'b000010; // j
		func = 6'b000000;
		eq_ne = 0;
		#100;

		op = 6'b000110; // xori
		#100;

		op = 6'b001000; // addi
		#100;		

		op = 6'b001001; // addiu
		#100;

		op = 6'b001010; // slti
		#100;

		op = 6'b001011; // sltiu
		#100;

		op = 6'b001100; // andi
		#100;

		op = 6'b001101; // ori
		#100;

		op = 6'b001111; // lui
		#100;

		op = 6'b100011; // lw
		#100;

		op = 6'b101011; // sw
		#100;

		op = 6'b000100; // beq not equal
		#100;

		eq_ne = 1; // beq is equal
		#100;

		op = 6'b000101; // bne is equal
		#100;

		eq_ne = 0; // bne not equal
		#100;

		op = 6'b000000; // all 0s
		#100;

		func = 6'b100000; // add
		#100;

		func = 6'b100001; // addu
		#100;

		func = 6'b100010; // sub
		#100;

		func = 6'b100011; // subu
		#100;

		func = 6'b100100; // and
		#100;

		func = 6'b100101; // or
		#100;

		func = 6'b100110; // xor
		#100;

		func = 6'b100111; // xnor
		#100;

		func = 6'b101010; // slt
		#100;

		func = 6'b101011; // sltu
		#100;

		func = 6'b010000; // mfhi
		#100;

		func = 6'b010010; // mflo
		#100;

		func = 6'b011000; // mult
		#100;

		func = 6'b011001; // multu
		#100;

		func = 6'b000000; // multu
		#100;
		
		$stop;
	end

endmodule