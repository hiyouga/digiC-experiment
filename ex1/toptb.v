module Toptb;

	// Inputs
	reg sys_clk;
	reg sys_rst;
	reg [1:0] switch;
	reg [1:0] key;

	// Outputs
	wire [1:0] com;
	wire [7:0] seg;
	wire [3:0] led;

	// Instantiate the Unit Under Test (UUT)
	Top uut (
		.sys_clk(sys_clk), 
		.sys_rst(sys_rst), 
		.switch(switch), 
		.key(key), 
		.com(com), 
		.seg(seg), 
		.led(led)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 0;
		sys_rst = 1;
		switch = 2'b00;
		key = 2'b00;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		sys_rst = 0;
		#10;
		sys_rst = 1;
		#10;
		switch = 2'b00;
		key = 2'b10;
		#2000000;
		key = 2'b00;
		#2000000;
		key = 2'b10;
		#2000000;
		key = 2'b00;
		#2000000;
		switch = 2'b01;
		#10;
		key = 2'b01;
		#2000000;
		key = 2'b00;
		#2000000;
		key = 2'b01;
		#2000000;
		key = 2'b00;
	end
	
	always #1 sys_clk = ~sys_clk;
      
endmodule
