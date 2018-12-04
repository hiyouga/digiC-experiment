module Key_debounce(clk, rst, key, key_pulse);
	input clk;
	input rst;
	input [1:0] key;
	output [1:0] key_pulse;
	
	reg [1:0] key_rst_pre;
	reg [1:0] key_rst;
	wire [1:0] key_edge;
	
	always @(posedge clk or negedge rst)
		if (!rst) begin
			key_rst <= 2'b00;
			key_rst_pre <= 2'b00;
		end
		else begin
			key_rst <= key;
			key_rst_pre <= key_rst;
		end

	assign  key_edge = key_rst_pre & (~key_rst);

	reg [17:0] cnt;

	always @(posedge clk or negedge rst) begin
		if(!rst)
			cnt <= 18'h0;
		else if(key_edge)
			cnt <= 18'h0;
		else
			cnt <= cnt + 1'h1;
	end

	reg [1:0] key_sec_pre;
	reg [1:0] key_sec;

	always @(posedge clk or negedge rst) begin
	if (!rst)
		key_sec <= 2'b00;
	else if (cnt == 18'h3ffff)
		key_sec <= key;
	end
	
	always @(posedge clk or negedge rst) begin
	if (!rst)
		key_sec_pre <= 2'b00;
	else
		key_sec_pre <= key_sec;
	end
	
	assign key_pulse = key_sec_pre & (~key_sec);

endmodule
