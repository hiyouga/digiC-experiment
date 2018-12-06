module Display_num(clk, rst, number, state, com, seg);
	input clk;
	input rst;
	input [7:0] number;
	input [2:0] state;
	output reg [1:0] com;
	output reg [7:0] seg;
	
	parameter update_interval = 50000000 / 200 - 1; // 50Hz
	
	reg sel;
	reg [3:0] dat;
	reg [3:0] encoded_state;
	reg [1:0] dp;
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
	
	always @(state) begin
		case (state)
			3'b000: encoded_state <= 4'b0000;
			3'b001: encoded_state <= 4'b0001;
			3'b010: encoded_state <= 4'b0100;
			3'b011: encoded_state <= 4'b0010;
			3'b100: encoded_state <= 4'b1000;
			3'b101: encoded_state <= 4'b0101;
			default:encoded_state <= 4'b0000;
		endcase
	end
	
	always @(sel, number, encoded_state) begin
		case (sel)
			1'b0: begin dat <= number[7:4]; dp <= encoded_state[3:2]; com <= 2'b01; end
			1'b1: begin dat <= number[3:0]; dp <= encoded_state[1:0]; com <= 2'b10; end
		endcase
	end
	
	always @(dat) begin
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
	
	parameter dp_interval = 5000000; // 100ms
	integer dp_cnt;
	reg dp_state;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			dp_cnt <= 0;
			dp_state <= 0;
		end
		else begin
			dp_cnt <= dp_cnt + 1'd1;
			if (dp_cnt == dp_interval) begin
				dp_cnt <= 0;
				dp_state <= ~dp_state;
			end
		end
	end
	
	always @(dp, dp_state) begin
		case (dp)
			2'b00:	seg[0] <= 1'b0;
			2'b01:	seg[0] <= 1'b1;
			2'b10:	seg[0] <= dp_state;
			default:	seg[0] <= 1'b0;
		endcase
	end
	
endmodule
