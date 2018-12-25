module MAN_decoder_RTL(clk, in, strobe, data, rst);
	input clk;
	input in;
	output reg strobe;
	output reg data;
	input rst;
	
	reg old_in;
	reg [2:0] counter;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			old_in <= 1'b1;
			counter <= 3'b0;
			data <= 1'b0;
			strobe <= 1'b0;
		end
		else begin
			if (strobe)
				strobe <= 1'b0;
			if (in != old_in) begin
				old_in <= in;
				if (counter == 3'd0) begin
					strobe <= 1'b1;
					data <= ~in;
					counter <= counter + 1;
				end
			end
			else begin
				if (counter == 3'd0 || counter == 3'd5)
					counter <= 3'd0;
				else
					counter <= counter + 1;
			end
		end
	end
	
endmodule
