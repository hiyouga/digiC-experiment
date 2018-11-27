module Float_8bit(U, F, P);
	input [7:0] U;
	output reg [7:0] F;
	output reg [2:0] P;

	always @(*) begin
		casex (U)
			8'b1???????: begin P <= 3'b111; F <= U; end
			8'b01??????: begin P <= 3'b110; F <= U << 1; end
			8'b001?????: begin P <= 3'b101; F <= U << 2; end
			8'b0001????: begin P <= 3'b100; F <= U << 3; end
			8'b00001???: begin P <= 3'b011; F <= U << 4; end
			8'b000001??: begin P <= 3'b010; F <= U << 5; end
			8'b0000001?: begin P <= 3'b001; F <= U << 6; end
			8'b0000000?: begin P <= 3'b000; F <= U << 7; end
		endcase
	end
	
endmodule
