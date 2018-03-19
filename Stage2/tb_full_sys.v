`timescale 1ns/10ps
`default_nettype none

module tb_full_sys;
reg clk;
reg reset;
reg valid_data;
reg valid_instruction;
reg [2:0] instruction;
reg [5:0] data_size;
reg [63:0] mc_data_in_opa, mc_data_in_opb;

reg [63:0] test_numbers_data_a [63:0] ;
reg [63:0] test_numbers_data_b [63:0] ;

reg [3:0] test_values;

wire [31:0] out_procc0, out_procc1, out_extra_procc0, out_extra_procc1;

simd_top_level dut_simd(
	.clk(clk),
	.reset(reset),
	.valid_data(valid_data),
	.valid_instruction(valid_instruction),
	.instruction(instruction),
	.data_size(data_size),
	.mc_data_in_opa(mc_data_in_opa),
	.mc_data_in_opb(mc_data_in_opb),
	.out_procc0(out_procc0),
	.out_extra_procc0(out_extra_procc0),
	.out_procc1(out_procc1),
	.out_extra_procc1(out_extra_procc1)
);


localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

always @(posedge clk or posedge reset) begin
	if (reset) begin
		test_numbers_data_a[0] <= 64'h11111111_22222222;
		test_numbers_data_a[1] <= 64'h22222222_11111111;

		test_numbers_data_a[2] <=  64'h33333333_22222222;
		test_numbers_data_a[3] <=  64'h44444444_11111111;

		test_numbers_data_a[4] <=  64'h55555555_22222222;
		test_numbers_data_a[5] <=  64'h66666666_22222222;

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

always @(posedge clk or posedge reset) begin
	if (reset) begin
		test_numbers_data_b[0] <= 64'h11111111_22222222;
		test_numbers_data_b[1] <= 64'h22222222_11111111;

		test_numbers_data_b[2] <=  64'h11111111_22222222;
		test_numbers_data_b[3] <=  64'h22222222_11111111;

		test_numbers_data_b[4] <= 64'h11111111_22222222;
		test_numbers_data_b[5] <= 64'h11111111_22222222;

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
	$dumpfile("tb_full_sys.vcd");
	$dumpvars(0, tb_full_sys);
end

initial begin
	clk = 1;
	valid_data = 1'b0;
	valid_instruction = 1'b0;
	data_size = 'd6;
	reset = 1;
	#50;
	instruction = 3'b000;
	reset = 0;
	valid_data = 1'b1;
	valid_instruction = 1'b1;
	#20;
	for (test_values = 0; test_values < 6; test_values = test_values + 1) begin
		mc_data_in_opa = test_numbers_data_a[test_values];
		mc_data_in_opb = test_numbers_data_b[test_values];
		#10;
	end

end

endmodule
`default_nettype wire