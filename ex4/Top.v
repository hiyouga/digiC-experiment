module Top(sys_clk, sys_rst);
	input sys_clk;
	input sys_rst;
	
	wire div_clk;
	wire serial_data;
	wire strobe;
	wire data;
	
	Serial_Generate serial_generate (
		.clk(sys_clk),
		.serial_data(serial_data),
		.div_clk(div_clk),
		.rst(sys_rst)
	);
	
	Sync_capturer sync_capturer (
		.clk(div_clk),
		.in(serial_data),
		.strobe(strobe),
		.data(data),
		.rst(sys_rst)
	);
	
endmodule
