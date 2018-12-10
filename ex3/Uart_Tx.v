module Uart_Tx(Uart_CLK, Data_Tx, Wrsig, Idle, Signal_Tx);
	input Uart_CLK;
	input [7:0] Data_Tx;
	input Wrsig;
	output reg Idle;
	output reg Signal_Tx;

	reg Send;
	reg WrsigBuf;
	reg WrsigRise;
	reg Presult;
	reg [7:0] Tx_Cnt;

	parameter paritymode = 1'b0;

	always @(posedge Uart_CLK) begin
		WrsigBuf <= Wrsig;
		WrsigRise <= (~WrsigBuf) & Wrsig;
	end
	
	// Starting uart sending program
	always @(posedge Uart_CLK) begin
		if(WrsigRise && (~Idle))
			Send <= 1'b1;
		else if(Tx_Cnt == 8'd168)
			Send <= 1'b0;
	end
	
	// Send a bit every 16 clocks
	always @(posedge Uart_CLK) begin
		if (Send == 1'b1) begin
			case(Tx_Cnt) 
				8'd0:		begin
								Signal_Tx <= 1'b0;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd16:	begin
								Signal_Tx <= Data_Tx[0];
								Presult <= Data_Tx[0]^paritymode;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd32:	begin
								Signal_Tx <= Data_Tx[1];
								Presult <= Data_Tx[1]^Presult;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd48:	begin
								Signal_Tx <= Data_Tx[2];
								Presult <= Data_Tx[2]^Presult;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd64:	begin
								Signal_Tx <= Data_Tx[3];
								Presult <= Data_Tx[3]^Presult;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd80:	begin 
								Signal_Tx <= Data_Tx[4];
								Presult <= Data_Tx[4]^Presult;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd96:	begin
								Signal_Tx <= Data_Tx[5];
								Presult <= Data_Tx[5]^Presult;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd112:	begin
								Signal_Tx <= Data_Tx[6];
								Presult <= Data_Tx[6]^Presult;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd128:	begin 
								Signal_Tx <= Data_Tx[7];
								Presult <= Data_Tx[7]^Presult;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd144:	begin
								Signal_Tx <= Presult;
								Presult <= Data_Tx[0]^paritymode;
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd160:	begin
								Signal_Tx <= 1'b1;             
								Idle <= 1'b1;
								Tx_Cnt <= Tx_Cnt + 8'd1;
							end
				8'd168:	begin
								Signal_Tx <= 1'b1;
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
