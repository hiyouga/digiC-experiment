`timescale 1ns / 1ps

module Sync_capturer_tb;

	// Inputs
	reg clk;
	reg in;
	reg rst;

	// Outputs
	wire strobe;
	wire data;

	// Instantiate the Unit Under Test (UUT)
	Sync_capturer uut (
		.clk(clk), 
		.in(in), 
		.strobe(strobe), 
		.data(data), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		in = 1;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		rst = 0;
		#50;
		rst = 1;
		#50;
		in = 0;
		#24;
		in = 1;
		#24;
		in = 0;
		#8; // Correct
		//#16; // Wrong
		in = 1;
		#16;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#16;
		in = 1;
		#16;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#16;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
		#8;
		in = 0;
		#8;
		in = 1;
	end
	
	always #1 clk = ~clk;
      
endmodule

