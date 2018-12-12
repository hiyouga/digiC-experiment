module Controller(Sys_CLK, Sys_RST, Key_In, Mode, Auto, Auto_enable, Auto_data, Auto_idle, Light, Number, State);
	input Sys_CLK;
	input Sys_RST;
	input Key_In;
	input Mode;
	input Auto;
	input Auto_enable;
	input [6:0] Auto_data;
	output reg Auto_idle;
	output reg [1:0] Light;
	output reg [7:0] Number;
	output reg [2:0] State;
	
	parameter unit_interval = 5000000; // 100ms
	parameter normal_interval = 50000000; // 1s
	parameter slow_interval = 500000000; // 10s
	
	reg Key;
	reg Key_Auto;
	reg [31:0] interval;
	reg [31:0] cnt;
	reg [31:0] Counter;
	integer auto_cnt;
	reg [6:0] auto_num;
	reg running;
	
	// State Encoding
	parameter White_Off	= 3'b000;
	parameter White_On	= 3'b001;
	parameter Sun_Off		= 3'b010;
	parameter Sun_On		= 3'b011;
	parameter Yellow_Off	= 3'b100;
	parameter Yellow_On	= 3'b101;
	
	/* 
	 * Auto signal simulation
	 */
	always @(posedge Sys_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			auto_cnt <= 0;
			auto_num <= 7'b0;
			running <= 1'b0;
			Key_Auto <= 1'b0;
			Auto_idle <= 1'b1;
		end
		else begin
			if (Key_Auto) // Restrict to a cycle
				Key_Auto <= 1'b0;
			if (running) begin
				if (auto_cnt == unit_interval) begin
					auto_cnt <= 0;
					if (auto_num == Auto_data) begin
						Key_Auto <= 1'b1;
						auto_num <= 7'b0;
						running <= 1'b0;
						Auto_idle <= 1'b1;
					end
					else
						auto_num <= auto_num + 1;
				end
				else
					auto_cnt <= auto_cnt + 1;
			end
			else if (Auto_enable) begin
				running <= 1'b1;
				Auto_idle <= 1'b0;
			end
		end
	end
	
	/* 
	 * Key signal source (May cause a time-delay)
	 */
	always @(posedge Sys_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			Key <= 1'b0;
		end
		else begin
			if (Auto)
				Key <= Key_Auto;
			else
				Key <= Key_In;
		end
	end
	
	/* 
	 * Display time for Display_num module
	 */
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
	
	/* 
	 * Change interval by Mode signal
	 */
	always @(Mode) begin
		if (Mode == 1'b0)
			interval <= normal_interval;
		else
			interval <= slow_interval;
	end
	
	/* 
	 * Main Finite State Machine
	 */
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
									if (Key) begin
										State <= White_On;
										Counter <= 32'b0;
									end
									else
										State <= White_Off;
								end
				White_On:	begin
									Light <= 2'b01;
									if (Key)
										State <= Sun_Off;
									else
										State <= White_On;
								end
				Sun_Off:		begin
									Light <= 2'b00;
									if (Key) begin
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
									if (Key)
										State <= Yellow_Off;
									else
										State <= Sun_On;
								end
				Yellow_Off:	begin
									Light <= 2'b00;
									if (Key) begin
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
									if (Key)
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
