module multiplier(input [31:0] a, b,
									input clk, start, is_signed, reset,
									output [63:0] s,
									output mult_active);

	reg [63:0] multiplicand;
	reg [31:0] multiplier;
	reg [63:0] product;
	reg active, sign, signA, signB;

	always @(posedge clk) begin
		if (reset) begin
			multiplicand <= 64'h0;
			multiplier <= 32'h0;
			product <= 64'h0;
			active <= 0;
			sign <= 0;
			signA <= 0;
			signB <= 0;
		end else begin
			if (start) begin
				product <= 64'h0;
				active <= 1;
				sign <= is_signed;
				signA <= a[31];
				signB <= b[31];
				if (is_signed && a[31]) begin
					multiplicand <= {32'h0, (~a) + 1};
				end else begin
					multiplicand <= a;
				end
				if (is_signed && b[31]) begin
					multiplier <= (~b) + 1;
				end else begin
					multiplier <= b;
				end
			end
		end

		if (multiplier != 32'h0) begin
			if (multiplier[0]) begin
				product <= product + multiplicand;
			end
			multiplicand <= multiplicand << 1;
			multiplier <= multiplier >> 1;
		end else begin
			if (active) active <= 0;
		end
	end

	assign s = ((sign) && (signA ^ signB)) ? (~product) + 1 : product;
	assign mult_active = active;

endmodule