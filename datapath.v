//Nicholas Klein
//Last Edit Feb 19, 2018
module datapath (data, status, clock, k, DA, SA, SB, FS, dataMux, regW, ramW, R, Bsel);
	output [63:0] data; //datapath
	output [3:0] status;
	input clock;
	input [63:0] k; //constant
	input [4:0] DA, SA, SB, FS;
	input dataMux, regW, ramW, R, Bsel;
	
	//wire [25:0] CW = {DA, SA, SB, FS, dataMux, regW, ramW, R, Bsel}; //command word
		/*
		[4:0] DA
		[10:5] SA
		[15:11] SB
		[20:16] FS (select function)
		[21] dataMux
		[22] regW (Reg write)
		[23] ramW (Ram write)
		[24] reset (reset)
		[25] Bsel (select B)
		*/
	wire [63:0] A, B1, B2, aluOut, ramOut;
	
	assign data = dataMux ? ramOut : aluOut;
	
	RegFile32x64 reg_inst (A, B1, data, DA, SA, SB, regW, R, clock);
	assign B2 = Bsel ? B1 : k;
	ALU alu_inst (aluOut, status, A, B2, FS);
	RAM256x64 ram_inst (aluOut[7:0], clock, B1, ramW, ramOut);
	
endmodule
