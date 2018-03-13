`timescale 1ns/10ps
`default_nettype none

module tb_memoryctrl;
reg clk;
reg rst_n;

reg [31:0] mc_data_in;

wire [31:0] mc_data_out_opa, mc_data_out_opb;
 
reg [2:0] mc_data_contition;
reg mc_data_length;
wire mc_done;
wire mc_we;
wire mc_data_done;

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
	.mc_data_contition(mc_data_contition),
	.mc_data_length(mc_data_length),
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

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	$dumpfile("tb_memoryctrl.vcd");
	$dumpvars(0, tb_memoryctrl);
end

initial begin
	clk = 1;
	rst_n = 1;
	#50;
	rst_n = 0;
end

endmodule
`default_nettype wire