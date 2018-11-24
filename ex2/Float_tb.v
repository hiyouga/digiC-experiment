`timescale 1ns / 1ps

module Float_tb;

	// Inputs
	reg [3:0] U;

	// Outputs
	wire [3:0] F;
	wire [1:0] P;

	// Instantiate the Unit Under Test (UUT)
	Float uut (
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
		U = 4'b0001;
		#5;
		U = 4'b0010;
		#5;
		U = 4'b0111;
		#5;
		U = 4'b1010;
		#5;
		U = 4'b1100;
		#5;
		U = 4'b1111;
	end
      
endmodule

