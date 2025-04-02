module two_way_predictor(input [31:0] instructionPC, PCD, branchTargetD,
												 input isBranch, branchTaken, clk, branchstall,
												 output [31:0] predictedPC,
												 output prediction);


	reg [1:0] localPredictor [63:0][3:0];
	reg [1:0] globalHistory;
	wire dummy;

	branch_buffer buffer(instructionPC, PCD, branchTargetD,
											 isBranch, branchTaken, clk, branchstall,
											 predictedPC,
											 dummy);

	integer i;
	integer j;

	initial begin
		globalHistory <= 2'b00;
		for (i = 0; i < 64; i = i + 1) begin
			for (j = 0; j < 4; j = j + 1) begin
				localPredictor[i][j] <= 2'b00;
			end
		end
	end

	assign prediction = localPredictor[instructionPC[7:2]][globalHistory][1];

	always @(posedge clk) begin
		if (isBranch) begin
			if (!branchstall) begin
				if (branchTaken) begin
					if (localPredictor[PCD[7:2]][globalHistory] < 2'b11) begin
						localPredictor[PCD[7:2]][globalHistory] <= localPredictor[PCD[7:2]][globalHistory]+1;
					end
					globalHistory <= {1'b1, globalHistory[1]};
				end else begin
					if (localPredictor[PCD[7:2]][globalHistory] > 2'b00) begin
						localPredictor[PCD[7:2]][globalHistory] <= localPredictor[PCD[7:2]][globalHistory]-1;
					end
					globalHistory <= {1'b0, globalHistory[1]};
				end
			end
		end
	end

endmodule