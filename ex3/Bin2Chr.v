module Bin2Chr(bin, chr);
	input bin;
	output reg [7:0] chr;
	
	always @(*) begin
		case (bin)
			3'b0: chr <= 8'd48; // 0
			3'b1: chr <= 8'd49; // 1
		endcase
	end
	
endmodule
