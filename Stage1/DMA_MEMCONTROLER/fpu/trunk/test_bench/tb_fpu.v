`default_nettype none

module tb_fpu;
reg clk;

reg [1:0] rmode;
reg [2:0] fpu_op;
reg [31:0] opa, opb;
wire [31:0] out;
wire inf, snan, qnan;
wire ine;
wire overflow, underflow;
wire zero;	
wire div_by_zero;

fpu dut_fpu_0
(
	.clk (clk),
	.rmode(rmode),
	.fpu_op(fpu_op),
	.opa(opa),
	.opb(opb),
	.out(out),
	.inf(inf),
	.snan(snan),
	.qnan(qnan),
	.ine(ine),
	.overflow(overflow),
	.underflow(underflow),
	.zero(zero),
	.div_by_zero(div_by_zero)
);

localparam CLK_PERIOD = 50;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
	dumpfile("tb_fpu.vcd");
	dumpvars(0, tb_fpu);
end

initial begin
	clk = 1;
	#100;
	opa = 'd55;
	opb = 'd55;
	rmode = 'd0;
	fpu_op = 'd0;
end

endmodule
`default_nettype wire	