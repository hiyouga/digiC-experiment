`timescale 1ns / 1ps

module Top_tb;

	// Inputs
	reg sys_clk;
	reg sys_rst;
	reg [1:0] switch;
	reg [1:0] key;
	reg Uart_Rx;

	// Outputs
	wire [1:0] com;
	wire [7:0] seg;
	wire [3:0] led;
	wire Uart_Tx;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.sys_clk(sys_clk), 
		.sys_rst(sys_rst), 
		.switch(switch), 
		.key(key), 
		.com(com), 
		.seg(seg), 
		.led(led), 
		.Uart_Tx(Uart_Tx), 
		.Uart_Rx(Uart_Rx)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 0;
		sys_rst = 1;
		switch = 0;
		key = 0;
		Uart_Rx = 0;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		sys_rst = 0;
		#10;
		sys_rst = 1;
		#10;
		switch = 2'b00;
		#10;
		key = 2'b01;
		#2000000;
		key = 2'b00;
		#10;
		switch = 2'b01;
		#10;
		key = 2'b01;
		#2000000;
		key = 2'b00;
		#1000000;
		key = 2'b01;
		#2000000;
		key = 2'b00;
		#3000000;
		key = 2'b01;
		#2000000;
		key = 2'b00;
		#2500000;
		key = 2'b01;
		#2000000;
		key = 2'b00;
		#3500000;
		key = 2'b01;
		#2000000;
		key = 2'b00;
		#100;
		switch = 2'b00;
		#100;
		switch = 2'b10;
		#100;
		key = 2'b10;
		#2000000;
		key = 2'b00;
	end
	
	always #1 sys_clk = ~sys_clk;
      
endmodule

