`timescale 1ns / 1ps

module Top(sys_clk, sys_rst, switch, key, com, seg, led);

	input sys_clk;
	input sys_rst;
	input [1:0] switch;
	input [1:0] key;
	output [1:0] com;
	output [7:0] seg;
	output [3:0] led;
	
	
	wire [1:0] key_out;
	reg [7:0] gray = 8'b0;
	reg [7:0] bin;
	reg [7:0] num_out;
	integer i;
	
	always @(posedge sys_clk) begin
		if (sys_rst != 0) begin
			if (switch[1] == 1'b0) begin // preset
				if (switch[0] == 1'b0) begin // low
					if (key_out[1] == 1'b1) // inc
						gray[3:0] = gray[3:0] + 1;
					else if (key_out[0] == 1'b1) // dec
						gray[3:0] = gray[3:0] - 1;
				end
				else begin // high
					if (key_out[1] == 1'b1) // inc
						gray[7:4] = gray[7:4] + 1;
					else if (key_out[0] == 1'b1) // dec
						gray[7:4] = gray[7:4] - 1;
				end
				num_out = gray;
			end
			else begin // solve
				if (key_out[0] == 1'b1 && gray != 8'b0) begin
					bin[7] = gray[7];
					for (i = 6; i >= 0; i = i - 1)
						bin[i] = bin[i+1]^gray[i];
					bin = bin - 1;
					gray = (bin >> 1) ^ bin;
				end
				if (switch[0] == 1'b0) begin
					num_out = gray;
				end
				else begin
					num_out = bin;
				end
			end
		end
		else
			gray = 8'b0;
	end
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number(num_out),
		.com(com),
		.seg(seg)
	);
	
	Light_led light_led (
		.switch(switch),
		.number(gray),
		.out(led)
	);

	Key_debounce key_debounce (
		.clk(sys_clk),
		.rst(sys_rst),
		.key(key),
		.key_pulse(key_out)
	);

endmodule
