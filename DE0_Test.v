module DE0_Test(SW, BUTTON, HEX0, HEX1, HEX2, HEX3, GPIO0_D);
	input  [9:0]SW;
	input  [2:0]BUTTON;
	output [6:0]HEX0, HEX1, HEX2, HEX3;
	output [15:0]GPIO0_D, GPIO1_D;
	
	wire [2:0]button;
	wire [6:0]hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9, hex10, hex11;
	wire [63:0]PC, PC4;
	wire [15:0]R0, R1, R2, R3, R4, R5, R6, R7;
	
	assign button = ~BUTTON;
	assign HEX0 = ~hex0;
	assign HEX1 = ~hex1;
	assign HEX2 = ~hex2;
	assign HEX3 = ~hex3;
	
	assign R0 = 16'h0000;
	assign R1 = 16'hFFFF;
	assign R2 = 16'h0000;
	assign R3 = 16'hFFFF;
	assign R4 = 16'h0000;
	assign R5 = 16'hFFFF;
	assign R6 = 16'h0000;
	assign R7 = 16'hFFFF;

	

/*	
	// This works!
	assign hex0[0] = SW[0];
	assign hex0[1] = SW[1];
	assign hex0[2] = SW[2];
	assign hex0[3] = SW[3];
	assign hex0[4] = SW[4];
	assign hex0[5] = SW[5];
	assign hex0[6] = SW[6];
	-----------------------
	// It works! Displays AbCd on the hex displays
	quad_7seg_decoder SevenSegDE0(16'b1010_1011_1100_1101, hex3, hex2, hex1, hex0);
	-------------------------------------------------------------------------------
	// It works! Displays Program Counter on HEX0 - HEX3. Button2 is the clock, and switch 1 is reset
	ProgramCounter PC_DE0test_inst(64'b0, 2'b01, SW[0], button[2], PC, PC4);
	quad_7seg_decoder SevenSegDE0(PC[15:0], hex3, hex2, hex1, hex0);
*/
	quad_7seg_decoder SevenSegGPIO_1(16'hF0F0, hex7, hex6, hex5, hex4);
	quad_7seg_decoder SevenSegGPIO_2(16'hF0F0, hex11, hex10, hex9, hex8);

	GPIO_Board GPIO_DE0_Test_inst(
	button[2], // connect to CLOCK_50 of the DE0
	R0, R1, R2, R3, R4, R5, R6, R7, // row display inputs
	hex4, 1'b0, hex5, 1'b0, // hex display inputs
	hex6, 1'b0, hex7, 1'b0, 
	hex8, 1'b0, hex9, 1'b0, 
	hex10, 1'b0, hex11, 1'b0, 
	DIP_SW, // 32x DIP switch output
	32'b0, // 32x LED input
	GPIO0_D, // (output) connect to GPIO0_D
	GPIO1_D // (input/output) connect to GPIO1_D
	);

	
	
	
endmodule
