module reg_file(input clk, write, reset,
  							input [4:0] pr1, pr2, wr,
  							input [31:0] wd,
  							output [31:0] rd1, rd2);

  reg [31:0] rf [31:0];
	integer i;

  always @(posedge clk) begin
    if (write) rf[wr] <= wd;
		if (reset) begin
			for (i = 0; i < 32; i = i + 1) begin
				rf[i] = 32'h0;
			end
		end
  end

  assign rd1 = (pr1 != 0) ? rf[pr1] : 32'h0;
  assign rd2 = (pr2 != 0) ? rf[pr2] : 32'h0;

endmodule  