`default_nettype none
`timescale 1ns/10ps
module tb_control;
reg clk;
reg rst_n;


//Instruction input - instruction brakdown [FPU_OP|ROUND_MODE]
reg [2:0] ctrl_instruction;


	
//Valid data and inst input for module
reg ctrl_valid_data, ctrl_valid_inst, ctrl_last_data;
reg mc_err, procc_done, mc_data_done;
reg mc_cont_procc;

wire [5:0] mc_data_address_out;
wire mc_we;

//Data validity and existance in memory [HAS_DATA|VALID_DATA|HAS_DATA_R|VALID_DATA_R]
//HAS_DATA indicates the existance of data in memory
//VALID_DATA indicates the relevance of said data to current instruction 
//HAS_DATA_R indicates the existance of data in proccessing unit registers
//VALID_DATA_R indicates the relevance of said data to current instruction
wire [3:0] ctrl_data_contition;

core_control DUT
(
	.ctrl_clk(clk),
	.ctrl_reset(rst_n),
	.ctrl_instruction(ctrl_instruction),
	.ctrl_valid_inst(ctrl_valid_inst),
	.ctrl_valid_data(ctrl_valid_data),
	.ctrl_data_in_size(data_size),
	.ctrl_data_contition(data_contition),
	.mc_done(mc_done),
	.mc_data_done(mc_data_done),
	.mc_data_length(data_length),
	.procc_instruction(procc_instruction),
	.procc_done(procc_done),
	.procc_start(procc_start)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	$dumpfile("tb_control.vcd");
	$dumpvars(0, tb_control);
end

initial begin
	clk = 1;
	ctrl_valid_data = 0;
	ctrl_instruction = 0;
	ctrl_valid_inst = 0;
	mc_cont_procc = 0;
	procc_done = 1;
	rst_n = 1;
	#100
	rst_n = 0;
	mc_data_done = 0;
	ctrl_instruction = 'b000;
	ctrl_valid_data = 1;
	ctrl_valid_inst = 1;
	#50
	ctrl_valid_data = 0;
	ctrl_valid_inst = 0;
	ctrl_last_data = 1;
	#50
	mc_cont_procc = 1;
	#50
	procc_done = 1;
	#100
	mc_data_done = 1;



	#1000
	$finish;
end

endmodule
`default_nettype wire