`default_nettype none

module tb_memoryctrl;
reg clk;
reg rst_n;


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
	.mem_we(mem_we), 
	.mem_clk(clk),
	.mem_data_out(mem_data_out)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	dumpfile("tb_system.vcd");
	dumpvars(0, tb_system);
end

initial begin

end

endmodule
`default_nettype wire