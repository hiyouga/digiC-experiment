`timescale 1ns / 1ps

module MAN_decoder_tb;

	// Inputs
	reg clk;
	reg in;
	reg rst;

	// Outputs
	wire strobe;
	wire data;

	// Instantiate the Unit Under Test (UUT)
	MAN_decoder uut (
		.clk(clk), 
		.in(in), 
		.strobe(strobe), 
		.data(data), 
		.rst(rst)
	);
	
	initial begin
		// Initialize Inputs
		clk = 0;
		in = 1;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
		// Add stimulus here
		rst = 0;
		#10;
		rst = 1;
		#50;
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
		#8;
		in = 1;
	end
	
	always #1 clk = ~clk;
      
endmodule

