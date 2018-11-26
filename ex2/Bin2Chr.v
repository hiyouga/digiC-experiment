module Bin2Chr(bin, chr);
	input [3:0] bin;
	output reg [7:0] chr;
	
	always @(*) begin
		case (bin)
			4'b0000: chr <= 8'd48; // 0
			4'b0001: chr <= 8'd49; // 1
			4'b0010: chr <= 8'd50; // 2
			4'b0011: chr <= 8'd51; // 3
			default: chr <= 8'd42; // *
		endcase
	end
	
endmodule
