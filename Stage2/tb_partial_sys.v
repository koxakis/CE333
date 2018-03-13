`timescale 1ns/10ps
`default_nettype none

module tb_partial_sys;
reg clk;
reg rst_n;

reg [31:0] mc_data_in;

wire [31:0] mc_data_out_opa, mc_data_out_opb;
 
reg [2:0] ctrl_instruction;
reg ctrl_valid_inst, ctrl_valid_data;
reg [5:0] ctrl_data_in_size;
wire procc_start;

wire [2:0] data_contition;
wire [5:0] data_length;
wire mc_done;
wire mc_we;
wire mc_data_done;
wire procc_done;

wire [5:0] mc_address_mem;
wire [31:0] mem_data_in , mem_data_out;

mem_ctrl dut_memctrl_0(
	.mc_clk(clk),
	.mc_reset(rst_n),
	.mc_address_mem(mc_address_mem),
	.mc_data_in(mc_data_in),
	.mc_data_out_opa(mc_data_out_opa),
	.mc_data_out_opb(mc_data_out_opb),
	.mem_data_in(mem_data_in),
	.mem_data_out(mem_data_out), 
	.mc_data_contition(data_contition),
	.mc_data_length(data_length),
	.mc_done(mc_done),
	.mc_we(mc_we),
	.mc_data_done(mc_data_done)
);

single_port_ram dut_ram_0(
	.mem_data_in(mem_data_in),
	.mc_address_mem(mc_address_mem),
	.mem_we(mc_we), 
	.mem_clk(clk),
	.mem_data_out(mem_data_out)
);

core_control dut_core_control_0(
	.ctrl_clk(clk),
	.ctrl_reset(rst_n),
	.ctrl_instruction(ctrl_instruction),
	.ctrl_valid_inst(ctrl_valid_inst),
	.ctrl_valid_data(ctrl_valid_data),
	.ctrl_data_in_size(ctrl_data_in_size),
	.ctrl_data_contition(data_contition),
	.mc_done(mc_done),
	.mc_data_done(mc_data_done),
	.mc_data_length(data_length),
	.procc_done(procc_done),
	.procc_start(procc_start)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	$dumpfile("tb_partial_sys.vcd");
	$dumpvars(0, tb_partial_sys);
end

initial begin
	clk = 1;
	ctrl_valid_data = 1'b0;
	ctrl_valid_inst = 1'b0;
	ctrl_data_in_size = 'd5;
	mc_data_in = 'b1111111111111111111111111111111;
	rst_n = 1;
	#50;
	ctrl_instruction = 3'b111;
	ctrl_valid_data = 1'b1;
	ctrl_valid_inst = 1'b1;
	rst_n = 0;

end

endmodule
`default_nettype wire