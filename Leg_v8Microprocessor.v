//module Leg_v8Microprocessor(CLOCK_50, SW, HEX0, HEX1, HEX2, HEX3);
module Leg_v8Microprocessor(CLOCK_50, SW, BUTTON, HEX0, HEX1, HEX2, HEX3, GPIO0_D, GPIO1_D, LEDS);

	//inputs and outputs of the DE0 and GPIO Board
	input CLOCK_50;
	input [9:0]SW;
	input [2:0]BUTTON;	
	output [6:0]HEX0, HEX1, HEX2, HEX3;
	output [31:0]GPIO0_D, GPIO1_D;
	output [31:0]LEDS;
	
	// wires
	// Outputs to DE0 and GPIO Board
	wire [6:0]hex0, hex1, hex2, hex3;
		assign HEX0 = ~hex0;
		assign HEX1 = ~hex1;
		assign HEX2 = ~hex2;
		assign HEX3 = ~hex3;
	wire [2:0]button;
		assign button = ~BUTTON;
	// Between CPU and Peripherals
	wire [63:0]CPU_data; // data coming out of the CPU
	wire [63:0]P_data;   // data coming out of the Peripherals
	wire [15:0]address;
	wire write;
	
	// From CPU to DE0 and GPIO Board
	wire [15:0]PC_out;
	wire [15:0]R0, R1, R2, R3, R4, R5, R6, R7; // Registers 0 - 7
	wire [31:0]i; // instruction from CPU ROM to Control Unit
	
	// other wires
	wire [6:0]hex4, hex5, hex6, hex7, hex8, hex9, hex10, hex11; // hex inputs to the GPIO
	wire reset;
	wire clock_1;
	
	// assigning values
	assign LEDS = i;
	
	// instantiations
	clock_div clock_div_inst(CLOCK_50, clock_1);
	CPU CPU_inst(P_data, clock_1, reset, CPU_data, write, R0, R1, R2, R3, R4, R5, R6, R7, PC_out, i);
	// peripherals go here 
	quad_7seg_decoder quad7seg_inst1(PC_out[15:0], hex3, hex2, hex1, hex0);
	quad_7seg_decoder quad7seg_inst2(address[15:0], hex7, hex6, hex5, hex4);
	quad_7seg_decoder quad7seg_inst3(CPU_data[15:0], hex11, hex10, hex9, hex8);
	GPIO_Board GPIO_Board_inst(
		CLOCK_50, // connect to CLOCK_50 of the DE0
		R0, R1, R2, R3, R4, R5, R6, R7, // row display inputs
		hex4, 1'b0, hex5, 1'b0, // hex display inputs
		hex6, 1'b0, hex7, 1'b0, 
		hex8, 1'b0, hex9, 1'b0, 
		hex10, 1'b0, hex11, 1'b0, 
		DIP_SW, // 32x DIP switch output
		i, // 32x LED input
		GPIO0_D, // (output) connect to GPIO0_D
		GPIO1_D // (input/output) connect to GPIO1_D
	);
		
	
endmodule
