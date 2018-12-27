module ROM(clk, rst, data);
	input clk;
	output reg data;
	input rst;
	
	reg [4:0] index;
	reg [3:0] counter;
	reg [9:0] ROM[0:21];
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			index <= 5'b0;
			counter <= 4'b0;
		end
		else begin
			if (counter == 4'd9) begin
				counter <= 4'd0;
				if (index < 5'd21)
					index <= index + 1;
			end
			else
				counter <= counter + 1;
		end
	end
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			data <= 1'b0;
		end
		else begin
			case (counter)
				4'd0: data <= ROM[index][0];
				4'd1: data <= ROM[index][1];
				4'd2: data <= ROM[index][2];
				4'd3: data <= ROM[index][3];
				4'd4: data <= ROM[index][4];
				4'd5: data <= ROM[index][5];
				4'd6: data <= ROM[index][6];
				4'd7: data <= ROM[index][7];
				4'd8: data <= ROM[index][8];
				4'd9: data <= ROM[index][9];
			endcase
		end
	end
	
endmodule
