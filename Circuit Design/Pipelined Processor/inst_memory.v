module inst_memory(input [31:0] address,
            			 output [31:0] read_data);

  reg [31:0] inst_mem [63:0]; // 64 slots of 32 bit byte-addressable memory

  initial begin
  	$readmemh("memfile5.dat", inst_mem); // Read for memfileX.dat
  end

  assign read_data = inst_mem[address[7:2]];

endmodule
