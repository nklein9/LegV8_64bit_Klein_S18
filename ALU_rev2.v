module ALU_rev2(a, b, functionSelect, F, Status);
	
	/*
		Created by David Russo
		Last Edited 4/21/18 (Comments only)
		
		The Arithmetic Logic Unit (ALU):
		- Is instantiated inside the Datapath
		- Takes in two 64-bit operands from the register file, a and b 
		- Takes in a 5-bit function select bit
		- Performs either Arithmetic, Logic, or shift operations
		- Outputs a 64-bit result, F
			- F feeds into a 4:1 Mux, to feed onto the databus in the Datapath
			- F[7:0] feeds into the address of the 256x64-bit RAM
		- Outputs a 4-bit Status signal that feeds into the control unit to use for instructions CBZ_CBNZ and B.cond
		
		ALU_rev2 has 6 different operations:
		1. 64-bit bitwise AND
		2. 64-bit bitwise OR
		3. 64-bit bitwise ADD
		4. 64 bit bitwise XOR
		5. LSL (Logical Shift Left)
		6. LSR (Logical Shift Right)
	*/
	
	// inputs and outputs
	input [63:0]a, b; // Operands from the Register File
	input [4:0]functionSelect; // Represented as FS in higher level modules
	output [63:0]F; // output of the ALU that goes either onto the databus or the last 8 bits can give the base address when storing to RAM
	output [3:0]Status; // {Overflow, Carry, Zero, Negative}. Outputs signals to be read by the control unit

	/*
	FunctionSelect Breakdown
	[0] - B invert
	[1] - A invert
	[4:2] - operation select in 8:1 mux
		000 - AND
		001 - OR
		010 - ADD
		011 - XOR
		100 - LSL (Logical Shift Left)
		101 - LSR (Logical Shift Right)
		110 - not used
		111 - not used
	*/
	
	// wires
	wire [63:0]A_value, B_value, And, Or, Add, Xor, ShiftLeft, ShiftRight;
	wire Negative, Zero, Carry, Overflow; // status bits
	assign Status = {Overflow, Carry, Zero, Negative};
	
	// assignments and instantiations
	assign A_value = functionSelect[1] ? ~a : a; // to invert A
	assign B_value = functionSelect[0] ? ~b : b; // to invert B
	
	assign And = A_value & B_value; // Represents 64-bit bitwise AND gate
	assign Or = A_value | B_value;  // Represents 64-bit bitwise OR gate
	RippleCarryAdder RCA_0(A_value, B_value, functionSelect[0], Add, Carry);
	assign Xor = A_value ^ B_value; // Represents 64-bit bitwise XOR gate
	Shifter shift_inst(A_value, B_value[5:0], ShiftLeft, ShiftRight);
	
	Mux8to1Nbit ALU_mux(F, functionSelect[4:2], And, Or, Add, Xor, ShiftLeft, ShiftRight, 64'b0, 64'b0);
	
	// Assigning the Status bits: {V, C, Z, N}
	assign Overflow = ~(A_value[63] ^ B_value[63]) & (A_value[63] ^ B_value[63]);
	// Carry is already assigned as the carryout of RCA_0
	assign Negative = F[63];
	assign Zero = (F == 64'b0) ? 1'b1 : 1'b0;
	
	defparam ALU_mux.N = 64;
	
endmodule

