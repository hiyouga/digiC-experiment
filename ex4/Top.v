module Top(sys_clk, sys_rst, key, com, seg, led);
	input sys_clk;
	input sys_rst;
	input [1:0] key;
	output [1:0] com;
	output [7:0] seg;
	output [3:0] led;
	
	wire [1:0] key_out;
	wire div_clk;
	wire serial_data;
	wire strobe;
	wire data;
	wire error;
	
	reg prestrobe;
	reg [2:0] State;
	reg Data_Reg [0:15];
	reg [4:0] Data_Cnt;
	reg Print;
	reg [4:0] Print_Cnt;
	integer i;
	integer cnt;
	
	parameter interval = 50000000; // 1s
	
	parameter Ready = 3'b000;
	parameter Decoding = 3'b001;
	parameter Printing = 3'b010;
	parameter Error = 3'b011;
	parameter Waiting = 3'b101;
	
	always @(posedge sys_clk or negedge sys_rst) begin
		if (!sys_rst) begin
			cnt <= 0;
			prestrobe <= 1'b0;
			State <= 3'b0;
			for (i=0; i<16; i=i+1)
				Data_Reg[i] <= 1'b0;
			Data_Cnt <= 5'b0;
			Print <= 1'b0;
			Print_Cnt <= 5'b0;
		end
		else begin
			case (State)
				Ready:	begin
								if (key_out[0])
									State <= Decoding;
							end
				Decoding:begin
								if (strobe != prestrobe) begin
									prestrobe <= strobe;
									if (strobe) begin // posedge
										if (Data_Cnt == 5'd16) begin
											Data_Cnt <= 5'd0;
											if (error)
												State <= Error;
											else
												State <= Waiting;
										end
										else begin
											Data_Reg[Data_Cnt] <= data;
											Data_Cnt <= Data_Cnt + 1;
										end
									end
								end
							end
				Waiting:	begin
								if (key_out[1])
									State <= Printing;
							end
				Printing:begin
								if (cnt == interval) begin
									cnt <= 0;
									if (Print_Cnt == 5'd16) begin
										Print_Cnt <= 5'd0;
										State <= Waiting;
									end
									else begin
										Print <= Data_Reg[Print_Cnt];
										Print_Cnt <= Print_Cnt + 1;
									end
								end
								else
									cnt <= cnt + 1;
							end
			endcase
		end
	end
	
	Serial_Generate serial_generate (
		.clk(sys_clk),
		.enable(~State[1] & State[0]),
		.serial_data(serial_data),
		.div_clk(div_clk),
		.rst(sys_rst)
	);
	
	Sync_capturer sync_capturer (
		.clk(div_clk),
		.in(serial_data),
		.strobe(strobe),
		.data(data),
		.error(error),
		.rst(sys_rst)
	);
	
	Key_debounce key_debounce (
		.clk(sys_clk),
		.rst(sys_rst),
		.key(key),
		.key_pulse(key_out)
	);
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number1(Print_Cnt[3:0]),
		.number2({3'b0, Print}),
		.com(com),
		.seg(seg)
	);
	
	Light_led light_led (
		.Light(State[1:0]),
		.Led(led)
	);
	
endmodule
