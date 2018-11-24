module TTL74148_RTL(nS, nIN, Y, Ys, Yex);
	input nS;
	input [7:0] nIN;
	output reg [2:0] Y;
	output reg Ys;
	output reg Yex;
	
	always @(nS, nIN) begin
		if (nS) begin Y<=3'b111;Yex<=1'b1;Ys<=1'b1; end
		else if (nIN == 8'b11111111) begin Y<=3'b111;Yex<=1'b1;Ys<=1'b0; end
		else if (!nIN[7]) begin Y<=3'b000;Yex<=1'b0;Ys<=1'b1; end
		else if (!nIN[6]) begin Y<=3'b001;Yex<=1'b0;Ys<=1'b1; end
		else if (!nIN[5]) begin Y<=3'b010;Yex<=1'b0;Ys<=1'b1; end
		else if (!nIN[4]) begin Y<=3'b011;Yex<=1'b0;Ys<=1'b1; end
		else if (!nIN[3]) begin Y<=3'b100;Yex<=1'b0;Ys<=1'b1; end
		else if (!nIN[2]) begin Y<=3'b101;Yex<=1'b0;Ys<=1'b1; end
		else if (!nIN[1]) begin Y<=3'b110;Yex<=1'b0;Ys<=1'b1; end
		else begin Y<=3'b111;Yex<=1'b0;Ys<=1'b1; end
	end
	
endmodule
