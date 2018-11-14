`timescale 1ns / 1ps

module Top(sys_clk, sys_rst, switch, key, com, seg, led);

	input sys_clk;
	input sys_rst;
	input [1:0] switch;
	input [1:0] key;
	output [1:0] com;
	output [7:0] seg;
	output [3:0] led;
	
	parameter solve_interval = 50000000; // a second interval
	
	wire [1:0] key_out;
	reg [7:0] gray;
	reg [7:0] num;
	//reg [7:0] num_out;
	reg auto_solve;
	integer i;
	integer cnt;
	
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
				auto_solve = 1'b0;
				// display
				num = gray;
			end
			else begin // solve
				// gray2binary
				num[7] = gray[7];
				for (i = 6; i >= 0; i = i - 1)
					num[i] = num[i+1] ^ gray[i];
				// press key
				if ((key_out[0] == 1 && gray != 8'b0)) begin // decrease
					num = num - 1;
					gray = (num >> 1) ^ num;
				end
				else if (key_out[1] == 1)  // auto on
					auto_solve = ~auto_solve;
				else begin
					if (auto_solve == 1) begin // auto solve
						cnt = cnt + 1;
						if (cnt == solve_interval && gray != 8'b0) begin
							cnt = 0;
							num = num - 1;
							gray = (num >> 1) ^ num;
						end
					end
				end
				// display
				if (switch[0] == 0)
					num = gray;
			end
		end
		else begin
			gray = 8'h00;
			auto_solve = 1'b0;
		end
	end
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number(num),
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
