module Serial_Generate(clk, serial_data, div_clk, rst);
	input clk;
	output reg serial_data;
	output reg div_clk;
	input rst;
	
	reg ROM [0:219];
	reg [3:0] cnt_a;
	reg [3:0] cnt_b;
	reg [7:0] data_cnt;
	
	initial begin
		$readmemb("rom.patt", ROM);
	end
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			div_clk <= 1'b0;
			serial_data <= 1'b0;
			cnt_a <= 4'b0;
			cnt_b <= 4'b0;
			data_cnt <= 8'b0;
		end
		else begin
			if (cnt_a == 4'd7) begin
				cnt_a <= 4'd0;
				if (data_cnt == 8'd219)
					data_cnt <= 8'd0;
				else
					data_cnt <= data_cnt + 1;
			end
			else
				cnt_a <= cnt_a + 1;
			if (cnt_b == 4'd4) begin
				cnt_b <= 4'd0;
				div_clk <= ~div_clk;
			end
			else
				cnt_b <= cnt_b + 1;
			serial_data <= ROM[data_cnt];
		end
	end
	
endmodule
