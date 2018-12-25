module Sync_capturer(clk, in, strobe, data, error, rst);
	input clk;
	input in;
	output strobe;
	output data;
	output error;
	input rst;
	
	wire raw_strobe;
	wire raw_data;
	reg old_in;
	reg [1:0] State;
	reg [3:0] cnt;
	reg [4:0] data_cnt;
	reg presult;
	
	parameter Wait_Sync = 2'b00;
	parameter Low_Delay = 2'b01;
	parameter High_Delay = 2'b10;
	parameter Recv_Data = 2'b11; // Unmodifiable
	
	parameter paritymode = 1'b1;
	
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			old_in <= 1'b1;
			State <= Wait_Sync;
			cnt <= 4'b0;
			data_cnt <= 5'b0;
			presult <= paritymode;
		end
		else begin
			case (State)
				Wait_Sync:	begin
									data_cnt <= 5'b0;
									if (!in)
										State <= Low_Delay;
								end
				Low_Delay:	begin
									if (cnt == 4'd11) begin
										if (in) begin
											cnt <= 4'd0;
											State <= High_Delay;
										end
									end
									else begin
										if (in) begin
											cnt <= 4'd0;
											State <= Wait_Sync;
										end
										else
											cnt <= cnt + 1;
									end
								end
				High_Delay:	begin
									if (cnt == 4'd11) begin
										cnt <= 4'd0;
										State <= Recv_Data;
									end
									else begin
										if (!in) begin
											cnt <= 4'd0;
											State <= Wait_Sync;
										end
										else
											cnt <= cnt + 1;
									end
								end
				Recv_Data:	begin
									if (cnt < 4'd15) begin
										old_in <= in;
										if (cnt == 4'd3) begin
											if (in == old_in)
												State <= Wait_Sync;
										end
										cnt <= cnt + 1;
									end
									if (strobe) begin
										if (data_cnt == 5'd16) begin
											State <= Wait_Sync;
										end
										else begin
											presult <= presult ^ data;
											data_cnt <= data_cnt + 1;
										end
									end
								end
			endcase
		end
	end
	
	assign strobe = raw_strobe & State[0] & State[1];
	assign data = raw_data & State[0] & State[1];
	assign error = data ^ presult;
	
	MAN_decoder_RTL man_decoder_rtl (
		.clk(clk),
		.in(in & State[0] & State[1]),
		.strobe(raw_strobe),
		.data(raw_data),
		.rst(rst)
	);
	
endmodule
