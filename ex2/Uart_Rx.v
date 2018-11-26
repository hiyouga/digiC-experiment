module Uart_Rx(Uart_CLK, Uart_RST, Signal_Rx, Data_Rx, Rdsig, DataError_Flag, FrameError_Flag);

input Uart_CLK; // 采样时钟
input Uart_RST; // 复位信号
input Signal_Rx; // UART数据输入
output reg [7:0] Data_Rx; // 接收数据输出
output reg Rdsig;
output reg DataError_Flag; // 数据出错指示
output reg FrameError_Flag; // 帧出错指示

reg [7:0] cnt;

reg RxBuf;
reg RxFall;
reg Recieve;

reg Presult; // 校验信号
reg Idle; // 空闲信号

parameter paritymode = 1'b0;

always @(posedge Uart_CLK) begin // 检测线路的下降沿
	RxBuf <= Signal_Rx;
	RxFall <= RxBuf & (~Signal_Rx);
end

////////////////////////////////////////////////////////////////
// 启动串口接收程序
////////////////////////////////////////////////////////////////

always @(posedge Uart_CLK) begin
	if (RxFall && (~Idle)) // 检测到线路的下降沿并且原先线路为空闲，启动接收数据进程  
		Recieve <= 1'b1;
	else if(cnt == 8'd168) // 接收数据完成
		Recieve <= 1'b0;
end

////////////////////////////////////////////////////////////////
// 串口接收程序, 16个时钟接收一个bit
////////////////////////////////////////////////////////////////

always @(posedge Uart_CLK or negedge Uart_RST) begin
	if (!Uart_RST) begin
		Idle <= 1'b0;
		cnt <= 8'd0;
		Rdsig <= 1'b0;	 
		FrameError_Flag <= 1'b0; 
		DataError_Flag <= 1'b0;	  
		Presult <= 1'b0;
	end
	else if(Recieve == 1'b1) begin
		case(cnt)
			8'd0:		begin // 准备开始接收
							Idle <= 1'b1;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd24:	begin // 接收第0位数据
							Idle <= 1'b1;
							Data_Rx[0] <= Signal_Rx;
							Presult <= paritymode^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd40:	begin // 接收第1位数据  
							Idle <= 1'b1;
							Data_Rx[1] <= Signal_Rx;
							Presult <= Presult^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd56:	begin // 接收第2位数据   
							Idle <= 1'b1;
							Data_Rx[2] <= Signal_Rx;
							Presult <= Presult^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd72:	begin // 接收第3位数据   
							Idle <= 1'b1;
							Data_Rx[3] <= Signal_Rx;
							Presult <= Presult^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd88:	begin // 接收第4位数据    
							Idle <= 1'b1;
							Data_Rx[4] <= Signal_Rx;
							Presult <= Presult^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd104:	begin // 接收第5位数据    
							Idle <= 1'b1;
							Data_Rx[5] <= Signal_Rx;
							Presult <= Presult^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd120:	begin // 接收第6位数据    
							Idle <= 1'b1;
							Data_Rx[6] <= Signal_Rx;
							Presult <= Presult^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd136:	begin // 接收第7位数据   
							Idle <= 1'b1;
							Data_Rx[7] <= Signal_Rx;
							Presult <= Presult^Signal_Rx;
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd152:	begin // 接收奇偶校验位    
							Idle <= 1'b1;
							if(Presult == Signal_Rx)
								DataError_Flag <= 1'b0;
							else
								DataError_Flag <= 1'b1; // 如果奇偶校验位不对，表示数据出错
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b0;
						end
			8'd168:	begin // 接收停止位
							Idle <= 1'b1;
							if(1'b1 == Signal_Rx)
								FrameError_Flag <= 1'b0;
							else
								FrameError_Flag <= 1'b1; // 如果没有接收到停止位，表示帧出错
							cnt <= cnt + 8'd1;
							Rdsig <= 1'b1;
						end
			default:
						cnt <= cnt + 8'd1;
		endcase
	end
	else begin
		cnt <= 8'd0;
		Idle <= 1'b0;
		Rdsig <= 1'b0;	 
	end
end

endmodule
