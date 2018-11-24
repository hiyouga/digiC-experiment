module TTL74148(nS, nIN, Y, Ys, Yex);
	input nS;
	input [7:0] nIN;
	output [2:0] Y;
	output Ys;
	output Yex;
	
	wire S;
	wire [7:0] IN;
	wire [4:0] aIN;
	wire [2:0] oIN;
	wire [2:0] aS;
	wire aYs, aYex;
	
	genvar i;
	
	not(S, nS);
	
	generate
		for (i = 0; i < 8; i=i+1) begin:loop1
			not(IN[i], nIN[i]);
		end
	endgenerate
	
	or(oIN[2], IN[4], IN[5], IN[6], IN[7]);
	and(aIN[4], IN[2], nIN[4], nIN[5]);
	and(aIN[3], IN[3], nIN[4], nIN[5]);
	or(oIN[1], aIN[4], aIN[3], IN[6], IN[7]);
	and(aIN[2], IN[1], nIN[2], nIN[4], nIN[6]);
	and(aIN[1], IN[3], nIN[4], nIN[6]);
	and(aIN[0], IN[5], nIN[6]);
	or(oIN[0], aIN[2], aIN[1], aIN[0], IN[7]);
	
	generate
		for (i = 0; i < 3; i=i+1) begin:loop2
			and(aS[i], S, oIN[i]);
			not(Y[i], aS[i]);
		end
	endgenerate
	
	and(aYs, nIN[0], nIN[1], nIN[2], nIN[3], nIN[4], nIN[5], nIN[6], nIN[7], S);
	not(Ys, aYs);
	
	and(aYex, Ys, S);
	not(Yex, aYex);
	
endmodule
