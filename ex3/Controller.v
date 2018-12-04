module Controller(Sys_CLK, Sys_RST, Key_In, Mode, Light, Number, State);
	input Sys_CLK;
	input Sys_RST;
	input Key_In;
	input Mode;
	output reg [1:0] Light;
	output reg [7:0] Number;
	output reg [2:0] State;
	
	parameter unit_interval = 5000000; // 100ms
	parameter normal_interval = 50000000; // 1s
	parameter slow_interval = 500000000; // 10s
	
	reg [31:0] interval;
	reg [31:0] cnt;
	reg [31:0] Counter;
	
	// State Encoding
	parameter White_Off	= 3'b000;
	parameter White_On	= 3'b001;
	parameter Sun_Off		= 3'b010;
	parameter Sun_On		= 3'b011;
	parameter Yellow_Off	= 3'b100;
	parameter Yellow_On	= 3'b101;
	
	always @(posedge Sys_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			cnt <= 0;
			Number <= 8'b0;
		end
		else begin
			if (Counter == 32'b0) begin
				cnt <= 0;
				Number <= 8'b0;
			end
			else begin
				if (cnt == unit_interval) begin
					if (Number[3:0] == 4'd9) begin
						if (Number[7:4] == 4'd9) begin
							Number <= 8'd0;
						end
						else begin
							Number[7:4] <= Number[7:4] + 1;
							Number[3:0] <= 4'd0;
						end
					end
					else
						Number[3:0] <= Number[3:0] + 1;
					cnt <= 0;
				end
				else
					cnt <= cnt + 1;
			end
		end
	end
	
	always @(Mode) begin
		if (Mode == 1'b0)
			interval <= normal_interval;
		else
			interval <= slow_interval;
	end
	
	always @(posedge Sys_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			State <= White_Off;
			Counter <= 32'b0;
			Light <= 2'b00;
		end
		else begin
			case (State)
				White_Off:	begin
									Light <= 2'b00;
									if (Key_In) begin
										State <= White_On;
										Counter <= 32'b0;
									end
									else
										State <= White_Off;
								end
				White_On:	begin
									Light <= 2'b01;
									if (Key_In)
										State <= Sun_Off;
									else
										State <= White_On;
								end
				Sun_Off:		begin
									Light <= 2'b00;
									if (Key_In) begin
										State <= Sun_On;
										Counter <= 32'b0;
									end
									else if (Counter == interval) begin
										State <= White_Off;
									end
									else
										Counter <= Counter + 1;
								end
				Sun_On:		begin
									Light <= 2'b10;
									if (Key_In)
										State <= Yellow_Off;
									else
										State <= Sun_On;
								end
				Yellow_Off:	begin
									Light <= 2'b00;
									if (Key_In) begin
										State <= Yellow_On;
										Counter <= 32'b0;
									end
									else if (Counter == interval) begin
										State <= White_Off;
									end
									else
										Counter <= Counter + 1;
								end
				Yellow_On:	begin
									Light <= 2'b11;
									if (Key_In)
										State <= White_Off;
									else
										State <= Yellow_On;
								end
				default:		begin
									Light <= 2'b00;
									State <= White_Off;
								end
			endcase
		end
	end
	
endmodule
