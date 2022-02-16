module data_memory(input clk, write, MemToRegM,
            	     input [31:0] address, write_data,
            	   	 output [31:0] read_data,
									 output memstall);

	reg [4:0] stall_count;
	wire [127:0] replace_data_in, replace_data_out;
	wire [31:0] data;
	wire [17:0] missTag;
	wire [4:0] stallCount;
	wire hit;

	cache_wb cache(replace_data_in,
								 write_data,
								 address[31:14],
								 address[13:4],
								 stallCount,
								 address[3:2],
								 clk, write, MemToRegM,
								 replace_data_out,
								 data,
								 missTag,
								 hit);

  reg [31:0] data_mem [1048575:0]; // 1 Mwords 32 bit byte-addressable DRAM

	// On miss, swap then replace U way with write_data, then flip U bit, set valid bit, 20 cycle delay
	// On hit, read from or write to cache, write back will only write to cache, not DRAM as well
	
	initial stall_count <= 5'b0;
	assign stallCount = stall_count;

	// Write LRU cache block back into DRAM
	// Start stall counter up to 20
	always @(posedge clk) begin
		if (stall_count == 5'd20) begin
			data_mem[{missTag[7:0], address[13:4], 2'b00}] <= replace_data_out[127:96];
			data_mem[{missTag[7:0], address[13:4], 2'b01}] <= replace_data_out[95:64];
			data_mem[{missTag[7:0], address[13:4], 2'b10}] <= replace_data_out[63:32];
			data_mem[{missTag[7:0], address[13:4], 2'b11}] <= replace_data_out[31:0];
			stall_count <= 5'b0;
		end else if (~hit & (MemToRegM | write)) begin
			stall_count <= stall_count + 1;
		end
	end

	// Retrives the 4 word block from DRAM that is needed to replace the cache.
	// The DRAM is only 4MB , so only 20 bits are used for indexing (indexing is word addressable)
	assign replace_data_in = {data_mem[{address[21:4], 2'b00}],
												 		data_mem[{address[21:4], 2'b01}],
												 		data_mem[{address[21:4], 2'b10}],
												 		data_mem[{address[21:4], 2'b11}]};

	// Memory will always read from cache. On miss, DRAM is swapped to cache, then the cache will register a hit.
	assign read_data = data;
	assign memstall = (~hit & (MemToRegM | write));

endmodule