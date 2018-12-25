module Light_led(Light, Led);
	input [1:0] Light;
	output reg [3:0] Led;
	
	always @(*)
		case (Light)
			2'b00: Led <= 4'b0001;
			2'b01: Led <= 4'b0010;
			2'b10: Led <= 4'b0100;
			2'b11: Led <= 4'b1000;
		endcase
	
endmodule
