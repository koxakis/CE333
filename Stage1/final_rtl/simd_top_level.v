////////////////////////////////////////////////////////////////////////////////////
//Module name: Top Level Module
//File name: simd_top_level.h
//Descreption: Top level module for SIMD unit
////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/10ps
module simd_top_level(
	clk,
	clk_2,
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
	out_extra_procc1,
	out_procc2,
	out_extra_procc2,
	out_procc3,
	out_extra_procc3
);

	input clk, clk_2, reset;

	input valid_data,valid_instruction;
	input [2:0] instruction;

	input [5:0] data_size;

	output [31:0] out_procc0, out_extra_procc0, out_procc1, out_extra_procc1;
	output [31:0] out_procc2, out_extra_procc2, out_procc3 ,out_extra_procc3;

	wire [5:0] mc_address_mem_opa_w, mc_address_mem_opb_w;
	wire [127:0] mc_data_out_opa_w, mc_data_out_opb_w, mem_data_in_opa_w, mem_data_in_opb_w;

	wire [5:0] mc_address_mem;
	input [127:0] mc_data_in_opa, mc_data_in_opb ;
	wire [127:0] mc_data_out_opa, mc_data_out_opb;
	wire [5:0] ctrl_data_in_size, data_length;
	wire [2:0] data_contition;

	wire [31:0] inA_procc0, inB_procc0, inA_procc1, inB_procc1, result, extra_result;
	wire [31:0] inA_procc2, inA_procc3, inB_procc2, inB_procc3;
	wire [2:0] opcode, procc_instruction;

	wire procc_0_done, procc_1_done, procc_2_done, procc_3_done;

	wire mc_done, mc_we, mc_data_done, procc_done, procc_start;


	mem_ctrl mem_ctrl(
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

	single_port_ram single_port_ram(
		.mem_data_in_opa(mem_data_in_opa_w),
		.mem_data_in_opb(mem_data_in_opb_w),	
		.mc_address_mem_opa(mc_address_mem_opa_w),
		.mc_address_mem_opb(mc_address_mem_opb_w),
		.mem_we(mc_we), 
		.mem_clk(clk),
		.mem_data_out_opa(mc_data_out_opa_w),
		.mem_data_out_opb(mc_data_out_opb_w)
	);

	core_control core_control(
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


	assign procc_done = procc_0_done & procc_1_done & procc_2_done & procc_3_done;

	/* Data from input are seperated in 32 bit numbers for opa and opb respectivly
		from MSB to LSB of the 128 bit input these 32bit numbers are for
		procc0, procc1, procc2, procc3
		*/
	assign inA_procc0 = mc_data_out_opa_w[127:96];
	assign inB_procc0 = mc_data_out_opb_w[127:96];

	assign inA_procc1 = mc_data_out_opa_w[95:64];
	assign inB_procc1 = mc_data_out_opb_w[95:64];

	assign inA_procc2 = mc_data_out_opa_w[63:32];
	assign inB_procc2 = mc_data_out_opb_w[63:32];

	assign inA_procc3 = mc_data_out_opa_w[31:0];
	assign inB_procc3 = mc_data_out_opb_w[31:0];


	alu dut_alu_0(
		.clk(clk_2),
		.reset(reset),
		.inA(inA_procc0),
		.inB(inB_procc0),
		.opcode(procc_instruction),
		.result(out_procc0),
		.extra_result(out_extra_procc0),
		//.zero(zero),
		.PStart(procc_start),
		.PDone(procc_0_done)
	);

	alu dut_alu_1(
		.clk(clk_2),
		.reset(reset),
		.inA(inA_procc1),
		.inB(inB_procc1),
		.opcode(procc_instruction),
		.result(out_procc1),
		.extra_result(out_extra_procc1),
		//.zero(zero),
		.PStart(procc_start),
		.PDone(procc_1_done)
	);

	alu dut_alu_2(
		.clk(clk_2),		
		.reset(reset),
		.inA(inA_procc2),
		.inB(inB_procc2),
		.opcode(procc_instruction),
		.result(out_procc2),
		.extra_result(out_extra_procc2),
		.PStart(procc_start),
		.PDone(procc_2_done)
	);

	alu dut_alu_3(
		.clk(clk_2),
		.reset(reset),
		.inA(inA_procc3),
		.inB(inB_procc3),
		.opcode(procc_instruction),
		.result(out_procc3),
		.extra_result(out_extra_procc3),
		//.zero(zero),
		.PStart(procc_start),
		.PDone(procc_3_done)
	);

endmodule // simd_top_level