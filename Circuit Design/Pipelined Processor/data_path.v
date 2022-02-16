module data_path(input clk, reset);

	// INITIALIZATION

	// Fetch
	wire [31:0] instrF, PCPrime, PCPrediction, PCBranchD, PCJumpD, PCPlus4F, predictOut;
	wire [1:0] PCSourceD;
	wire stallF, isBranchD, branchD, predictionF;
	reg [31:0] PCF, instrD, PCD, PCPlus4D;

  branch_buffer buffer(PCF, PCD, PCBranchD,
											 isBranchD, branchD, clk, branchstall,
											 predictOut,
											 predictionF);

/*two_way_predictor predictor(PCF, PCD, PCBranchD,
											 				isBranchD, branchD, clk, branchstall,
											 				predictOut,
															predictionF);*/

	inst_memory imem(PCF, instrF);

	// Decode
	reg [31:0] ALUOutM;
	reg [4:0] WriteRegM;
	reg RegWriteM, MemToRegM, predictionD;
	wire [31:0] ResultW, SignImmD, ZeroImmD, rd1D, rd2D, eq1, eq2, ReadDataM;
	wire [4:0] rsD, rtD, rdD;
	wire [3:0] ALUOpD;
	wire [1:0] ALUSrcD;
	wire stallD, forwardAD, forwardBD, MemWriteD, RegWriteD, RegDstD, start_multD, mult_signD, MemToRegD, mfSrcD;
	
	controller ctrl(instrD[31:26], instrD[5:0],
									eq1 == eq2,
                  MemWriteD, RegWriteD, RegDstD, start_multD, mult_signD, MemToRegD, branchD, mfSrcD, isBranchD,
									PCSourceD, ALUSrcD,
									ALUOpD);

	reg_file rf(clk, RegWriteM, reset,
  						instrD[25:21], instrD[20:16], WriteRegM,
  						MemToRegM ? ReadDataM : ALUOutM,
  						rd1D, rd2D);

	// Execute
	reg [31:0] rd1E, rd2E, SignImmE, ZeroImmE;
	reg [4:0] rsE, rtE, rdE;
	reg [3:0] ALUOpE;
	reg [1:0] ALUSrcE;
	reg MemWriteE, RegWriteE, RegDstE, start_multE, mult_signE, MemToRegE, mfSrcE;
	wire [31:0] SrcAE, SrcBE, WriteDataE, mfhi, mflo, ALUOutE, mfE;
	wire [4:0] WriteRegE;
	wire [1:0] forwardAE, forwardBE;
	wire flushE, mult_active;

	ALU alu(SrcAE, SrcBE,
					ALUOpE,
					ALUOutE);

	multiplier mult(SrcAE, SrcBE,
									clk, start_multE, mult_signE, reset,
									{mfhi, mflo},
									mult_active);

	// Memory
	reg [31:0] WriteDataM;
	reg MemWriteM;
	wire memstall;

	data_memory dmem(clk, MemWriteM, MemToRegM,
            	     ALUOutM, WriteDataM,
            	   	 ReadDataM,
									 memstall);

	// Writeback
	reg [31:0] ReadDataW, ALUOutW;
	reg [4:0] WriteRegW;
	reg RegWriteW, MemToRegW;

	hazard_unit hazard_unit(isBranchD, RegWriteE, MemToRegM, RegWriteM, RegWriteW, MemToRegE, start_multE, mult_active, memstall,
							rsD, rtD, rsE, rtE, WriteRegE, WriteRegM, WriteRegW,
							forwardAE, forwardBE,
							stallF, stallD, flushE, forwardAD, forwardBD, branchstall);


	// ASSIGNMENT 

	// Fetch
	always @(posedge clk) begin // PCF reg
		if (reset) begin
			PCF <= 32'h0;
		end else begin
    	if (~stallF) begin
		  	PCF <= PCPrime;     
			end
    end  
  end

	assign PCPlus4F = PCF + 4;
	assign PCPrediction = (PCSourceD[0] ^ predictionD) ? PCPlus4D : (predictionF) ? predictOut : PCPlus4F;
	assign PCPrime = (PCSourceD[1]) ? PCJumpD : ((PCSourceD[0] & ~predictionD) ? PCBranchD : PCPrediction); /* PC MUX
																																							 					00 : PC+4
																																							 					01 : Branch
																																							 					10 : Jump */

	// Decode
	always @(posedge clk) begin // Pipeline Reg D
		if (reset) begin
			instrD <= 32'h0;
			PCPlus4D <= 32'h0;
			PCD <= 32'h0;
			predictionD <= 0;
		end else begin
			if (~stallD) begin
				if (PCSourceD == 2'b10 | (PCSourceD[0] ^ predictionD)) begin
					instrD <= 32'h0;
					PCPlus4D <= 32'h0;
					PCD <= 32'h0;
					predictionD <= 0;
				end else begin
					instrD <= instrF;
					PCPlus4D <= PCPlus4F;
					PCD <= PCF;
					predictionD <= predictionF;
				end
			end
		end
	end

	assign PCJumpD = {PCPlus4D[31:28], instrD[25:0], 2'b00}; // Jump Address
	assign rsD = instrD[25:21]; // rsD
	assign rtD = instrD[20:16]; // rtD
	assign rdD = instrD[15:11]; // rdD
	assign SignImmD = {{16{instrD[15]}}, instrD[15:0]}; // sign extend immediate
	assign ZeroImmD = {16'b0, instrD[15:0]}; // zero extend immediate
	assign PCBranchD = PCPlus4D + (SignImmD << 2); // branch address
	assign eq1 = forwardAD ? ALUOutM : rd1D; // early branch resolution
	assign eq2 = forwardBD ? ALUOutM : rd2D; // with data forwarding

	// Execute
	always @(posedge clk) begin // Pipeline Reg E
		if (flushE || reset) begin
			rd1E <= 32'h0;
			rd2E <= 32'h0;
			SignImmE <= 32'h0;	
			ZeroImmE <= 32'h0;
			rsE <= 5'h0;
			rtE <= 5'h0;
			rdE <= 5'h0;			 
			ALUOpE <= 4'h0;			 
			ALUSrcE <= 2'h0;			 
			MemWriteE <= 0;
			RegWriteE <= 0;
			RegDstE <= 0;
			start_multE <= 0;
			mult_signE <= 0;
			MemToRegE <= 0;		
			mfSrcE <= 0;				
		end else begin
			if (~memstall) begin
				rd1E <= rd1D;
				rd2E <= rd2D;
				SignImmE <= SignImmD;		
				ZeroImmE <= ZeroImmD;	
				rsE <= rsD;
				rtE <= rtD;
				rdE <= rdD;			 
				ALUOpE <= ALUOpD; 
				ALUSrcE <= ALUSrcD;			 
				MemWriteE <= MemWriteD;
				RegWriteE <= RegWriteD;
				RegDstE <= RegDstD;
				start_multE <= start_multD;
				mult_signE <= mult_signD;
				MemToRegE <= MemToRegD;
				mfSrcE <= mfSrcD;					
			end else begin
				if (RegWriteW) begin
					if (forwardAE == 2'b01) rd1E <= ResultW;
					if (forwardBE == 2'b01) rd2E <= ResultW;
				end
			end
		end
	end

	assign WriteRegE = RegDstE ? rdE : rtE; // Register Destination MUX
	assign SrcAE = forwardAE[1] ? ALUOutM : (forwardAE[0] ? ResultW : rd1E); // Data Fowarding A
	assign WriteDataE = forwardBE[1] ? ALUOutM : (forwardBE[0] ? ResultW : rd2E); // Data Fowarding B
	assign mfE = mfSrcE ? mflo : mfhi; // multiplier output source
	assign SrcBE = ALUSrcE[1] ? (ALUSrcE[0] ? mfE : ZeroImmE) : (ALUSrcE[0] ? SignImmE : WriteDataE); // ALU Source B

	// Memory
	always @(posedge clk) begin // Pipeline Reg M
		if (reset) begin
			ALUOutM <= 32'h0;
			WriteDataM <= 32'h0;
			WriteRegM <= 5'b0;
			MemWriteM <= 0;
	  	RegWriteM <= 0;
			MemToRegM <= 0;
		end else if (~memstall) begin
			ALUOutM <= ALUOutE;
			WriteDataM <= WriteDataE;
			WriteRegM <= WriteRegE;
			MemWriteM <= MemWriteE;
	  	RegWriteM <= RegWriteE;
			MemToRegM <= MemToRegE;
		end
	end

	// Writeback
	always @(posedge clk) begin // Pipeline Reg W
		if (reset) begin
			ALUOutW <= 32'h0;
			ReadDataW <= 32'h0;
			WriteRegW <= 0;
	  	RegWriteW <= 0;
			MemToRegW <= 0;
		end else begin
			ALUOutW <= ALUOutM;
			ReadDataW <= ReadDataM;
			WriteRegW <= WriteRegM;
	  	RegWriteW <= RegWriteM;
			MemToRegW <= MemToRegM;
		end
	end

	assign ResultW = MemToRegW ? ReadDataW : ALUOutW; // Writeback MUX

endmodule