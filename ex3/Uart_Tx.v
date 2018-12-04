module Uart_Tx(Uart_CLK, Data_Tx, Wrsig, Idle, Signal_Tx);

input Uart_CLK; // ����ʱ��
input [7:0] Data_Tx; // �����ź�
input Wrsig; // ����ʹ��
output reg Idle; // ����
output reg Signal_Tx; // �����ź�

reg Send; // ����
reg WrsigBuf;
reg WrsigRise; // ��������
reg Presult; // У��λ
reg [7:0] Tx_Cnt; // ����λ��

parameter paritymode = 1'b0;

always @(posedge Uart_CLK) begin
   WrsigBuf <= Wrsig;
   WrsigRise <= (~WrsigBuf) & Wrsig;
end

////////////////////////////////////////////////////////////////
// �������ڷ��ͳ���
////////////////////////////////////////////////////////////////

always @(posedge Uart_CLK) begin
	if(WrsigRise && (~Idle)) // ������������Ч����·Ϊ����ʱ�������µ����ݷ��ͽ���
		Send <= 1'b1;
	else if(Tx_Cnt == 8'd168) // һ֡���Ϸ��ͽ���
		Send <= 1'b0;
end

////////////////////////////////////////////////////////////////
// ���ڷ��ͳ���, 16��ʱ�ӷ���һ��bit
////////////////////////////////////////////////////////////////

always @(posedge Uart_CLK) begin
	if (Send == 1'b1) begin
		case(Tx_Cnt) 
			8'd0:		begin
							Signal_Tx <= 1'b0; // ������ʼλ
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd16:	begin
							Signal_Tx <= Data_Tx[0]; // ��������0λ
							Presult <= Data_Tx[0]^paritymode;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd32:	begin
							Signal_Tx <= Data_Tx[1]; // ��������1λ
							Presult <= Data_Tx[1]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd48:	begin
							Signal_Tx <= Data_Tx[2]; // ��������2λ
							Presult <= Data_Tx[2]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd64:	begin
							Signal_Tx <= Data_Tx[3]; // ��������3λ
							Presult <= Data_Tx[3]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd80:	begin 
							Signal_Tx <= Data_Tx[4]; // ��������4λ
							Presult <= Data_Tx[4]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd96:	begin
							Signal_Tx <= Data_Tx[5]; // ��������5λ
							Presult <= Data_Tx[5]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd112:	begin
							Signal_Tx <= Data_Tx[6]; // ��������6λ
							Presult <= Data_Tx[6]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd128:	begin 
							Signal_Tx <= Data_Tx[7]; // ��������7λ
							Presult <= Data_Tx[7]^Presult;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd144:	begin
							Signal_Tx <= Presult; // ������żУ��λ
							Presult <= Data_Tx[0]^paritymode;
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd160:	begin
							Signal_Tx <= 1'b1; // ����ֹͣλ             
							Idle <= 1'b1;
							Tx_Cnt <= Tx_Cnt + 8'd1;
						end
			8'd168:	begin
							Signal_Tx <= 1'b1; // һ֡���Ϸ��ͽ���
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
