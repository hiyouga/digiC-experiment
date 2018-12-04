module Uart_Top(Sys_CLK, Sys_RST, Signal_Tx, Signal_Rx);

input Sys_CLK;
input Sys_RST;
input Signal_Rx;
output Signal_Tx;

wire Uart_CLK; // ʱ�ӷ�Ƶ
reg [7:0] Data_Tx; // ��������
wire [7:0] Data_Rx; // ��������
reg Wrsig; // дʹ��
wire Rdsig; // ��ʹ��
wire Rx_DataError_Flag; // �����쳣
wire Rx_FrameError_Flag; // ֡�쳣
reg Error_Flag; // �쳣�ź�
reg [2:0] State; // ״̬�Ĵ���
reg [7:0] cnt; // ���Ͳ����ź�
reg [7:0] Data_Reg[0:7]; // ���ݼĴ���
reg [3:0] Data_Cnt; // �����±�
wire [7:0] Print_Reg[0:10]; // ����ַ���
reg [3:0] Print_Cnt; // ����±�
reg [7:0] Error_Char[0:3]; // �쳣�ַ���
reg [3:0] Char_Cnt; // �ַ����±�
wire Idle; // Tx�����ź�

// ״̬������
parameter Wait_Rdsig = 3'b000;
parameter Check_Data = 3'b001;
parameter Save_Data = 3'b010;
parameter Trans_Data = 3'b011;
parameter State_Delay = 3'b100;

assign Print_Reg[1] = 8'd46;	// .
assign Print_Reg[9] = 8'd69;	// E

// for-loop
integer i;
genvar j;

always @(posedge Uart_CLK or negedge Sys_RST) begin
	if (!Sys_RST) begin
		Wrsig = 1'b0;
		cnt = 1'b0;
		State = 3'b0;
		Char_Cnt = 4'b0;
		Data_Cnt = 4'b0;
		Print_Cnt = 4'b0;
		Data_Tx = 8'b0;
		cnt = 8'b0;
		for (i=0; i<8; i=i+1)
			Data_Reg[i] = 8'd48;
		Error_Char[0] = 8'd69;	// E
		Error_Char[1] = 8'd114;	// r
		Error_Char[2] = 8'd114;	// r
		Error_Char[3] = 8'd33;	// !
	end
	else begin
		case(State)
			Wait_Rdsig:	begin // �ȴ������ź�
								if (!Rdsig)
									State = Wait_Rdsig;
								else
									State = Check_Data;
							end
			Check_Data:	begin // ����Ƿ��д��� 
								if (Rdsig)
									State = Check_Data;
								else begin
									Error_Flag = Rx_DataError_Flag || Rx_FrameError_Flag;
									State = Save_Data;
								end
							end
			Save_Data:	begin // ��������
								if (!Error_Flag) begin
									if (Data_Cnt == 4'd8) begin // �������
										Data_Cnt = 4'd0;
										State = Trans_Data;
									end
									else begin
										State = Wait_Rdsig;
										Data_Reg[Data_Cnt] = Data_Rx;
										Data_Cnt = Data_Cnt + 1;
									end
								end
								else
									State = Trans_Data;
							end
			Trans_Data:	begin // ��������
								if (!Error_Flag) begin
									if (Print_Cnt == 4'd11) begin // ������
										Print_Cnt = 4'd0;
										State = State_Delay;
									end
									else begin
										State = Trans_Data;
										if (cnt == 254) begin // ��һ����Ƶ
											Data_Tx = Print_Reg[Print_Cnt];
											Wrsig = 1'b1;
											cnt = 8'd0;
											Print_Cnt = Print_Cnt + 1;
										end
										else begin
											Wrsig = 1'b0;
											cnt = cnt + 8'd1;
										end
									end
								end
								else begin
									if (Char_Cnt == 4'd4) begin // ������
										Char_Cnt = 4'd0;
										State = State_Delay;
									end
									else begin
										State = Trans_Data;
										if (cnt == 254) begin // ��һ����Ƶ
											Data_Tx = Error_Char[Char_Cnt];
											Wrsig = 1'b1;
											cnt = 8'd0;
											Char_Cnt = Char_Cnt + 1;
										end
										else begin
											Wrsig = 1'b0;
											cnt = cnt + 8'd1;
										end
									end
								end
							end
			State_Delay:begin // �ȴ��ӳ�
								if (cnt == 254) begin // ����س�
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
			default:		begin // ��λ
								Wrsig = 1'b0;
								cnt = 8'd0;
								State = 2'b0;
								Char_Cnt = 4'b0;
								Data_Cnt = 4'b0;
								Print_Cnt = 4'b0;
								for (i=0; i<8; i=i+1)
									Data_Reg[i] = 8'd48;
							end
		endcase
	end
end

Uart_ClkDiv uart_clkdiv(.Sys_CLK(Sys_CLK), .Sys_RST(Sys_RST), .Uart_CLK(Uart_CLK));
Uart_Tx uart_tx(.Uart_CLK(Uart_CLK), .Data_Tx(Data_Tx), .Wrsig(Wrsig), .Idle(Idle), .Signal_Tx(Signal_Tx));
Uart_Rx uart_rx(.Uart_CLK(Uart_CLK), .Uart_RST(Sys_RST), .Signal_Rx(Signal_Rx), .Data_Rx(Data_Rx), .Rdsig(Rdsig), .DataError_Flag(Rx_DataError_Flag), .FrameError_Flag(Rx_FrameError_Flag));

endmodule
