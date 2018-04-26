module Datapath(cw, k, reset, data_in, clock, Databus, Status, Zero, I, Write);
/*
	Created by David Russo
	Last edited 4/24/2018
	
	This Datapath has 5 main modules inside it:
	1. Register File
	2. Arithmetic Logic Unit (ALU)
	3. Random Access Memory (RAM)
	4. Program Counter (PC)
	5. Read-Only Memory (ROM)
	
	**This Datapath is updated to be able to interface with Peripherals**
*/

	// inputs and outputs
	input [28:0]cw; // {status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA}
	input [63:0]k; // constant value
	input [63:0]data_in; // input from Peripherals
	input reset; // resets the register file
	input clock; // clock for the register file and the RAM
	
	output [63:0]Databus; // Outputs to the program counter
	output [3:0]Status;//Status = {Overflow, Carry, Zero, Negative}, status outputs to the control unit
	output [31:0]I; // ROM instructions
	output Zero; // Immediate zero bit for CBZ/CBNZ
	output Write; // Write to memory output to peripherals
	
	/* 
	cw values
	[4:0] = DA
	[9:5] = SA
	[14:10] = SB
	[19:15] = FS
		FS[0] B invert
		FS[1] A invert
		FS[4:2] operation select
			000: and
			001: or
			010: add
			011: XOR
			100: shift left
			101: shift right
			110: not used
			111: not used
	[21:20] = PS
		00: PC <= PC
		01: PC <= PC4
		10: PC <= in
		11: PC <= PC4 + in*4
	[23:22] = enable
		00: ALU_out
		01: RAM_out
		10: PC4
		11: B1 (Was GND)
	[24] regWrite = 1
	[25] memWrite = 0
	[26] = PC_sel
		0: k
		1: a
	[27] = B_sel
		0: k
		1: b
	[28] = status_load
	*/

	// wires
	wire [4:0]DA, SA, SB, FS; // Destination Address, Select A, Select B, Function Select
	wire [1:0]PS, enable; // Program Select, Enables Data onto Databus
	wire regWrite, memWrite, PC_sel, B_sel, status_load; // Write to RegFile, write to RAM, 
																		  // Select PC in, Select B, load status bits
	wire [63:0]a, b, a2, b2, ALU_out, RAM_out, PC, PC4;
	wire [3:0]status_ALU;
	
	// peripheral add-on wires
	wire [63:0]RAM_mux_out;
	wire RAM_det_out;
	wire memWrite2;
	
	// decode control word
	assign {status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA} = cw;
	
	//assign other internal wires
	assign b2 = B_sel ? b : k; // if B_sel is 0: then k, if B_sel is 1: then b
	assign a2 = PC_sel ? a : k; // if PC_sel is 0: then k, if PC_sel is 1: then a
	assign Zero = status_ALU[1];
	assign memWrite2 = RAM_det_out & memWrite;
	
	// define parameters
	defparam status_reg.N = 4;
	
	//Instantiations
	ALU_rev2 ALU_inst(a, b2, FS, ALU_out, status_ALU);
	RegisterFile RegisterFile_inst(a, b, Databus, DA, SA, SB, regWrite, reset, clock); // 32x64
	RAM_det RAM_det_inst(ALU_out[31:0], RAM_det_out);
	RAM256x64 RAM_inst(ALU_out[7:0], clock, Databus, memWrite2, RAM_out);
	RegisterNbit status_reg(Status, status_ALU, status_load, reset, clock);
	ProgramCounter PC_inst(a2, PS, reset, clock, PC, PC4);
	//rom_case ROM_inst(I, PC); // ROM from class
	Muhlbaiers_rom_case ROM_inst1(I, PC[15:0]);
	
	assign RAM_mux_out = RAM_det_out ? RAM_out : data_in;
	assign Databus = enable[1] ? (enable[0] ? b : PC4) : (enable[0] ? RAM_mux_out : ALU_out);
	assign Write = memWrite;

endmodule

module RAM_det(address, out);
	// This module takes in a 32-bit address and outputs 1 if writing to RAM and 0 if writing to peripherals
	input [31:0]address;
	output out;
	
	// if (address <= 32'h3FF) {out = 1'b1}
	assign out = address[8] ? 1'b0 : 1'b1; // just stays as a wire for now
	
endmodule

