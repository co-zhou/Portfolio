module cache_wb(input [127:0] replace_data_in,
								input [31:0] write_data,
								input [17:0] tag,
								input [9:0] set,
								input [4:0] stall_count,
								input [1:0] block_offset,
								input clk, write, MemToRegM,
								output [127:0] replace_data_out,
								output [31:0] data,
								output [17:0] missTag,
								output hit);

	// Address Input = [Tag(18), Set(10), BlockOffset(2), ByteOffset(2)]
	// 32KB 2-way 4-word block cache
	// Bytes/Set = 32KB/(2*4*4) = 1024 Sets

	// [V[146], Tag(18)[145:128], Data(4*32)[127:0]] = 147 bits
	// cache[way][set]
	reg [146:0] cache [1:0][1023:0];
	reg [1023:0] U; // LRU bits for every set
	wire [127:0] blockDataMUX;
	wire hit_0, hit_1;
	integer i;

	initial begin // initialize all valid and LRU bits to 0
		for (i = 0; i < 1024; i = i + 1) begin
			cache[0][i][146] <= 0;
			cache[1][i][146] <= 0;
			U[i] <= 0;
		end
	end

	// Check if a hit in each way. Tag is the same as input and valid data.
	assign hit_0 = cache[0][set][146] & (cache[0][set][145:128] == tag);
	assign hit_1 = cache[1][set][146] & (cache[1][set][145:128] == tag);
	
	assign blockDataMUX = hit_0 ? cache[0][set][127:0] : (hit_1 ? cache[1][set][127:0] : 128'hz); // Tristate buffers for MUX input

	// MUX for block offset
	assign data = block_offset[1] ? (block_offset[1] ? blockDataMUX[127:96] : blockDataMUX[95:64]) : (block_offset[0] ? blockDataMUX[63:32] : blockDataMUX[31:0]);

	assign hit = hit_0 | hit_1;	// Hit or miss

	assign missTag = cache[U[set]][set][145:128]; // Least recently used tag for replacement if needed
	assign replace_data_out = cache[U[set]][set][127:0]; // Least recently used data block for replacement if needed

	// Replace cache block and tag with DRAM block. Flip U bit and make V 1
	// Also write new data into correct block offset if write is enabled and hit
	always @(posedge clk) begin
		if (hit & (write | MemToRegM)) begin
			if (write) begin
				if (block_offset == 2'b00) cache[hit_1][set][31:0] <= write_data;
				else if (block_offset == 2'b01) cache[hit_1][set][63:32] <= write_data;
				else if (block_offset == 2'b10) cache[hit_1][set][95:64] <= write_data;
				else cache[hit_1][set][127:96] <= write_data;
			end
			U[set] <= hit_0;
		end
		if (stall_count == 5'd20) begin
			cache[U[set]][set][127:0] <= replace_data_in;
			cache[U[set]][set][145:128] <= tag;
			cache[U[set]][set][146] <= 1;
		end
	end

endmodule
