module ALU(input [31:0] in1, in2,
					 input [3:0] func,
					 output [31:0] out);

	reg [31:0] ALUout;
  wire [31:0] BB;
  wire [31:0] S;
  wire cout;
  
  assign BB = (func[3]) ? ~in2 : in2;
  assign {cout, S} = func[3] + in1 + BB;
  always @* begin
   case (func[2:0]) 
    3'b000 : ALUout <= in1 & BB ; // and, andi
    3'b001 : ALUout <= in1 | BB ; // or, ori
    3'b010 : ALUout <= S ; // add, addu, addi, addiu, lw, sw (Same for signed and unsigned add)
													 // sub, subu, bne, beq (Same for signed and unsigned sub)
    3'b011 : ALUout <= {31'd0, S[31]}; // sltu, sltiu (0011 is unused) (unsigned)
		3'b100 : ALUout <= {31'd0, S[31] | (in1[31] & BB[31])}; // slt, slti (signed)
		3'b101 : ALUout <= in1 ^ BB; // xor, xori 
																 // xnor
		3'b110 : ALUout <= {BB[15:0], 16'h0}; // lui
		default : ALUout <= BB; // mfhi, mflo

   endcase
  end 
 	assign out = ALUout;
endmodule

/*
	0000 : A & B
	0001 : A | B
	0010 : A + B
	0101 : A ^ B
	0110 : {in2[15:0], 16'h0}
	0111 : B
	1010 : A - B
	1011 : unsigned A < unsigned B
	1100 : signed A < signed B
	1101 : A ^ ~B
  */