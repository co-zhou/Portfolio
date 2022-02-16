module controller(input [5:0] op, func,
									input eq_ne,
                  output memwrite, regwrite, regdst, start_mult, mult_sign, memtoreg, output_branch, mfSrc, isBranch,
									output [1:0] PC_source, ALUSrc,
									output [3:0] ALU_op);


	reg [15:0] controls;

	always @(*) begin
		case (op)
			6'b000010: controls <= 17'b00x0x00x010xxxxxx; // j
      6'b000110: controls <= 17'b0100x00x000100101; // xori	
      6'b001000: controls <= 17'b0100x00x000010010; // addi	
      6'b001001: controls <= 17'b0100x00x000010010; // addiu	
      6'b001010: controls <= 17'b0100x00x000011100; // slti	
      6'b001011: controls <= 17'b0100x00x000011011; // sltiu	
      6'b001100: controls <= 17'b0100x00x000100000; // andi	
      6'b001101: controls <= 17'b0100x00x000100001; // ori	
      6'b001111: controls <= 17'b0100x00x000010110; // lui	
      6'b100011: controls <= 17'b0100x10x000010010; // lw
      6'b101011: controls <= 17'b10x0x00x000010010; // sw
      6'b000100: controls <= eq_ne ? 17'b00x0x01x101xxxxxx : 17'b00x0x00x100xxxxxx; // beq
			6'b000101: controls <= eq_ne ? 17'b00x0x00x100xxxxxx : 17'b00x0x01x101xxxxxx; // bne
      default: case (func) // R-Type
				6'b100000: controls <= 17'b0110x00x000000010; // add
				6'b100001: controls <= 17'b0110x00x000000010; // addu
				6'b100010: controls <= 17'b0110x00x000001010; // sub
				6'b100011: controls <= 17'b0110x00x000001010; // subu
				6'b100100: controls <= 17'b0110x00x000000000; // and
				6'b100101: controls <= 17'b0110x00x000000001; // or
				6'b100110: controls <= 17'b0110x00x000000101; // xor
				6'b100111: controls <= 17'b0110x00x000001101; // xnor
				6'b101010: controls <= 17'b0110x00x000001100; // slt
				6'b101011: controls <= 17'b0110x00x000001011; // sltu
				6'b010000: controls <= 17'b0110x000000110111; // mfhi
				6'b010010: controls <= 17'b0110x001000110111; // mflo
				6'b011000: controls <= 17'b0001100x00000xxxx; // mult
				6'b011001: controls <= 17'b0001000x00000xxxx; // multu
				default: controls <= 17'b0110x00x000000010; // all 0s instruction
			endcase
		endcase
	end

	assign {memwrite, regwrite, regdst, start_mult, mult_sign, memtoreg, output_branch, mfSrc, isBranch, PC_source, ALUSrc, ALU_op} = controls;

endmodule