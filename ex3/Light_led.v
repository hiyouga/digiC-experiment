module Light_led(Light, Led);
	input [1:0] Light;
	output reg [3:0] Led;
	
	always @(*)
		case (Light)
			2'b00: Led <= 4'b0000;
			2'b01: Led <= 4'b0011;
			2'b10: Led <= 4'b0101;
			2'b11: Led <= 4'b1100;
		endcase
	
endmodule
