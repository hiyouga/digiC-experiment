`timescale 1ns / 1ps

module Top(sys_clk, sys_rst, switch, key, com, seg, led, Uart_Tx, Uart_Rx);
	input sys_clk;
	input sys_rst;
	input [1:0] switch;
	input [1:0] key;
	output [1:0] com;
	output [7:0] seg;
	output [3:0] led;
	input Uart_Rx;
	output Uart_Tx;
	
	wire [1:0] key_out;
	wire [1:0] light;
	wire [2:0] state;
	wire [7:0] number;
	reg mode;
	
	always @(posedge sys_clk or negedge sys_rst) begin
		if (!sys_rst) begin
			mode <= 1'b0;
		end
		else begin
			if (switch[1] == 1'b0)
				mode <= 1'b0;
			else
				mode <= 1'b1;
		end
	end
	
	Key_debounce key_debounce (
		.clk(sys_clk),
		.rst(sys_rst),
		.key(key),
		.key_pulse(key_out)
	);
	
	Controller controller (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Key_In(key_out[0]),
		.Mode(mode),
		.Light(light),
		.Number(number),
		.State(state)
	);
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number(number),
		.state(state),
		.com(com),
		.seg(seg)
	);
	
	Light_led light_led (
		.light(light),
		.led(led)
	);
	
	Uart_Top uart_top (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Signal_Tx(Uart_Tx),
		.Signal_Rx(Uart_Rx)
	);
	
endmodule
