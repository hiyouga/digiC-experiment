`timescale 1ns / 1ps

module Top(sys_clk, sys_rst, switch, key, com, seg, led, Uart_Tx, Uart_Rx);
	input sys_clk;
	input sys_rst;
	input [1:0] switch;
	input [1:0] key;
	output [1:0] com;
	output [7:0] seg;
	output [3:0] led;
	input Uart_Rx;
	output Uart_Tx;
	
	wire [1:0] key_out;
	wire [1:0] light;
	wire [2:0] state;
	wire [7:0] number;
	wire [4:0] index;
	wire [7:0] oplist;
	wire [4:0] recv_index;
	wire [7:0] recv_data;
	wire send_idle;
	wire auto_idle;
	reg mode;
	reg auto;
	reg sending;
	reg [4:0] max_index;
	reg [4:0] length;
	reg [4:0] send_index;
	reg [4:0] auto_index;
	reg [7:0] records[0:15];
	reg [7:0] send_data;
	reg [6:0] auto_data;
	reg send_enable;
	reg auto_enable;
	integer i;
	
	always @(posedge sys_clk or negedge sys_rst) begin
		if (!sys_rst) begin
			mode <= 1'b0;
			for (i=0; i<16; i=i+1)
				records[i] <= 8'b0;
			max_index <= 5'b0;
			length <= 5'b0;
			send_index <= 5'b0;
			auto_index <= 5'b0;
			sending <= 1'b0;
			auto <= 1'b0;
			send_data <= 8'b0;
			auto_data <= 8'b0;
			send_enable <= 1'b0;
			auto_enable <= 1'b0;
		end
		else begin
			if (switch[1] == 1'b0) begin // MODE_RUN
				mode <= 1'b0;
				auto <= 1'b0;
				if (switch[0] == 1'b1) begin // Record
					if (length != index && length < 16) begin
						length <= index;
						records[length] <= oplist;
					end
				end
				else begin
					if (length != 5'b0) begin
						max_index <= length;
						length <= 5'b0;
					end
					if (key_out[1] && !sending) begin // Send start
						sending <= 1'b1;
					end
				end
				if (sending) begin // Sending
					if (send_idle && !send_enable) begin
						if (send_index == max_index) begin
							sending <= 1'b0;
							send_index <= 5'b0;
						end
						else begin
							send_enable <= 1'b1;
							send_data <= records[send_index];
							send_index <= send_index + 1;
						end
					end
					else if (!send_idle) begin
						send_enable <= 1'b0;
					end
				end
			end
			else begin // MODE_DEMO
				mode <= 1'b1;
				if (switch[0] == 1'b1) begin // Receive
					if (length != recv_index && length < 16) begin
						length <= recv_index;
						records[length] <= recv_data;
					end
				end
				else begin
					if (length) begin
						max_index <= length;
						length <= 1'b0;
					end
					if (key_out[1] && !auto) begin // Auto start
						auto <= 1'b1;
					end
				end
				if (auto) begin // Auto
					if (auto_idle && !auto_enable) begin
						if (auto_index == max_index) begin
							auto <= 1'b0;
							auto_index <= 5'b0;
						end
						else begin
							auto_enable <= 1'b1;
							auto_data <= records[auto_index][6:0];
							auto_index <= auto_index + 1;
						end
					end
					else if (!auto_idle) begin
						auto_enable <= 1'b0;
					end
				end
			end
		end
	end
	
	Key_debounce key_debounce (
		.clk(sys_clk),
		.rst(sys_rst),
		.key(key),
		.key_pulse(key_out)
	);
	
	Controller controller (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Key_In(key_out[0]),
		.Mode(mode),
		.Auto(auto),
		.Auto_enable(auto_enable),
		.Auto_data(auto_data),
		.Auto_idle(auto_idle),
		.Light(light),
		.Number(number),
		.State(state)
	);
	
	Display_num display_num (
		.clk(sys_clk),
		.rst(sys_rst),
		.number(number),
		.state(state),
		.com(com),
		.seg(seg)
	);
	
	Light_led light_led (
		.Light(light),
		.Led(led)
	);
	
	Recorder recorder (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Recording(switch[0]),
		.Key_In(key_out[0]),
		.Length(length),
		.Light(light),
		.Index(index),
		.opList(oplist)
	);
	
	Uart_Top uart_top (
		.Sys_CLK(sys_clk),
		.Sys_RST(sys_rst),
		.Signal_Tx(Uart_Tx),
		.Signal_Rx(Uart_Rx),
		.Data(send_data),
		.Length(length),
		.Receiving(switch[0]),
		.Tx_Sig(send_enable),
		.Tx_Idle(send_idle),
		.Recv_index(recv_index),
		.Recv_data(recv_data)
	);
	
endmodule
