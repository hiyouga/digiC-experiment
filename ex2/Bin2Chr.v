module Bin2Chr(bin, chr);
	input [2:0] bin;
	output reg [7:0] chr;
	
	always @(*) begin
		case (bin)
			3'b000: chr <= 8'd48; // 0
			3'b001: chr <= 8'd49; // 1
			3'b010: chr <= 8'd50; // 2
			3'b011: chr <= 8'd51; // 3
			3'b100: chr <= 8'd52; // 4
			3'b101: chr <= 8'd53; // 5
			3'b110: chr <= 8'd54; // 6
			3'b111: chr <= 8'd55; // 7
			default: chr <= 8'd42; // *
		endcase
	end
	
endmodule
