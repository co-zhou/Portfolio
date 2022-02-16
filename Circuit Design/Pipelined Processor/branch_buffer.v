module branch_buffer(input [31:0] instructionPC, PCD, branchTargetD,
										 input isBranch, branchTaken, clk, branchstall,
										 output [31:0] predictedPC,
										 output prediction);

	
	// instructionPC [31:0], predictedPC [63:32], prediction bits[65:64]
	reg [65:0] buffer [63:0];

	integer i;

	initial begin
		for (i = 0; i < 64; i = i + 1) begin
			buffer[i][65:64] <= 2'b00;
		end
	end

	assign prediction = buffer[instructionPC[7:2]][31:0] == instructionPC & buffer[instructionPC[7:2]][65];
	assign predictedPC = buffer[instructionPC[7:2]][63:32];

	always @(posedge clk) begin
		if (isBranch) begin
			buffer[PCD[7:2]][31:0] <= PCD;
			buffer[PCD[7:2]][63:32] <= branchTargetD;
			if (!branchstall) begin
				if (branchTaken & buffer[PCD[7:2]][65:64] < 2'b11) begin
					buffer[PCD[7:2]][65:64] <= buffer[PCD[7:2]][65:64]+1;
				end else if (!branchTaken & buffer[PCD[7:2]][65:64] > 2'b00) begin
					buffer[PCD[7:2]][65:64] <= buffer[PCD[7:2]][65:64]-1;
				end
			end
		end
	end

endmodule