module cache_wb_tb;
	reg [127:0] replace_data_in;
	reg [31:0] write_data;
	reg [17:0] tag;
	reg [9:0] set;
	reg [1:0] block_offset;
	reg clk, write;
	wire [127:0] replace_data_out;
	wire [31:0] data;
	wire [17:0] missTag;
	wire hit;

	cache_wb dut(
		.replace_data_in(replace_data_in),
		.write_data(write_data),
		.tag(tag),
		.set(set),
		.block_offset(block_offset),
		.clk(clk),
		.write(write),
		.replace_data_out(replace_data_out),
		.data(data),
		.missTag(missTag),
		.hit(hit)
	);

	initial begin
		clk = 0;
		#200;

		replace_data_in = 128'h0;
		write_data = 32'hffffffff;
		tag = 18'h0;
		set = 10'h0;
		block_offset = 2'b00;
		write = 1;
		#400;

		$stop;
	end

	always #100 clk = ~clk;
endmodule