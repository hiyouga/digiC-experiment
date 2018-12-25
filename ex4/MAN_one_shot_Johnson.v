module MAN_one_shot_Johnson(clk, edge_pulse, q, rst_state_n);
	input clk;
	input edge_pulse;
	output [2:0] q;
	input rst_state_n;
	
	wire [2:0] d;
	wire d_in_xx1_n, d_1xx_xx1_n, d_x1x_n;
	
	D_FF FF_Q0(q[0], clk, d[0], rst_state_n);
	D_FF FF_Q1(q[1], clk, d[1], rst_state_n);
	D_FF FF_Q2(q[2], clk, d[2], rst_state_n);
	
	nor gate01(d[0], q[2], d_in_xx1_n);
	nor gate02(d_in_xx1_n, edge_pulse, q[0]);
	
	assign d[1] = q[0];
	
	nor gate21(d[2], d_x1x_n, d_1xx_xx1_n);
	not gate22(d_x1x_n, q[1]);
	nor gate23(d_1xx_xx1_n, q[0], q[2]);
	
endmodule
