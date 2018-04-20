module control_unit(i, z, status, clock, reset, ControlWord, K);
/*
	Created by David Russo
	Last edited 4/20/2018
	
	The Control Unit:
	- Receives a 32-bit instruction from the ROM
	- Decodes the instructions
	- Uses a series of multiplexors to select which format instruction to execute
	- Generates a 29-bit Control Word and a 64-bit constant
	- Outputs the constant (k) and control word (ControlWord) to the Datapath
	
	This Control Unit has 5 main modules inside it:
	1. Register File
	2. Arithmetic Logic Unit (ALU)
	3. Random Access Memory (RAM)
	4. Program Counter (PC)
	5. Read-Only Memory (ROM)
*/

	// inputs and outputs
	input [31:0]i; // 32 bit instruction
	input z; // 1 bit zero status signal for CBZ_CBNZ
	input [3:0]status; // status = {V, C, Z, N} from reg after ALU
	input clock;
	input reset;
	output [63:0]K;
	output [28:0]ControlWord;
		
		/* CW Values
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
		[92:29] = k
		[93] = state
		*/
	
	// wires
	wire [93:0]cw_D, cw_I_arith, cw_I_logic, cw_IW, cw_R_ALU, cw_B, cw_B_cond, cw_BL, cw_CBZ_CBNZ, cw_BR, cw_ALU, cw_branch, CW; // control words
	wire [93:0]cw_RI_Logic; // control word from the new RI_Logic Module
	wire state, p_state; // state bits for MOVK
	wire [10:0]Op; // assumes a general 11-bit Op code to use for mux selects
		assign Op[10:0] = i[31:21];
	
	// define paramemters
	defparam state_reg.N = 1;
	defparam mux_cw_ALU.N = 94;
	defparam mux_cw_branch.N = 94;

	// instruction decoder instantiations
	D D_dec(i, cw_D);
	I_arith I_arith_dec(i, cw_I_arith);
	//I_logic I_logic_dec(i, cw_I_logic);
	RI_Logic RI_Logic_dec(i, cw_RI_Logic);
	IW IW_dec(i, p_state, cw_IW);
	R_ALU R_ALU_dec(i, cw_R_ALU);
	B B_dec(i, cw_B);
	B_cond B_cond_dec(i, status, cw_B_cond);
	BL BL_dec(i, cw_BL);
	CBZ_CBNZ CBZ_CBNZ_dec(i, z, cw_CBZ_CBNZ);
	BR BR_dec(i, cw_BR);
	
	// Mux logic
	Mux8to1Nbit mux_cw_ALU(cw_ALU, Op[4:2], cw_D, 94'b0, cw_I_arith, 94'b0, cw_RI_Logic, cw_IW, cw_R_ALU, 94'b0);
	Mux8to1Nbit mux_cw_branch(cw_branch, Op[10:8], cw_B, 94'b0, cw_B_cond, 94'b0, cw_BL, cw_CBZ_CBNZ, cw_BR, 94'b0);
	assign CW = Op[5] ? cw_branch : cw_ALU;
	assign state = CW[93];
	assign K = CW[92:29];
	assign ControlWord = CW[28:0];
	RegisterNbit state_reg(p_state, state, 1'b1, reset, clock);

endmodule

module I_arith(i, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	wire [9:0]Op; // 10 bit opcode 
		assign Op[9:0] = i[31:22];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = i[4:0];
	assign SA = i[9:5];
	assign SB = 5'b11111;
	assign FS[4:1] = 4'b0100;
	assign FS[0] = Op[8];
	assign PS = 2'b01; // PC <= PC + 4
	assign enable = 2'b00; // enable ALU_out onto the databus
	assign regWrite = 1'b1;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0;
	assign B_sel = 1'b0; // selects k instead of b
	assign status_load = Op[7];
	assign k = {52'b0, i[21:10]};
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module I_logic(i, CW); // Not used anymore
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	wire [9:0]Op; // 10 bit opcode 
		assign Op[9:0] = i[31:22];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = i[4:0];
	assign SA = i[9:5];
	assign SB = 5'b11111;
	assign FS[4] = 1'b0;
	assign FS[3] = Op[8] & ~Op[7];
	assign FS[2] = Op[8] ^ Op[7];
	assign FS[1:0] = 2'b00;
	assign PS = 2'b01; // PC <= PC + 4
	assign enable = 2'b00; // enable ALU_out onto the databus
	assign regWrite = 1'b1;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0;
	assign B_sel = 1'b0; // selects k instead of b
	assign status_load = i[30] & i[29];
	assign k = {52'b0, i[21:10]};
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module RI_Logic(i, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	wire [10:0]Op; // 10 bit opcode 
		assign Op[10:0] = i[31:21];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = i[4:0];
	assign SA = i[9:5];
	assign SB = i[20:16];
	assign FS[4] = 1'b0;
	assign FS[3] = Op[9] & ~Op[8];
	assign FS[2] = Op[9] ^ Op[8];
	assign FS[1:0] = 2'b00;
	assign PS = 2'b01; // PC <= PC + 4
	assign enable = 2'b00; // enable ALU_out onto the databus
	assign regWrite = 1'b1;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0; // don't care
	assign B_sel = Op[6]; // selects k instead of b
	assign status_load = Op[9] & Op[8];
	assign k = i[6] ? {58'b0, i[15:10]} : {52'b0, i[21:10]};
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule


module R_ALU(i, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	wire [10:0]Op; // 11 bit opcode 
		assign Op[10:0] = i[31:21];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = i[4:0];
	assign SA = i[9:5];
	assign SB = i[20:16];
	assign FS[4] = Op[1];
	assign FS[3] = Op[6];
	assign FS[2] = Op[1] & ~Op[0];
	assign FS[1] = 1'b0;
	assign FS[0] = Op[9] & Op[6];
	assign PS = 2'b01; // PC <= PC + 4
	assign enable = 2'b00; // enable ALU_out onto the databus
	assign regWrite = 1'b1;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0;
	assign B_sel = ~Op[1]; // selects B except when shifting
	assign status_load = (Op[9] & Op[8]) | (~Op[9] & Op[8] & Op[3]);
	assign k = {52'b0, i[21:10]};
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module D(i, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	wire [10:0]Op; // 11 bit opcode 
		assign Op[10:0] = i[31:21];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = i[4:0];
	assign SA = i[9:5];
	assign SB = i[4:0];
	assign FS[4:0] = 5'b01000; // ADD
	assign PS = 2'b01; // PC <= PC + 4
	assign enable[1] = ~Op[1]; // for STUR enable b, for LDUR enable RAM_out
	assign enable[0] = 1'b1;
	assign regWrite = Op[1];
	assign memWrite = ~Op[1];
	assign PC_sel = 1'b0;
	assign B_sel = 1'b0; // selects B except when shifting
	assign status_load = 1'b0;
	assign k = {55'b0, i[20:12]};
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module IW(i, p_state, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	input p_state;    // previous state bit
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	wire [8:0]Op; // 9 bit opcode 
		assign Op[8:0] = i[31:23];
	wire [3:0]k_sel;
		assign k_sel = {Op[6], p_state, i[22:21]};
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	reg [63:0]k;
	wire state;
	
	// assign statements
	assign DA = i[4:0];
	assign SA = 5'b11111;
	assign SB = 5'b11111;
	assign FS[4:3] = 2'b00;
	assign FS[2] = p_state;
	assign FS[1:0] = 2'b00;
	assign PS[1] = 1'b0;
	assign PS[0] = ~Op[6] | (Op[6] & p_state);
	assign enable = 2'b00; // enable ALU_out onto databus
	assign regWrite = 1'b1;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0;
	assign B_sel = 1'b0; // selects k
	assign status_load = 1'b0;
	always @(*) begin
	case(k_sel)
		4'b0000: k[63:0] <= {48'b0, i[20:5]};
		4'b0001: k[63:0] <= {32'b0, i[20:5], 16'b0};
		4'b0010: k[63:0] <= {16'b0, i[20:5], 32'b0};
		4'b0011: k[63:0] <= {i[20:5], 48'b0};
		4'b0100: k[63:0] <= {48'b0, i[20:5]};         // This condition shouldn't exist
		4'b0101: k[63:0] <= {32'b0, i[20:5], 16'b0};  // This condition shouldn't exist
		4'b0110: k[63:0] <= {16'b0, i[20:5], 32'b0};  // This condition shouldn't exist
		4'b0111: k[63:0] <= {i[20:5], 48'b0};         // This condition shouldn't exist
		4'b1000: k[63:0] <= {48'hFFFF_FFFF_FFFF, 16'b0};
		4'b1001: k[63:0] <= {32'hFFFF_FFFF, 16'b0, 16'hFFFF};
		4'b1010: k[63:0] <= {16'hFFFF, 16'b0, 32'hFFFF_FFFF};
		4'b1011: k[63:0] <= {16'b0, 48'hFFFF_FFFF_FFFF};
		4'b1100: k[63:0] <= {48'b0, i[20:5]};
		4'b1101: k[63:0] <= {32'b0, i[20:5], 16'b0};
		4'b1110: k[63:0] <= {16'b0, i[20:5], 32'b0};
		4'b1111: k[63:0] <= {i[20:5], 48'b0};
		default: k[63:0] <= {48'b0, i[20:5]};
	endcase
	end
	
	assign state = Op[6] & ~p_state;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule


module BR(i, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	//wire [5:0]Op; // 6 bit opcode 
	//	assign Op[5:0] = i[31:26];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = i[4:0]; // don't care
	assign SA = i[9:5]; // Branch to this register
	assign SB = i[20:16]; // don't care
	assign FS[4:0] = 00000; // Don't care
	assign PS = 2'b10; // PC <= in
	assign enable = 2'b10; // enable PC4 onto the databus
	assign regWrite = 1'b0;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b1; // selects A to go to PC in
	assign B_sel = 1'b0; // don't care
	assign status_load = 1'b0; // don't care
	assign k = 64'b0; // don't care
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module B(i, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	//wire [5:0]Op; // 6 bit opcode 
	//	assign Op[5:0] = i[31:26];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = 5'b11111; // don't care
	assign SA = 5'b11111; // don't care
	assign SB = 5'b11111; // don't care
	assign FS = 5'b00000; // don't care
	assign PS = 2'b11; // PC <= PC + 4 + in * 4
	assign enable = 2'b10; // enable PC4 onto the databus
	assign regWrite = 1'b0;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0; // selects k to go to PC in
	assign B_sel = 1'b0; // don't care
	assign status_load = 1'b0; // don't care
	assign k[63:0] = i[25] ? {36'hFFFF_FFFF_F, 2'b11, i[25:0]} : {36'h0000_0000_0, 2'b00, i[25:0]}; // sign extended
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module BL(i, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	//wire [5:0]Op; // 6 bit opcode 
	//	assign Op[5:0] = i[31:26];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = 5'b11110; // register 30
	assign SA = 5'b11111; // don't care
	assign SB = 5'b11111; // don't care
	assign FS = 5'b00000; // don't care
	assign PS = 2'b11; // PC <= PC + 4 + in * 4
	assign enable = 2'b10; // enable PC4 onto the databus
	assign regWrite = 1'b1;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0; // selects k to go to PC in
	assign B_sel = 1'b0; // don't care
	assign status_load = 1'b0; // don't care
	assign k[63:0] = i[25] ? {36'hFFFF_FFFF_F, 2'b11, i[25:0]} : {36'h0000_0000_0, 2'b00, i[25:0]}; // sign extended
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module CBZ_CBNZ(i, z, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	input z;          // zero status bit
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	wire [7:0]Op; // 8 bit opcode 
		assign Op[7:0] = i[31:24];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = 5'b00000; // don't care
	assign SA = 5'b11111; // don't care
	assign SB = 5'b11111; // don't care
	assign FS = 5'b00000; // don't care
	assign PS[1] = 1'b1;
	assign PS[0] = Op[0] ^ z;
	assign enable = 2'b10; // enable PC4 onto the databus
	assign regWrite = 1'b0;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b1; // selects a to go to PC in
	assign B_sel = 1'b0; // don't care
	assign status_load = 1'b0; // don't care
	assign k = i[23] ? {44'hFFFF_FFFF_FFF, 1'b1, i[23:5]} : {44'h0000_0000_000, 1'b0, i[23:5]}; // sign extended
	assign state = 1'b0;
	
	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
	
endmodule

module B_cond(i, status, CW);
	//inputs and outputs
	input [31:0]i;    // 32 bit instructions from the ROM
	input [3:0]status;// 4 bit status bit
	output [93:0]CW;  // 94 bit control word including k and the next state bit
	
	// wires
	//wire [7:0]Op; // 8 bit opcode 
	//	assign Op[7:0] = i[31:24];
	wire V, C, Z, N; // Decoded status signals
		assign V = status[3];
		assign C = status[2];
		assign Z = status[1];
		assign N = status[0];
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	// assign statements
	assign DA = 5'b00000; // don't care
	assign SA = i[4:0]; // Condition encoding
	assign SB = 5'b11111; // don't care
	assign FS = 5'b00000; // don't care
	//assign PS[1] = see logic below;
	assign PS[0] = 1'b1;
	assign enable = 2'b10; // enable PC4 onto the databus
	assign regWrite = 1'b0;
	assign memWrite = 1'b0;
	assign PC_sel = 1'b0; // selects k to go to PC in
	assign B_sel = 1'b0; // don't care
	assign status_load = 1'b0; // don't care
	assign k = i[23] ? {44'hFFFF_FFFF_FFF, 1'b1, i[23:5]} : {44'h0000_0000_000, 1'b0, i[23:5]}; // sign extended
	assign state = 1'b0;
	
	// PS[1] wires
	wire muxOut_0; // Output of the 4:1 mux
	wire muxOut_1; // Output of the 8:1 mux
	
	// Define parameters
	defparam B_cond_8to1.N = 1;
	
	// PS[1] Logic
	assign muxOut_0 = i[2] ? (i[1] ? V : N) : (i[1] ? C : Z);
	Mux8to1Nbit B_cond_8to1(muxOut_1, i[2:0], (C & ~Z), (~C & Z), ~(N ^ V), (N ^ V), (~Z & ~(N ^ V)), (Z | (N ^ V)), 1'b1, 1'b1);
	assign PS[1] = i[3] ?  muxOut_1 : muxOut_0 ^ i[0];	

	//concatenation
	assign CW = {state, k, status_load, B_sel, PC_sel, memWrite, regWrite, enable, PS, FS, SB, SA, DA};
endmodule
