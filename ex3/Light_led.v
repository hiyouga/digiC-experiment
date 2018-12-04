module Light_led(light, led);
	input [1:0] light;
	output reg [3:0] led;
	
	always @(*)
		case (light)
			2'b00: led <= 4'b0001;
			2'b01: led <= 4'b0010;
			2'b10: led <= 4'b0100;
			2'b11: led <= 4'b1000;
		endcase
	
endmodule
