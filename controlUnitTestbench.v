module controlUnitTestbench ();
	reg [31:0] instruction;
								//registered, instant
	reg [3:0] status; // V, C, Z, N
	reg reset;
	reg clock;
	wire [92:0] control_word;
	
	controlUnit dut (control_word, instruction, status, reset, clock);
	
	initial begin
	instruction <= 32'b0;
		status <= 4'b0;
		reset <= 1'b1;
		clock <= 1'b1;
		#10
		reset <= 1'b0;
		
	end
	
	//clock cycle
	always begin
		#5
		clock <= ~clock;
	end
	
	always begin
		#10
		#5
		instruction <= 32'b1001000100_000001100100_11111_00100; //ADDI X4, XZR, 100;
		#5
		instruction <= 32'b110100101_00_0000000110010000_01000; //MOVZ X8, 400;
		#5
		instruction <= 32'b110100101_00_0000010010110000_01001; //MOVZ X9, 1200;
		#5
		instruction <= 32'b10110100_0000000000000000110_00100; //CBZ X4, 6;
		#5
		instruction <= 32'b1101000100_000000000001_00100_00100; //SUBI X4, X4, 1;
		#5
		instruction <= 32'b11111000010_000000000_00_01000_01010;//LDUR X10, [X8,0]
		#5
		instruction <= 32'b1001000100_000000001000_01000_01000;//ADDI X8, X8, 8
		#5
		instruction <= 32'b11111000000_000000000_00_01001_01010 ;//STUR x10, [X9, 0]
		#5
		instruction <= 32'b1001000100_0000000000_00_01001_01011;//ADDI X9, X9, 8
		#5
		instruction <= 32'b000101_11111111111111111111111001; //B -7
		#5
		$stop;
	end


endmodule
