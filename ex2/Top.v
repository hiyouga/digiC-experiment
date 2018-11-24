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
	wire [3:0] gate_F;
	wire [1:0] gate_P;
	wire [3:0] rtl_F;
	wire [1:0] rtl_P;
	reg [3:0] num;
	reg [3:0] display_F;
	reg [3:0] display_P;
	
	assign led = num;
	
	always @(posedge sys_clk) begin
		if (sys_rst != 0) begin
			if (switch[1] == 1'b0) begin // key_set
				if (key_out[1] == 1'b1) // inc
					num = num + 1;
				else if (key_out[0] == 1'b1) // dec
					num = num - 1;
			end
			if (switch[0] == 1'b0) begin // Gate
				display_F = gate_F;
				display_P = gate_P;
			end
			else begin // RTL
				display_F = rtl_F;
				display_P = rtl_P;
			end
		end
		else begin
			num = 4'b0;
			display_F = 4'b0;
			display_P = 4'b0;
		end
	end
	
	Float float (
		.U(num),
		.F(gate_F),
		.P(gate_P)
	);
	
	Float_RTL float_rtl (
		.U(num),
		.F(rtl_F),
		.P(rtl_P)
	);
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number1(display_F),
		.number2(display_P),
		.com(com),
		.seg(seg)
	);
	
	Key_debounce key_debounce (
		.clk(sys_clk),
		.rst(sys_rst),
		.key(key),
		.key_pulse(key_out)
	);
	
endmodule
