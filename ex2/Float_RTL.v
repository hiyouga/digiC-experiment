module Float_RTL(U, F, P);
	input [3:0] U;
	output [3:0] F;
	output [1:0] P;
	
	wire [3:0] nU;
	wire [7:0] IN_74153_H;
	wire [7:0] IN_74153_L;
	wire [7:0] IN_74148;
	wire [2:0] Y_74148;
	wire Ys, Yex;
	
	assign nU = ~U;
	
	assign IN_74148 = {4'b1111, nU[3:1], 1'b0};
	
	TTL74148_RTL ttl_74148 (
		.nS(1'b0),
		.nIN(IN_74148),
		.Y(Y_74148),
		.Ys(Ys),
		.Yex(Yex)
	);
	
	assign P = ~Y_74148;
	
	assign IN_74153_H = {U[2:0], 1'b0, U[3:0]};
	assign IN_74153_L = {U[0], 3'b0, U[1:0], 2'b0};
	
	TTL74153_RTL ttl_74153_H (
		.nS(2'b0),
		.IN(IN_74153_H),
		.A(P),
		.Y({F[2], F[3]})
	);
	
	TTL74153_RTL ttl_74153_L (
		.nS(2'b0),
		.IN(IN_74153_L),
		.A(P),
		.Y({F[0], F[1]})
	);
	
	
endmodule
