//Nicholas Klein
//Last Edit April 15, 2018
module datapath (data, address, regW, EN_MEM, datain, clock, reset);
	output [63:0] data; //datapath should be inout
	output [63:0] address;
	output regW;
	output EN_MEM;
	input [63:0] datain;
	input clock;
	input reset;
	
	wire [92:0] CW;
	wire [63:0] A, toPC, B1, B2, aluOut, ramOut, PC, PC4, k;
	wire [31:0] instr, instruction;
	wire [3:0] status, heldStatus, PS;
	wire [4:0] DA, SA, SB, FS;
	wire [1:0] dataMux;
	wire ramW, R, PCsel, Bsel, SL, ramCheck, ramCheckandWrite;
	
	//ControlWord
	assign k = CW[92:29];
	assign SL = CW[28];
	assign Bsel = CW[27];
	assign PCsel = CW[26];
	assign ramW = CW[25];
	assign regW = CW[24];
	assign dataMux = CW[23:22];
	/*
		00: aluOut
		01: ramOut
		10: PC4
		11: B1 (Was GND)
	*/
	assign PS = CW[21:20];
	/*
		00: PC<=PC
		01: PC<=PC4
		10: PC<=in
		11: PC<=PC4+in*4
	*/
	assign FS = CW[19:15];
	/*
		FS0 B invert
		FS1 A invert
		FS4:2 operation select
			000 and
			001 or
			010 add
			011 XOR
			100 shift left
			101 shift right
			110 not used
			111 not used
	*/
	assign SB = CW[14:10];
	assign SA = CW[9:5];
	assign DA = CW[4:0];
	//end ControlWord
	
	//control
		//Reg2Loc, Branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite
	//instruct
		//control, SA, (mux to)SB, DA, 
		
	assign address = aluOut;
	assign data = dataMux[1] ? (dataMux[0] ? B1 : PC4) : (dataMux[0] ? (ramCheck ? ramOut : datain) : aluOut);
	assign EN_MEM = ~dataMux[0] & dataMux[1];
	assign ramCheckandWrite = ramCheck & ramW;
	
	//control
	programCounter2 pc_inst (PC, PC4, PS[1:0], toPC, reset, clock);
	rom_case instr_mem_inst (instruction, PC[17:2]);
	controlUnit CU_inst (CW, instruction, heldStatus, reset, clock);
	
	//data
	RegFile32x64 reg_inst (A, B1, data, DA, SA, SB, regW, reset, clock);
	assign B2 = Bsel ? k : B1;
	assign toPC = PCsel ? k : A;
	ALU alu_inst (aluOut, status, A, B2, FS);
		RegisterNbit status_register_inst (heldStatus, status, SL, reset, clock);
		defparam status_register_inst.N = 4;
		checkAddress CA_inst(ramCheck, aluOut);
	RAM256x64 ram_inst (aluOut[7:0], clock, B1, ramCheckandWrite, ramOut);
	
	
endmodule
