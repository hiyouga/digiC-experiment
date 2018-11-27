`timescale 1ns / 1ps

module Float_8bit_tb;

	// Inputs
	reg [7:0] U;

	// Outputs
	wire [7:0] F;
	wire [2:0] P;

	// Instantiate the Unit Under Test (UUT)
	Float_8bit uut (
		.U(U), 
		.F(F), 
		.P(P)
	);
	
	initial begin
		// Initialize Inputs
		U = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		U = 8'b0000_0001;
		#5;
		U = 8'b0001_0010;
		#5;
		U = 8'b0000_0111;
		#5;
		U = 8'b0110_1010;
		#5;
		U = 8'b1110_1100;
		#5;
		U = 8'b1111_1111;
	end
      
endmodule

