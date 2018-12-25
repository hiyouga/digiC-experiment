module MAN_decoder(clk, in, strobe, data, rst);
	input clk;
	input in;
	output strobe;
	output data;
	input rst;
	
	wire edge_pulse;
	wire [2:0] q;
	wire [2:0] nq;
	wire raise;
	
	not gaten1(nq[0], q[0]);
	not gaten2(nq[1], q[1]);
	not gaten3(nq[2], q[2]);
	and gatea1(raise, nq[0], nq[1], nq[2], edge_pulse);
	
	D_FF FF(strobe, clk, raise, rst);
	
	MAN_detector man_detector (
		.clk(clk),
		.in(in),
		.data(data),
		.edge_pulse(edge_pulse),
		.rst_state_n(rst)
	);

	MAN_one_shot_Johnson man_one_shot_johnson (
		.clk(clk),
		.edge_pulse(edge_pulse),
		.q(q),
		.rst_state_n(rst)
	);
	
endmodule
