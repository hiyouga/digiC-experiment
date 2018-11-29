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
	wire [3:0] gate_F;
	wire [1:0] gate_P;
	wire [3:0] rtl_F;
	wire [1:0] rtl_P;
	wire [7:0] F_8bit;
	wire [2:0] P_8bit;
	wire [7:0] uart_data;
	wire [7:0] uart_F;
	wire [2:0] uart_P;
	reg [3:0] num;
	reg [7:0] num_8bit;
	reg [3:0] display_1;
	reg [3:0] display_2;
	reg [3:0] led;
	
	always @(posedge sys_clk or negedge sys_rst) begin
		if (!sys_rst) begin
			num <= 4'b0;
			num_8bit <= 8'b0;
		end
		else begin
			if (key_out[1] == 1'b1) begin // inc
				num <= num + 1;
				num_8bit <= num_8bit + 1;
			end
			else if (key_out[0] == 1'b1) begin // dec
				num <= num - 1;
				num_8bit <= num_8bit - 1;
			end
		end
	end
	
	always @(posedge sys_clk or negedge sys_rst) begin
		if (!sys_rst) begin
			display_1 <= 4'b0;
			display_2 <= 4'b0;
			led <= 4'b0;
		end
		else begin
			if (switch[1] == 1'b0) begin // 4-bit
				led <= num;
				if (switch[0] == 1'b0) begin // Gate
					display_1 <= gate_F;
					display_2 <= gate_P;
				end
				else begin // RTL
					display_1 <= rtl_F;
					display_2 <= rtl_P;
				end
			end
			else begin // 8-bit
				if (switch[0] == 1'b0) begin // Set
					display_1 <= num_8bit[7:4];
					display_2 <= num_8bit[3:0];
					led <= 4'b0;
				end
				else begin // Display
					display_1 <= F_8bit[7:4];
					display_2 <= F_8bit[3:0];
					led <= P_8bit;
				end
			end
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
	
	Float_8bit float_8bit (
		.U(num_8bit),
		.F(F_8bit),
		.P(P_8bit)
	);
	
	Float_8bit_Table float_8bit_table (
		.U(uart_data),
		.F(uart_F),
		.P(uart_P)
	);
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number1(display_1),
		.number2(display_2),
		.com(com),
		.seg(seg)
	);
	
	Key_debounce key_debounce (
		.clk(sys_clk),
		.rst(sys_rst),
		.key(key),
		.key_pulse(key_out)
	);
	
	Uart_Top uart_top (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Signal_Tx(Uart_Tx),
		.Signal_Rx(Uart_Rx),
		.Num(uart_data),
		.F(uart_F),
		.P(uart_P)
	);
	
endmodule
