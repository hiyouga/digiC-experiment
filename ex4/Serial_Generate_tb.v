`timescale 1ns / 1ps

module Serial_Generate_tb;

	// Inputs
	reg clk;
	reg rst;
	reg enable;

	// Outputs
	wire serial_data;
	wire div_clk;

	// Instantiate the Unit Under Test (UUT)
	Serial_Generate uut (
		.clk(clk), 
		.enable(enable),
		.serial_data(serial_data), 
		.div_clk(div_clk), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		enable = 0;
		// Wait 100 ns for global reset to finish
		#100;        
		// Add stimulus here
		rst = 0;
		enable = 1;
		#2;
		rst = 1;
	end
	
	always #1 clk = ~clk;
      
endmodule

