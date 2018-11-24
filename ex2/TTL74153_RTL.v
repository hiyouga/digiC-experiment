module TTL74153_RTL(nS, IN, A, Y);
	input [1:0] nS;
	input [7:0] IN;
	input [1:0] A;
	output reg [1:0] Y;
	
	always @(nS, IN, A) begin
		if (!nS[1])
			Y[1] <= IN[A+4];
		if (!nS[0])
			Y[0] <= IN[A];
	end
	
endmodule
