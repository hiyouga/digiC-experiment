module Key_debounce(Sys_CLK, Sys_RST, Key_In, Key_Out);

	input Sys_CLK;
	input Sys_RST;
	input [1:0] Key_In;
	output [1:0] Key_Out;

	reg [15:0] Div_Cnt;
	reg Div_CLK;

	reg [11:0] Key_Temp [1:0];

	always @(posedge Sys_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			Div_CLK = 1'd0;
			Div_Cnt = 16'd0;
		end
		else begin
			if(Div_Cnt == 16'd25000) begin
				Div_Cnt = 16'd0;
				Div_CLK = ~Div_CLK;
			end
			else
				Div_Cnt = Div_Cnt + 1'd1;
		end
	end

	always @(posedge Div_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			Key_Temp[0] <= 12'b0;
			Key_Temp[1] <= 12'b0;
		end
		else begin
			Key_Temp[0] <= (Key_Temp[0] << 1) + Key_In[0];
			Key_Temp[1] <= (Key_Temp[1] << 1) + Key_In[1];
		end
	end

	assign Key_Out[0] = &Key_Temp[0];
	assign Key_Out[1] = &Key_Temp[1];

endmodule
