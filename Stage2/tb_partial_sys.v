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
reg procc_done;

wire [5:0] mc_address_mem;
reg [31:0] mc_data_in_opa, mc_data_in_opb ;

reg [3:0] test_values;
reg [31:0] test_numbers_data_a [13:0];
reg [31:0] test_numbers_data_b [13:0];

wire [5:0] mc_address_mem_opa_w, mc_address_mem_opb_w;
wire [31:0] mc_data_out_opa_w, mc_data_out_opb_w, mem_data_in_opa_w, mem_data_in_opb_w;

mem_ctrl dut_memctrl_0(
	.mc_clk(clk),
	.mc_reset(rst_n),
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

always @(posedge clk or posedge rst_n) begin
	if (rst_n) begin
		test_numbers_data_a[0] <= 'd11111111;
		test_numbers_data_a[1] <= 'd22222222;

		test_numbers_data_a[2] <= 'd33333333;
		test_numbers_data_a[3] <= 'd44444444;

		test_numbers_data_a[4] <= 'd55555555;
		test_numbers_data_a[5] <= 'd66666666;

		test_numbers_data_a[6] <= 'd77777777;
		test_numbers_data_a[7] <= 'd88888888;

		test_numbers_data_a[8] <= 'd99999999;
		test_numbers_data_a[9] <= 'd10101010;

		test_numbers_data_a[10] <= 'd1313131;
		test_numbers_data_a[11] <= 'd1414141;

		test_numbers_data_a[12] <= 'd1515151;
		test_numbers_data_a[13] <= 'd1717171;	
		
	end
end

always @(posedge clk or posedge rst_n) begin
	if (rst_n) begin
		test_numbers_data_b[0] <= 'd66611111;
		test_numbers_data_b[1] <= 'd66622222;

		test_numbers_data_b[2] <= 'd66633333;
		test_numbers_data_b[3] <= 'd66644444;

		test_numbers_data_b[4] <= 'd66655555;
		test_numbers_data_b[5] <= 'd99966666;

		test_numbers_data_b[6] <= 'd66677777;
		test_numbers_data_b[7] <= 'd66688888;

		test_numbers_data_b[8] <= 'd66699999;
		test_numbers_data_b[9] <= 'd66601010;

		test_numbers_data_b[10] <= 'd6613131;
		test_numbers_data_b[11] <= 'd6614141;

		test_numbers_data_b[12] <= 'd6615151;
		test_numbers_data_b[13] <= 'd6617171;	
		
	end
end

initial begin
	$dumpfile("tb_partial_sys.vcd");
	$dumpvars(0, tb_partial_sys);
end

initial begin
	clk = 1;
	ctrl_valid_data = 1'b0;
	ctrl_valid_inst = 1'b0;
	ctrl_data_in_size = 'd14;
	rst_n = 1;
	#50;
	ctrl_instruction = 3'b111;
	rst_n = 0;
	ctrl_valid_data = 1'b1;
	ctrl_valid_inst = 1'b1;
	#20;
	for (test_values = 0; test_values < 14; test_values = test_values + 1) begin
		mc_data_in_opa = test_numbers_data_a[test_values];
		mc_data_in_opb = test_numbers_data_b[test_values];
		#10;
	end
	#20
	procc_done = 1'b1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;
		#20
	procc_done = 1;

end

endmodule
`default_nettype wire