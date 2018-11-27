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
	wire [7:0] F_8bit_table;
	wire [2:0] P_8bit_table;
	wire [7:0] uart_data;
	reg [3:0] num;
	reg [7:0] num_8bit;
	reg [3:0] display_F;
	reg [1:0] display_P;
	reg [7:0] print_F;
	reg [2:0] print_P;
	
	assign led = num;
	
	always @(posedge sys_clk) begin
		if (sys_rst) begin
			// key_set
			if (key_out[1] == 1'b1) // inc
				num = num + 1;
			else if (key_out[0] == 1'b1) // dec
				num = num - 1;
			// UART
			num_8bit = uart_data;
			// Display
			if (switch[1] == 1'b0) begin // Gate
				display_F = gate_F;
				display_P = gate_P;
			end
			else begin // RTL
				display_F = rtl_F;
				display_P = rtl_P;
			end
			// Print
			if (switch[0] == 1'b0) begin // RTL
				print_F = F_8bit;
				print_P = P_8bit;
			end
			else begin // Table
				print_F = F_8bit_table;
				print_P = P_8bit_table;
			end
		end
		else begin
			num = 4'b0;
			num_8bit = 8'b0;
			display_F = 4'b0;
			display_P = 2'b0;
			print_F = 8'b0;
			print_P = 3'b0;
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
		.U(num_8bit),
		.F(F_8bit_table),
		.P(P_8bit_table)
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
	
	Uart_Top uart_top (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Signal_Tx(Uart_Tx),
		.Signal_Rx(Uart_Rx),
		.Num(uart_data),
		.F(print_F),
		.P(print_P)
	);
	
endmodule
