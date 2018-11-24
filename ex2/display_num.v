module Display_num(clk, rst, number1, number2, com, seg);
	input clk;
	input rst;
	input [3:0] number1;
	input [3:0] number2;
	output reg [1:0] com;
	output reg [7:0] seg;

	parameter update_interval = 50000000 / 200 - 1; // 50Hz
	
	reg [3:0] dat;
	reg sel = 1'b0;
	integer cnt;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			cnt <= 0;
			sel <= 0;
		end
		else begin
			cnt <= cnt + 1;
			if (cnt == update_interval) begin
				cnt <= 0;
				sel <= ~sel;
			end
		end
	end
	
	always @(*) begin
		case (sel)
			1'b0: begin dat <= number1; com <= 2'b01; end
			1'b1: begin dat <= number2; com <= 2'b10; end
		endcase
	end
	
	always @(dat) begin
		seg[0] <= 1'b0;
		case (dat)
			4'h0: seg[7:1] <= 7'b1111110;
			4'h1: seg[7:1] <= 7'b0110000;
			4'h2: seg[7:1] <= 7'b1101101;
			4'h3: seg[7:1] <= 7'b1111001;
			4'h4: seg[7:1] <= 7'b0110011;
			4'h5: seg[7:1] <= 7'b1011011;
			4'h6: seg[7:1] <= 7'b1011111;
			4'h7: seg[7:1] <= 7'b1110000;
			4'h8: seg[7:1] <= 7'b1111111;
			4'h9: seg[7:1] <= 7'b1111011;
			4'hA: seg[7:1] <= 7'b1110111;
			4'hB: seg[7:1] <= 7'b0011111;
			4'hC: seg[7:1] <= 7'b1001110;
			4'hD: seg[7:1] <= 7'b0111101;
			4'hE: seg[7:1] <= 7'b1001111;
			4'hF: seg[7:1] <= 7'b1000111;
			default: seg[7:1] <= 7'b0000000;
		endcase
	end

endmodule
