module Uart_Tx(Uart_CLK, Data_Tx, Wrsig, Idle, Signal_Tx);

input Uart_CLK; // 采样时钟
input [7:0] Data_Tx; // 发送信号
input Wrsig; // 发送使能
output reg Idle; // 空闲
output reg Signal_Tx; // 发送信号

reg Send; // 发送
reg WrsigBuf;
reg WrsigRise; // 发送命令
reg Presult; // 校验位
reg [7:0] Tx_Cnt; // 传输位数

parameter paritymode = 1'b0;

always @(posedge Uart_CLK) begin
   WrsigBuf <= Wrsig;
   WrsigRise <= (~WrsigBuf) & Wrsig;
end

////////////////////////////////////////////////////////////////
// 启动串口发送程序
////////////////////////////////////////////////////////////////

always @(posedge Uart_CLK) begin
	if(WrsigRise && (~Idle)) // 当发送命令有效且线路为空闲时，启动新的数据发送进程
		Send <= 1'b1;
	else if(Tx_Cnt == 8'd168) // 一帧资料发送结束
		Send <= 1'b0;
end

////////////////////////////////////////////////////////////////
// 串口发送程序, 16个时钟发送一个bit
////////////////////////////////////////////////////////////////

always @(posedge Uart_CLK) begin
	if (Send == 1'b1) begin
		case(Tx_Cnt) 
			8'd0:		begin
							Signal_Tx <= 1'b0; // 产生起始位
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd16:	begin
							Signal_Tx <= Data_Tx[0]; // 发送数据0位
							Presult <= Data_Tx[0]^paritymode;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd32:	begin
							Signal_Tx <= Data_Tx[1]; // 发送数据1位
							Presult <= Data_Tx[1]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd48:	begin
							Signal_Tx <= Data_Tx[2]; // 发送数据2位
							Presult <= Data_Tx[2]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd64:	begin
							Signal_Tx <= Data_Tx[3]; // 发送数据3位
							Presult <= Data_Tx[3]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd80:	begin 
							Signal_Tx <= Data_Tx[4]; // 发送数据4位
							Presult <= Data_Tx[4]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd96:	begin
							Signal_Tx <= Data_Tx[5]; // 发送数据5位
							Presult <= Data_Tx[5]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd112:	begin
							Signal_Tx <= Data_Tx[6]; // 发送数据6位
							Presult <= Data_Tx[6]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd128:	begin 
							Signal_Tx <= Data_Tx[7]; // 发送数据7位
							Presult <= Data_Tx[7]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd144:	begin
							Signal_Tx <= Presult; // 发送奇偶校验位
							Presult <= Data_Tx[0]^paritymode;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd160:	begin
							Signal_Tx <= 1'b1; // 发送停止位             
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd168:	begin
							Signal_Tx <= 1'b1; // 一帧资料发送结束
							Idle <= 1'b0;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			default:
						Tx_Cnt <= Tx_Cnt + 8'd1;
		endcase
	end
	else begin
		Signal_Tx <= 1'b1;
		Tx_Cnt <= 8'd0;
		Idle <= 1'b0;
	end
end

endmodule
