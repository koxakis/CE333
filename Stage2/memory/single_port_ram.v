////////////////////////////////////////////////////////////////////////////////////
//Module name: Ram module Module
//File name: single_port_ram.v
//Descreption: Stores data 
////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module single_port_ram(
	mem_data_in_opa,
	mem_data_in_opb,
	mc_address_mem_opa,
	mc_address_mem_opb,
	mem_we, 
	mem_clk,
	mem_data_out_opa,
	mem_data_out_opb
);

	input [31:0] mem_data_in_opa, mem_data_in_opb;
	output [31:0] mem_data_out_opa, mem_data_out_opb;
	input mem_we, mem_clk;
	input [5:0] mc_address_mem_opa, mc_address_mem_opb;

	// Declare the RAM variable
	reg [31:0] ram_opa[63:0];
	reg [31:0] ram_opb[63:0];
	
	// Variable to hold the registered read address
	reg [5:0] addr_reg_opa;
	reg [5:0] addr_reg_opb;
	
	always @ (posedge mem_clk)
	begin
	// Write
		if (mem_we) begin
			ram_opa[mc_address_mem_opa] <= mem_data_in_opa;
			ram_opb[mc_address_mem_opa] <= mem_data_in_opb;
		end

		//addr_reg_opa <= mc_address_mem_opa;
		//addr_reg_opb <= mc_address_mem_opb;
		
	end
		
	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign mem_data_out_opa = ram_opa[mc_address_mem_opa];
	assign mem_data_out_opb = ram_opb[mc_address_mem_opb];
	
endmodule
