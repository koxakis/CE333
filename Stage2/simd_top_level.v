////////////////////////////////////////////////////////////////////////////////////
//Module name: Top Level Module
//File name: simd_top_level.h
//Descreption: Top level module for SIMD unit
////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module simd_top_level(
	clk,
	reset,
	valid_data,
	valid_instruction,
	instruction,
	data_size,
	mc_data_in_opa,
	mc_data_in_opb,
	out_procc0,
	out_extra_procc0,
	out_procc1,
	out_extra_procc1
);

	input clk, reset;

	input valid_data,valid_instruction;
	input [2:0] instruction;

	input [5:0] data_size;

	output [31:0] out_procc0, out_extra_procc0, out_procc1, out_extra_procc1;

	wire [5:0] mc_address_mem_opa_w, mc_address_mem_opb_w;
	wire [63:0] mc_data_out_opa_w, mc_data_out_opb_w, mem_data_in_opa_w, mem_data_in_opb_w;

	wire [5:0] mc_address_mem;
	input [63:0] mc_data_in_opa, mc_data_in_opb ;
	wire [63:0] mc_data_out_opa, mc_data_out_opb;
	wire [5:0] ctrl_data_in_size, data_length;
	wire [2:0] data_contition;

	wire [31:0] inA_procc0, inB_procc0, inA_procc1, inB_procc1, result, extra_result;
	wire [2:0] opcode, procc_instruction;

	wire procc_0_done, procc_1_done;


	mem_ctrl dut_memctrl_0(
		.mc_clk(clk),
		.mc_reset(reset),
		.mc_address_mem_opa(mc_address_mem_opa_w),
		.mc_address_mem_opb(mc_address_mem_opb_w),
		.mc_data_in_opa(mc_data_in_opa),
		.mc_data_in_opb(mc_data_in_opb),
		.mc_data_out_opa(mc_data_out_opa),
		.mc_data_out_opb(mc_data_out_opb),
		.mem_data_in_opa(mem_data_in_opa_w),
		.mem_data_in_opb(mem_data_in_opb_w),	
		.mem_data_out_opa(mc_data_out_opa_w),
		.mem_data_out_opb(mc_data_out_opb_w),
		.mc_data_contition(data_contition),
		.mc_data_length(data_length),
		.mc_done(mc_done),
		.mc_we(mc_we),
		.mc_data_done(mc_data_done)
	);

	single_port_ram dut_ram_0(
		.mem_data_in_opa(mem_data_in_opa_w),
		.mem_data_in_opb(mem_data_in_opb_w),	
		.mc_address_mem_opa(mc_address_mem_opa_w),
		.mc_address_mem_opb(mc_address_mem_opb_w),
		.mem_we(mc_we), 
		.mem_clk(clk),
		.mem_data_out_opa(mc_data_out_opa_w),
		.mem_data_out_opb(mc_data_out_opb_w)
	);

	core_control dut_core_control_0(
		.ctrl_clk(clk),
		.ctrl_reset(reset),
		.ctrl_instruction(instruction),
		.ctrl_valid_inst(valid_instruction),
		.ctrl_valid_data(valid_data),
		.ctrl_data_in_size(data_size),
		.ctrl_data_contition(data_contition),
		.mc_done(mc_done),
		.mc_data_done(mc_data_done),
		.mc_data_length(data_length),
		.procc_instruction(procc_instruction),
		.procc_done(procc_done),
		.procc_start(procc_start)
	);


	assign procc_done = procc_0_done & procc_1_done;

	assign inA_procc0 = mc_data_out_opa_w[63:32];
	assign inB_procc0 = mc_data_out_opb_w[63:32];

	assign inA_procc1 = mc_data_out_opa_w[31:0];
	assign inB_procc1 = mc_data_out_opb_w[31:0];

	alu dut_alu_0(
		.clk(clk),
		.inA(inA_procc0),
		.inB(inB_procc0),
		.opcode(procc_instruction),
		.result(out_procc0),
		.extra_result(out_extra_procc0),
		.zero(zero),
		.PStart(procc_start),
		.PDone(procc_0_done)
	);

	alu dut_alu_1(
		.clk(clk),
		.inA(inA_procc1),
		.inB(inB_procc1),
		.opcode(procc_instruction),
		.result(out_procc1),
		.extra_result(out_extra_procc1),
		.zero(zero),
		.PStart(procc_start),
		.PDone(procc_1_done)
	);

endmodule // simd_top_level