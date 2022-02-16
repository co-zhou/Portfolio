module hazard_unit(input isBranchD, RegWriteE, MemToRegM, RegWriteM, RegWriteW, MemToRegE, start_multD, mult_active, memstall,
									 input [4:0] rsD, rtD, rsE, rtE, WriteRegE, WriteRegM, WriteRegW,
									 output [1:0] forwardAE, forwardBE,
									 output stallF, stallD, flushE, forwardAD, forwardBD, branchstall);

	wire lwstall;
	wire multstall;

	assign lwstall = ((rsD==rtE) | (rtD==rtE)) & MemToRegE;
	assign branchstall = isBranchD & ((RegWriteE & WriteRegE != 0 & ((WriteRegE == rsD) | (WriteRegE == rtD))) | (MemToRegM & WriteRegM != 0 & ((WriteRegM == rsD) | (WriteRegM == rtD))));
	assign multstall = start_multD | mult_active;
	assign stallF = lwstall | branchstall | multstall | memstall;
	assign stallD = lwstall | branchstall | multstall | memstall;
	assign flushE = lwstall | branchstall | multstall;

	assign forwardAE = ((rsE != 0) & (rsE == WriteRegM) & RegWriteM) ? 2'b10 : (((rsE != 0) & (rsE == WriteRegW) & RegWriteW) ? 2'b01 : 2'b00);
	assign forwardBE = ((rtE != 0) & (rtE == WriteRegM) & RegWriteM) ? 2'b10 : (((rtE != 0) & (rtE == WriteRegW) & RegWriteW) ? 2'b01 : 2'b00);
	assign forwardAD = (rsD !=0) & (rsD == WriteRegM) & RegWriteM;
	assign forwardBD = (rtD !=0) & (rtD == WriteRegM) & RegWriteM;

endmodule