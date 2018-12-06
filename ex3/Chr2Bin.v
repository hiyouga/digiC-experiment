module Chr2Bin(chr, bin);
	input [7:0] chr;
	output reg bin;
	
	always @(*) begin
		case (chr)
			8'd48: bin <= 0;
			8'd49: bin <= 1;
			default: bin <= 0;
		endcase
	end
	
endmodule
