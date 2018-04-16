//Nicholas Klein
//Last Edit April 16, 2018
module complete_datapath_testbench ();
	wire [63:0] data; //datapath
	wire [31:0] address;
	wire regW;
	wire EN_MEM;
	reg reset;
	reg clock;
	
	wire [92:0] CW;
	wire data, aluOut,
	assign CW = dut.CW;
	
	datapath dut (data, address, regW, EN_MEM, clock);
	
	initial begin
		reset <= 1'b1;
		clock <= 1'b1;
		#5
		reset <= 1'b0;

		#250 $stop;
	end
	
	//clock cycle
	always begin
		#5
		clock <= ~clock;
	end
	
endmodule
