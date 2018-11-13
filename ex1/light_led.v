module Light_led(switch, number, out);
	input [1:0] switch;
	input [7:0] number;
	output reg [3:0] out;
	
	always @(number)
		if (switch[1] == 1'b0) // low
			out = number[3:0];
		else // high
			out = number[7:4];

endmodule
