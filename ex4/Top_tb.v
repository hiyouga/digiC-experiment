`timescale 1ns / 1ps

module Top_tb;

	// Inputs
	reg sys_clk;
	reg sys_rst;
	reg [1:0] key;

	// Outputs
	wire [1:0] com;
	wire [7:0] seg;
	wire [3:0] led;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.sys_clk(sys_clk), 
		.sys_rst(sys_rst), 
		.key(key), 
		.com(com), 
		.seg(seg), 
		.led(led)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 0;
		sys_rst = 1;
		key = 0;
		// Wait 100 ns for global reset to finish
		#100;        
		// Add stimulus here
		sys_rst = 0;
		#1;
		sys_rst = 1;
		#1;
		key[0] = 1;
		#2000000;
		key[0] = 0;
		#2000000;
		key[1] = 1;
		#2000000;
		key[1] = 0;
	end
	
	always #1 sys_clk = ~sys_clk;
      
endmodule

