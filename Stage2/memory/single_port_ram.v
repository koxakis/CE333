module single_port_ram(
	mem_data_in,
	mc_address_mem,
	mem_we, 
	mem_clk,
	mem_data_out
);

	input [31:0] mem_data_in;
	input [5:0] mc_address_mem;
	input mem_we, mem_clk;
	output [31:0] mem_data_out;

	// Declare the RAM variable
	reg [31:0] ram[63:0];
	
	// Variable to hold the registered read address
	reg [5:0] addr_reg;
	
	always @ (posedge mem_clk)
	begin
	// Write
		if (mem_we)
			ram[mc_address_mem] <= mem_data_in;
		
		addr_reg <= mc_address_mem;
		
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign mem_data_out = ram[addr_reg];
	
endmodule
