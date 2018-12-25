module D_FF(q, clk, d, rst_n);
	output reg q;
	input clk;
	input d;
	input rst_n;
	
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			q <= 1'b0;
		else
			q <= d;
	
endmodule
