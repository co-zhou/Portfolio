module hazard_unit_tb;
	reg BranchD, RegWriteE, MemToRegM, RegWriteM, RegWriteW, MemToRegE, start_multD, mult_active;
	reg [4:0] rsD, rtD, rsE, rtE, WriteRegE, WriteRegM, WriteRegW;
	wire [1:0] forwardAE, forwardBE;
	wire stallF, stallD, flushE, forwardAD, forwardBD;

	hazard_unit dut(
		.BranchD(BranchD),
		.RegWriteE(RegWriteE),
		.MemToRegM(MemToRegM),
		.RegWriteM(RegWriteM),
		.RegWriteW(RegWriteW),
		.MemToRegE(MemToRegE),
		.start_multD(start_multD),
		.mult_active(mult_active),
		.rsD(rsD),
		.rtD(rtD),
		.rsE(rsE),
		.rtE(rtE),
		.WriteRegE(WriteRegE),
		.WriteRegM(WriteRegM),
		.WriteRegW(WriteRegW),
		.forwardAE(forwardAE),
		.forwardBE(forwardBE),
		.stallF(stallF),
		.stallD(stallD),
		.flushE(flushE),
		.forwardAD(forwardAD),
		.forwardBD(forwardBD)
	);

	initial begin
		BranchD = 0;
		RegWriteE = 0;
		MemToRegM = 0;
		RegWriteM = 0;
		RegWriteW = 0;
		MemToRegE = 0;
		start_multD = 0;
		mult_active = 0;
		rsD = 5'b00000;
		rtD = 5'b00000;
		rsE = 5'b00000;
		rtE = 5'b00000;
		WriteRegE = 5'b10000;
		WriteRegM = 5'b10000;
		WriteRegW = 5'b10000;
		#100;
		
		rsE = 5'b10000; // forwardAE
		#100;
	
		RegWriteW = 1;
		#100;

		RegWriteM = 1;
		#100;

		rtE = 5'b10000; // forwardBE
		RegWriteM = 0;
		RegWriteW = 0;
		#100;
	
		RegWriteW = 1;
		#100;

		RegWriteM = 1;
		#100;

		rsD = 5'b10000; // forwardAD
		RegWriteM = 0;
		#100;

		RegWriteM = 1;
		#100;

		rtD = 5'b10000; // forwardBD
		RegWriteM = 0;
		#100;

		RegWriteM = 1;
		#100;

		rsD = 5'b00000; // lwstall
		#100;

		MemToRegE = 1;
		#100;

		rsD = 5'b10000;
		rtD = 5'b00000;
		#100;

		MemToRegE = 0; // branchstall
		BranchD = 1;
		#100;

		RegWriteE = 1;
		#100;

		rsD = 5'b00000;
		rtD = 5'b10000;
		#100;

		RegWriteE = 0;
		MemToRegM = 1;
		#100;

		rsD = 5'b10000;
		rtD = 5'b00000;
		#100;

		BranchD = 0;
		#100;

		start_multD = 1; // multstall
		#100;	

		mult_active = 1;
		start_multD = 0;
		#100;	

		mult_active = 0;
		#100;

		$stop;
	end

endmodule
