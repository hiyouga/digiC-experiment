module TTL74153(nS, IN, A, Y);
	input [1:0] nS;
	input [7:0] IN;
	input [1:0] A;
	output [1:0] Y;
	
	wire [1:0] S;
	wire [7:0] aD;
	wire [1:0] nA;
	wire [1:0] oS;
	
	not(S[1], nS[1]);
	not(S[0], nS[0]);
	not(nA[1], A[1]);
	not(nA[0], A[0]);
	
	and(aD[7], IN[7], A[1], A[0]);
	and(aD[6], IN[6], A[1], nA[0]);
	and(aD[5], IN[5], nA[1], A[0]);
	and(aD[4], IN[4], nA[1], nA[0]);
	and(aD[3], IN[3], A[1], A[0]);
	and(aD[2], IN[2], A[1], nA[0]);
	and(aD[1], IN[1], nA[1], A[0]);
	and(aD[0], IN[0], nA[1], nA[0]);
	
	or(oS[1], aD[7], aD[6], aD[5], aD[4]);
	or(oS[0], aD[3], aD[2], aD[1], aD[0]);
	
	and(Y[1], oS[1], S[1]);
	and(Y[0], oS[0], S[0]);
	
endmodule
