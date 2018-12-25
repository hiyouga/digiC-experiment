`timescale 1ns / 1ps

module Top_tb;

	// Inputs
	reg sys_clk;
	reg sys_rst;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.sys_clk(sys_clk), 
		.sys_rst(sys_rst)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 0;
		sys_rst = 1;
		// Wait 100 ns for global reset to finish
		#100;        
		// Add stimulus here
		sys_rst = 0;
		#1;
		sys_rst = 1;
	end
	
	always #1 sys_clk = ~sys_clk;
      
endmodule

