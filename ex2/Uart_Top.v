﻿module Uart_Top(Sys_CLK, Sys_RST, Signal_Tx, Signal_Rx, Num, F, P);

input Sys_CLK;
input Sys_RST;
input Signal_Rx;
input [3:0] F;
input [3:0] P;
output Signal_Tx;
output [3:0] Num;

wire Uart_CLK; // 时钟分频
reg [7:0] Data_Tx; // 传送数据
wire [7:0] Data_Rx; // 接收数据
reg Wrsig; // 写使能
wire Rdsig; // 读使能
wire Rx_DataError_Flag; // 数据异常
wire Rx_FrameError_Flag; // 帧异常
reg Error_Flag; // 异常信号
reg [2:0] State; // 状态寄存器
reg [7:0] cnt; // 发送采样信号
reg [7:0] Data_Reg[0:3]; // 数据寄存器
reg [3:0] Data_Cnt; // 数据下标
wire [7:0] Print_Reg[0:6]; // 输出字符串
reg [3:0] Print_Cnt; // 输出下标
reg [7:0] Error_Char[0:3]; // 异常字符串
reg [3:0] Char_Cnt; // 字符串下标
wire Idle; // Tx空闲信号

// 状态机编码
parameter Wait_Rdsig = 3'b000;
parameter Check_Data = 3'b001;
parameter Save_Data = 3'b010;
parameter Trans_Data = 3'b011;
parameter State_Delay = 3'b100;

assign Print_Reg[1] = 8'd46;	// .
assign Print_Reg[5] = 8'd69;	// E

always @(posedge Uart_CLK or negedge Sys_RST) begin
	if (!Sys_RST) begin
		Wrsig = 1'b0;
		cnt = 1'b0;
		State = 2'b0;
		Char_Cnt = 3'b0;
		Data_Cnt = 3'b0;
		Print_Cnt = 3'b0;
		Data_Tx = 8'b0;
		cnt = 8'b0;
		Data_Reg[0] = 8'd45;		// -
		Data_Reg[1] = 8'd45;
		Data_Reg[2] = 8'd45;
		Data_Reg[3] = 8'd45;
		Error_Char[0] = 8'd69;	// E
		Error_Char[1] = 8'd114;	// r
		Error_Char[2] = 8'd114;	// r
		Error_Char[3] = 8'd33;	// !
	end
	else begin
		case(State)
			Wait_Rdsig:	begin // 等待接收信号
								if (!Rdsig)
									State = Wait_Rdsig;
								else
									State = Check_Data;
							end
			Check_Data:	begin // 检查是否有错误 
								if (Rdsig)
									State = Check_Data;
								else begin
									Error_Flag = Rx_DataError_Flag || Rx_FrameError_Flag;
									State = Save_Data;
								end
							end
			Save_Data:	begin // 储存数据
								if (!Error_Flag) begin
									if (Data_Cnt == 4'd4) begin // 接收完毕
										Data_Cnt = 4'd0;
										State = Trans_Data;
									end
									else begin
										State = Wait_Rdsig;
										Data_Reg[Data_Cnt] = Data_Rx;
										Data_Cnt = Data_Cnt + 1'b1;
									end
								end
								else
									State = Trans_Data;
							end
			Trans_Data:	begin // 传输数据
								if (!Error_Flag) begin
									if (Print_Cnt == 3'd7) begin // 输出完毕
										Print_Cnt = 3'd0;
										State = State_Delay;
									end
									else begin
										State = Trans_Data;
										if (cnt == 254) begin // 进一步分频
											Data_Tx = Print_Reg[Print_Cnt];
											Wrsig = 1'b1;
											cnt = 8'd0;
											Print_Cnt = Print_Cnt + 1'b1;
										end
										else begin
											Wrsig = 1'b0;
											cnt = cnt + 8'd1;
										end
									end
								end
								else begin
									if (Char_Cnt == 4'd4) begin // 输出完毕
										Char_Cnt = 4'd0;
										State = State_Delay;
									end
									else begin
										State = Trans_Data;
										if (cnt == 254) begin // 进一步分频
											Data_Tx = Error_Char[Char_Cnt];
											Wrsig = 1'b1;
											cnt = 8'd0;
											Char_Cnt = Char_Cnt + 1'b1;
										end
										else begin
											Wrsig = 1'b0;
											cnt = cnt + 8'd1;
										end
									end
								end
							end
			State_Delay:begin // 等待延迟
								if (cnt == 254) begin // 输出回车
									Data_Tx = 8'd13;
									Wrsig = 1'b1;
									cnt = 8'd0;
									State = Wait_Rdsig;
								end
								else begin
									Wrsig = 1'b0;
									cnt = cnt + 8'd1;
								end
							end
			default:		begin // 复位
								Wrsig = 1'b0;
								cnt = 8'd0;
								State = 2'b0;
								Char_Cnt = 3'b0;
								Data_Cnt = 3'b0;
								Print_Cnt = 3'b0;
								Data_Reg[0] = 8'd45;
								Data_Reg[1] = 8'd45;
								Data_Reg[2] = 8'd45;
								Data_Reg[3] = 8'd45;
							end
		endcase
	end
end

Uart_ClkDiv uart_clkdiv(.Sys_CLK(Sys_CLK), .Sys_RST(Sys_RST), .Uart_CLK(Uart_CLK));
Uart_Tx uart_tx(.Uart_CLK(Uart_CLK), .Data_Tx(Data_Tx), .Wrsig(Wrsig), .Idle(Idle), .Signal_Tx(Signal_Tx));
Uart_Rx uart_rx(.Uart_CLK(Uart_CLK), .Uart_RST(Sys_RST), .Signal_Rx(Signal_Rx), .Data_Rx(Data_Rx), .Rdsig(Rdsig), .DataError_Flag(Rx_DataError_Flag), .FrameError_Flag(Rx_FrameError_Flag));
Chr2Bin convert0(Data_Reg[0], Num[3]);
Chr2Bin convert1(Data_Reg[1], Num[2]);
Chr2Bin convert2(Data_Reg[2], Num[1]);
Chr2Bin convert3(Data_Reg[3], Num[0]);
Bin2Chr convert4({3'b0, F[3]}, Print_Reg[0]);
Bin2Chr convert5({3'b0, F[2]}, Print_Reg[2]);
Bin2Chr convert6({3'b0, F[1]}, Print_Reg[3]);
Bin2Chr convert7({3'b0, F[0]}, Print_Reg[4]);
Bin2Chr convert8(P, Print_Reg[6]);

endmodule
