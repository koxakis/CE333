`timescale 1ns/10ps
`default_nettype none

module tb_full_sys;
reg clk;
reg reset;
reg valid_data;
reg valid_instruction;
reg [2:0] instruction;
reg [5:0] data_size;
reg [127:0] mc_data_in_opa, mc_data_in_opb;

reg [127:0] test_numbers_data_a [63:0] ;
reg [127:0] test_numbers_data_b [63:0] ;

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
		test_numbers_data_a[0] <= 128'h11111111_22222222_55555555_66666666;
		test_numbers_data_a[1] <= 128'h22222222_11111111_55555555_66666666;

		test_numbers_data_a[2] <= 128'h33333333_22222222_11111111_22222222;
		test_numbers_data_a[3] <= 128'h44444444_11111111_11111111_22222222;

		test_numbers_data_a[4] <= 128'h55555555_22222222_44444444_44444444;
		test_numbers_data_a[5] <= 128'h66666666_22222222_44444444_44444444;

		test_numbers_data_a[6] <= 128'h55555555_22222222_44444444_44444444;
		test_numbers_data_a[7] <= 128'h33333333_22222222_11111111_22222222;

		test_numbers_data_a[8] <= 128'h12345678_87654321_01234567_76543210;
		test_numbers_data_a[9] <= 128'h12345678_87654321_01234567_76543210;

		test_numbers_data_a[10] <= 128'hffffffff_ffffffff_ffffffff_ffffffff;
		test_numbers_data_a[11] <= 128'h00000001_00000001_00000001_00000001;

		test_numbers_data_a[12] <= 128'h12378965_32165498_12345678_98765438;
		test_numbers_data_a[13] <= 128'h99988877_33322211_51515151_46798548;	
		
	end
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
		test_numbers_data_b[0] <= 128'h11111111_22222222_33333333_44444444;
		test_numbers_data_b[1] <= 128'h22222222_11111111_33333333_44444444;

		test_numbers_data_b[2] <= 128'h11111111_22222222_55555555_22222222;
		test_numbers_data_b[3] <= 128'h22222222_11111111_55555555_22222222;

		test_numbers_data_b[4] <= 128'h11111111_22222222_99999999_66666666;
		test_numbers_data_b[5] <= 128'h11111111_22222222_99999999_66666666;

		test_numbers_data_b[6] <= 128'h33333333_22222222_11111111_22222222;
		test_numbers_data_b[7] <= 128'h11111111_22222222_33333333_44444444;

		test_numbers_data_b[8] <= 128'h10293847_56473829_12345678_83291846;
		test_numbers_data_b[9] <= 128'h21435465_98786756_13847384_38424849;

		test_numbers_data_b[10] <= 128'h00000001_00000001_00000001_00000001;
		test_numbers_data_b[11] <= 128'h99999999_99999999_99999999_99999999;

		test_numbers_data_b[12] <= 128'h12345678_87654321_01234567_76543210;
		test_numbers_data_b[13] <= 128'h12345678_87654321_01234567_76543210;	
		
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
	data_size = 'd13;
	reset = 1;
	#50;
	instruction = 3'b101;
	reset = 0;
	valid_data = 1'b1;
	valid_instruction = 1'b1;
	#20;
	for (test_values = 0; test_values < 14; test_values = test_values + 1) begin
		mc_data_in_opa = test_numbers_data_a[test_values];
		mc_data_in_opb = test_numbers_data_b[test_values];
		#10;
	end
	valid_data = 1'b0;

    #10000
    $finish;
end

endmodule
`default_nettype wire
