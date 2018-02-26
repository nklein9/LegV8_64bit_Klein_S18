//Nicholas Klein
//Last Edit Feb 26, 2018
module programCounter_Testbench ();
	wire [63:0] PC;
	wire [63:0] PC4;
	reg [1:0] PS;
	reg [63:0] in;
	reg reset;
	reg clock;
	
	programCounter dut(PC, PC4, PS, in, reset, clock);
	
	initial begin
		PS <= 2'b00;
		in <= {$random, $random};
		reset <= 1'b1;
		clock <= 1'b0;
		#10
		reset <= 1'b0;
		#500
		$stop;
	end
	
	always begin
		#5
		clock <= ~clock;
	end
	
	always begin
		#30
		PS<=PS+1'b1;
	end
	
endmodule
