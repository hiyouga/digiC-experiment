`timescale 1ns / 1ps

module Top(sys_clk, sys_rst, switch, key, com, seg, led, gray);

	input sys_clk;
	input sys_rst;
	input [1:0] switch;
	input [1:0] key;
	output [1:0] com;
	output [7:0] seg;
	output [3:0] led;
	output [7:0] gray; // test
	
	
	wire [1:0] key_out;
	reg [7:0] gray;
	reg [7:0] bin;
	integer i;
	
	always @(key_out[0] or key_out[1] or sys_rst) begin
		if (!sys_rst)
			gray = 8'b0;
		else begin
			if (switch[0] == 1'b0) // preset
				if (switch[1] == 1'b0) begin // low
					if (key_out[1] == 1'b1) //inc
						gray[3:0] = gray[3:0] + 1;
					else if (key_out[0] == 1'b1) //dec
						gray[3:0] = gray[3:0] - 1;
				end
				else begin // high
					if (key_out[1] == 1'b1) //inc
						gray[7:4] = gray[7:4] + 1;
					else if (key_out[0] == 1'b1) //dec
						gray[7:4] = gray[7:4] - 1;
				end
			else // solve
				if (key_out[0] == 1'b1 && gray != 8'b0) begin
					bin[7] = gray[7];
					for (i = 6; i >= 0; i = i - 1)               
						bin[i] = bin[i+1]^gray[i];
					bin = bin - 1;
					gray = (bin >> 1) ^ bin;
				end
		end
	end
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number(gray),
		.com(com),
		.seg(seg)
	);
	
	Light_led light_led (
		.switch(switch),
		.number(gray),
		.out(led)
	);

	Key_debounce key_debounce (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Key_In(key),
		.Key_Out(key_out)
	);

endmodule
