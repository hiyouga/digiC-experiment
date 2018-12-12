module Uart_Top(Sys_CLK, Sys_RST, Signal_Tx, Signal_Rx, Data, Length, Receiving, Tx_Sig, Tx_Idle, Recv_index, Recv_data);
	input Sys_CLK;
	input Sys_RST;
	input Signal_Rx;
	output Signal_Tx;
	input [7:0] Data;
	input [4:0] Length;
	input Receiving;
	input Tx_Sig;
	output reg Tx_Idle;
	output reg [4:0] Recv_index;
	output reg [7:0] Recv_data;
	
	///////// For Uart Essential begin
	wire Uart_CLK;
	reg [7:0] Data_Tx;
	wire [7:0] Data_Rx;
	reg Wrsig;
	wire Rdsig;
	wire Idle;
	wire Rx_DataError_Flag;
	wire Rx_FrameError_Flag;
	reg Error_Flag;
	reg [2:0] State;
	reg [7:0] cnt;
	///////// End
	reg [7:0] Print[0:8]; // Print string t.tts:on/of\r
	reg [7:0] Recv_Reg;
	reg [3:0] Print_Cnt;
	reg [3:0] Recv_Cnt;
	
	// State Encodings
	parameter Wait_Rdsig = 3'b000;
	parameter Check_Data = 3'b001;
	parameter Save_Data = 3'b010;
	parameter Trans_Data = 3'b011;
	parameter State_Delay = 3'b100;
	
	always @(posedge Uart_CLK or negedge Sys_RST) begin
		if (!Sys_RST) begin
			Wrsig <= 1'b0;
			State <= 3'b0;
			cnt <= 8'b0;
			Tx_Idle <= 1'b1;
			Data_Tx <= 8'b0;
			Print_Cnt <= 4'b0;
			Recv_Reg <= 8'b0;
			Recv_Cnt <= 4'b0;
			Recv_index <= 5'b0;
			Recv_data <= 8'b0;
		end
		else begin
			if (!Receiving)
				Recv_index <= 5'b0;
			case(State)
				Wait_Rdsig:	begin
									if (Tx_Sig) begin
										Tx_Idle <= 1'b0;
										State <= Trans_Data;
									end
									else begin
										Tx_Idle <= 1'b1;
										if (Recv_Cnt == 4'd8) begin
											Recv_Cnt <= 4'd0;
											Recv_index <= Length + 1;
											Recv_data <= Recv_Reg;
										end
										if (!Rdsig)
											State <= Wait_Rdsig;
										else
											State <= Check_Data;
									end
								end
				Check_Data:	begin
									if (Rdsig)
										State <= Check_Data;
									else begin
										Error_Flag <= Rx_DataError_Flag || Rx_FrameError_Flag;
										State <= Save_Data;
									end
								end
				Save_Data:	begin
									if (!Error_Flag) begin
										case (Data_Rx)
											8'd48: Recv_Reg[7-Recv_Cnt] <= 1'b0;
											8'd49: Recv_Reg[7-Recv_Cnt] <= 1'b1;
										endcase
										Recv_Cnt <= Recv_Cnt + 1;
										State <= Wait_Rdsig;
									end
									else
										State <= Trans_Data;
								end
				Trans_Data:	begin
									if (Print_Cnt == 4'd9) begin
										Print_Cnt <= 4'd0;
										State <= State_Delay;
									end
									else begin
										if (cnt == 254) begin
											Data_Tx <= Print[Print_Cnt];
											Wrsig <= 1'b1;
											cnt <= 8'd0;
											Print_Cnt <= Print_Cnt + 1;
										end
										else begin
											Wrsig <= 1'b0;
											cnt <= cnt + 8'd1;
										end
									end
								end
				State_Delay:begin
									if (cnt == 254) begin
										cnt <= 8'd0;
										State <= Wait_Rdsig;
									end
									else begin
										Wrsig <= 1'b0;
										cnt <= cnt + 8'd1;
									end
								end
				default:		begin
									Wrsig <= 1'b0;
									cnt <= 8'd0;
									State <= 2'b0;
								end
			endcase
		end
	end
	
	always @(Data) begin
		Print[1] <= 8'd46;
		Print[4] <= 8'd115;
		Print[5] <= 8'd58;
		if (Data[7]) begin
			Print[6] <= 8'd79;
			Print[7] <= 8'd110;
		end
		else begin
			Print[6] <= 8'd79;
			Print[7] <= 8'd102;
		end
		Print[8] <= 8'd13;
		case (Data[6:0])
			7'b0: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd48; end // 0
			7'b1: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd49; end // 1
			7'b10: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd50; end // 2
			7'b11: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd51; end // 3
			7'b100: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd52; end // 4
			7'b101: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd53; end // 5
			7'b110: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd54; end // 6
			7'b111: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd55; end // 7
			7'b1000: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd56; end // 8
			7'b1001: begin Print[0] <= 8'd48; Print[2] <= 8'd48; Print[3] <= 8'd57; end // 9
			7'b1010: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd48; end // 10
			7'b1011: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd49; end // 11
			7'b1100: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd50; end // 12
			7'b1101: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd51; end // 13
			7'b1110: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd52; end // 14
			7'b1111: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd53; end // 15
			7'b10000: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd54; end // 16
			7'b10001: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd55; end // 17
			7'b10010: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd56; end // 18
			7'b10011: begin Print[0] <= 8'd48; Print[2] <= 8'd49; Print[3] <= 8'd57; end // 19
			7'b10100: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd48; end // 20
			7'b10101: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd49; end // 21
			7'b10110: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd50; end // 22
			7'b10111: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd51; end // 23
			7'b11000: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd52; end // 24
			7'b11001: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd53; end // 25
			7'b11010: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd54; end // 26
			7'b11011: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd55; end // 27
			7'b11100: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd56; end // 28
			7'b11101: begin Print[0] <= 8'd48; Print[2] <= 8'd50; Print[3] <= 8'd57; end // 29
			7'b11110: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd48; end // 30
			7'b11111: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd49; end // 31
			7'b100000: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd50; end // 32
			7'b100001: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd51; end // 33
			7'b100010: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd52; end // 34
			7'b100011: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd53; end // 35
			7'b100100: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd54; end // 36
			7'b100101: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd55; end // 37
			7'b100110: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd56; end // 38
			7'b100111: begin Print[0] <= 8'd48; Print[2] <= 8'd51; Print[3] <= 8'd57; end // 39
			7'b101000: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd48; end // 40
			7'b101001: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd49; end // 41
			7'b101010: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd50; end // 42
			7'b101011: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd51; end // 43
			7'b101100: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd52; end // 44
			7'b101101: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd53; end // 45
			7'b101110: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd54; end // 46
			7'b101111: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd55; end // 47
			7'b110000: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd56; end // 48
			7'b110001: begin Print[0] <= 8'd48; Print[2] <= 8'd52; Print[3] <= 8'd57; end // 49
			7'b110010: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd48; end // 50
			7'b110011: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd49; end // 51
			7'b110100: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd50; end // 52
			7'b110101: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd51; end // 53
			7'b110110: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd52; end // 54
			7'b110111: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd53; end // 55
			7'b111000: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd54; end // 56
			7'b111001: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd55; end // 57
			7'b111010: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd56; end // 58
			7'b111011: begin Print[0] <= 8'd48; Print[2] <= 8'd53; Print[3] <= 8'd57; end // 59
			7'b111100: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd48; end // 60
			7'b111101: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd49; end // 61
			7'b111110: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd50; end // 62
			7'b111111: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd51; end // 63
			7'b1000000: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd52; end // 64
			7'b1000001: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd53; end // 65
			7'b1000010: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd54; end // 66
			7'b1000011: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd55; end // 67
			7'b1000100: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd56; end // 68
			7'b1000101: begin Print[0] <= 8'd48; Print[2] <= 8'd54; Print[3] <= 8'd57; end // 69
			7'b1000110: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd48; end // 70
			7'b1000111: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd49; end // 71
			7'b1001000: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd50; end // 72
			7'b1001001: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd51; end // 73
			7'b1001010: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd52; end // 74
			7'b1001011: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd53; end // 75
			7'b1001100: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd54; end // 76
			7'b1001101: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd55; end // 77
			7'b1001110: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd56; end // 78
			7'b1001111: begin Print[0] <= 8'd48; Print[2] <= 8'd55; Print[3] <= 8'd57; end // 79
			7'b1010000: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd48; end // 80
			7'b1010001: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd49; end // 81
			7'b1010010: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd50; end // 82
			7'b1010011: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd51; end // 83
			7'b1010100: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd52; end // 84
			7'b1010101: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd53; end // 85
			7'b1010110: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd54; end // 86
			7'b1010111: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd55; end // 87
			7'b1011000: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd56; end // 88
			7'b1011001: begin Print[0] <= 8'd48; Print[2] <= 8'd56; Print[3] <= 8'd57; end // 89
			7'b1011010: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd48; end // 90
			7'b1011011: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd49; end // 91
			7'b1011100: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd50; end // 92
			7'b1011101: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd51; end // 93
			7'b1011110: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd52; end // 94
			7'b1011111: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd53; end // 95
			7'b1100000: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd54; end // 96
			7'b1100001: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd55; end // 97
			7'b1100010: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd56; end // 98
			7'b1100011: begin Print[0] <= 8'd48; Print[2] <= 8'd57; Print[3] <= 8'd57; end // 99
			7'b1100100: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd48; end // 100
			7'b1100101: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd49; end // 101
			7'b1100110: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd50; end // 102
			7'b1100111: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd51; end // 103
			7'b1101000: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd52; end // 104
			7'b1101001: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd53; end // 105
			7'b1101010: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd54; end // 106
			7'b1101011: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd55; end // 107
			7'b1101100: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd56; end // 108
			7'b1101101: begin Print[0] <= 8'd49; Print[2] <= 8'd48; Print[3] <= 8'd57; end // 109
			7'b1101110: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd48; end // 110
			7'b1101111: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd49; end // 111
			7'b1110000: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd50; end // 112
			7'b1110001: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd51; end // 113
			7'b1110010: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd52; end // 114
			7'b1110011: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd53; end // 115
			7'b1110100: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd54; end // 116
			7'b1110101: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd55; end // 117
			7'b1110110: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd56; end // 118
			7'b1110111: begin Print[0] <= 8'd49; Print[2] <= 8'd49; Print[3] <= 8'd57; end // 119
			7'b1111000: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd48; end // 120
			7'b1111001: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd49; end // 121
			7'b1111010: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd50; end // 122
			7'b1111011: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd51; end // 123
			7'b1111100: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd52; end // 124
			7'b1111101: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd53; end // 125
			7'b1111110: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd54; end // 126
			7'b1111111: begin Print[0] <= 8'd49; Print[2] <= 8'd50; Print[3] <= 8'd55; end // 127
		endcase
	end
	
	Uart_ClkDiv uart_clkdiv(.Sys_CLK(Sys_CLK), .Sys_RST(Sys_RST), .Uart_CLK(Uart_CLK));
	Uart_Tx uart_tx(.Uart_CLK(Uart_CLK), .Data_Tx(Data_Tx), .Wrsig(Wrsig), .Idle(Idle), .Signal_Tx(Signal_Tx));
	Uart_Rx uart_rx(.Uart_CLK(Uart_CLK), .Uart_RST(Sys_RST), .Signal_Rx(Signal_Rx), .Data_Rx(Data_Rx), .Rdsig(Rdsig), .DataError_Flag(Rx_DataError_Flag), .FrameError_Flag(Rx_FrameError_Flag));
	
endmodule
