module Recorder(Sys_CLK, Sys_RST, Recording, Key_In, Length, Light, Index, opList);
	input Sys_CLK;
	input Sys_RST;
	input Recording;
	input Key_In;
	input [4:0] Length;
	input [1:0] Light;
	output reg [4:0] Index;
	output reg [7:0] opList;
	
	parameter max_num = 7'b1111111;
	parameter unit_interval = 500000; // 10ms
	integer cnt;
	reg [6:0] number;
	
	always @(posedge Sys_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			cnt <= 0;
			number <= 7'b0;
		end
		else if (Key_In || !Recording) begin
			cnt <= 0;
			number <= 7'b0;
		end
		else begin
			if (cnt == unit_interval) begin
				if (number < max_num)
					number <= number + 1;
				cnt <= 0;
			end
			else
				cnt <= cnt + 1;
		end
	end
	
	always @(posedge Sys_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			Index <= 5'b0;
			opList <= 8'b0;
		end
		else begin
			if (!Recording)
				Index <= 5'b0;
			if (Key_In) begin
				if (Light == 2'b00) begin
					opList[7] <= 1'b1;
				end
				else begin
					opList[7] <= 1'b0;
				end
				opList[6:0] <= number;
				Index <= Length + 1;
			end
		end
	end
	
endmodule
