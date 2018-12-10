module Uart_Rx(Uart_CLK, Uart_RST, Signal_Rx, Data_Rx, Rdsig, DataError_Flag, FrameError_Flag);
	input Uart_CLK;
	input Uart_RST;
	input Signal_Rx;
	output reg [7:0] Data_Rx;
	output reg Rdsig;
	output reg DataError_Flag;
	output reg FrameError_Flag;

	reg [7:0] cnt;

	reg RxBuf;
	reg RxFall;
	reg Recieve;

	reg Presult;
	reg Idle;

	parameter paritymode = 1'b0;

	always @(posedge Uart_CLK) begin
		RxBuf <= Signal_Rx;
		RxFall <= RxBuf & (~Signal_Rx);
	end

	// Starting uart receiving program
	always @(posedge Uart_CLK) begin
		if (RxFall && (~Idle))
			Recieve <= 1'b1;
		else if(cnt == 8'd168)
			Recieve <= 1'b0;
	end

	// Receive a bit every 16 clocks
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
				8'd0:		begin
								Idle <= 1'b1;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd24:	begin
								Idle <= 1'b1;
								Data_Rx[0] <= Signal_Rx;
								Presult <= paritymode^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd40:	begin
								Idle <= 1'b1;
								Data_Rx[1] <= Signal_Rx;
								Presult <= Presult^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd56:	begin
								Idle <= 1'b1;
								Data_Rx[2] <= Signal_Rx;
								Presult <= Presult^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd72:	begin
								Idle <= 1'b1;
								Data_Rx[3] <= Signal_Rx;
								Presult <= Presult^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd88:	begin
								Idle <= 1'b1;
								Data_Rx[4] <= Signal_Rx;
								Presult <= Presult^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd104:	begin
								Idle <= 1'b1;
								Data_Rx[5] <= Signal_Rx;
								Presult <= Presult^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd120:	begin
								Idle <= 1'b1;
								Data_Rx[6] <= Signal_Rx;
								Presult <= Presult^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd136:	begin
								Idle <= 1'b1;
								Data_Rx[7] <= Signal_Rx;
								Presult <= Presult^Signal_Rx;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd152:	begin
								Idle <= 1'b1;
								if(Presult == Signal_Rx)
									DataError_Flag <= 1'b0;
								else
									DataError_Flag <= 1'b1;
								cnt <= cnt + 8'd1;
								Rdsig <= 1'b0;
							end
				8'd168:	begin
								Idle <= 1'b1;
								if(1'b1 == Signal_Rx)
									FrameError_Flag <= 1'b0;
								else
									FrameError_Flag <= 1'b1;
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
