`timescale 1ns / 1ps

module Controller_tb;

	// Inputs
	reg Sys_CLK;
	reg Sys_RST;
	reg Key_In;
	reg Mode;

	// Outputs
	wire [1:0] Light;
	wire [7:0] Number;
	wire [2:0] State;

	// Instantiate the Unit Under Test (UUT)
	Controller uut (
		.Sys_CLK(Sys_CLK), 
		.Sys_RST(Sys_RST), 
		.Key_In(Key_In), 
		.Mode(Mode), 
		.Light(Light), 
		.Number(Number), 
		.State(State)
	);

	initial begin
		// Initialize Inputs
		Sys_CLK = 0;
		Sys_RST = 1;
		Key_In = 0;
		Mode = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		Sys_RST = 0;
		#5;
		Sys_RST = 1;
		#5;
		Key_In = 1;
		#10;
		Key_In = 0;
		#10;
		Key_In = 1;
		#10;
		Key_In = 0;
		#10;
		Key_In = 1;
		#10;
		Key_In = 0;
	end
	
	always #5 Sys_CLK = ~Sys_CLK;
      
endmodule

