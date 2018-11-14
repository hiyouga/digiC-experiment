module Light_led(switch, number, out);
	input [1:0] switch;
	input [7:0] number;
	output reg [3:0] out;
	
	always @(*)
		if (switch[1] == 0) // preset
			if (switch[0] == 0) // low
				out <= number[3:0];
			else // high
				out <= number[7:4];
		else // solve
			out <= 4'h0;
	
endmodule
