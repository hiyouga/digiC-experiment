module MAN_detector(clk, in, data, edge_pulse, rst_state_n);
	input clk;
	input in;
	output data;
	output edge_pulse;
	input rst_state_n;
	
	wire q0;
	wire q1;
	not gate1(data, q1);
	
	D_FF FF0(q0, clk, in, rst_state_n);
	D_FF FF1(q1, clk, q0, rst_state_n);
	
	xor gate2(edge_pulse, q0, q1);
	
endmodule
