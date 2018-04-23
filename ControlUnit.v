//Nicholas Klein
//Last edit April 15, 2018

//`define CW_BITS 93; Can't make it work, repaced CW_BITS with 93 and CW_BITS-1 with 92
//CW = {K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA}
module controlUnit (control_word, instruction, status, reset, clock);
	input [31:0] instruction;
								//registered, instant
	input [3:0] status; // V, C, Z, N
	input reset, clock;
	output [92:0] control_word;

	wire [10:0] opcode;

	assign opcode = instruction[31:21];

	//partial control words
	wire [93:0] branch_cw, other_cw;
	wire [93:0] D_format_cw, I_artithmetic_cw, I_logic_cw, IW_cw, R_ALU_cw;
	wire [93:0] B_cw, B_conD_format_cw, BL_cw, CBZ_cw, BR_cw;

	//state logic
	wire NS;
	reg state;
	always @ (posedge clock or posedge reset) begin
		if (reset)
			state <= 1'b0;
		else
			state <= NS;
	end
	
	assign NS = control_word[92];

	//partial control unit decoders
	D_decoder dec0_000 (instruction, D_format_cw);
	I_artithmetic_decoder dec0_010 (instruction, I_artithmetic_cw);
	I_logic_decoder dec0_100 (instruction, I_logic_cw);
	IW_decoder dec0_101 (instruction, state, IW_cw);
	R_ALU_decoder dec0_110 (instruction, R_ALU_cw);
	B_decoder dec1_000 (instruction, B_cw);
	B_cond_decoder dec1_010 (instruction, status[3:0], B_conD_format_cw);
	BL_decoder dec1_100 (instruction, BL_cw);
	CBZ_decoder dec1_101 (instruction, status[1], CBZ_cw);
	BR_decoder dec1_110 (instruction, BR_cw);

	//2:1 mux to select between branch instructions and all others
	assign control_word = opcode[5] ? branch_cw[92:0] : other_cw[92:0];

	//8:1 mux to select between branch instructions
	assign branch_cw = opcode[10] ? (opcode[9] ? (opcode[8] ? 32'b0 : BR_cw) : (opcode [8] ? CBZ_cw : BL_cw)) : (opcode[9] ? (opcode[8] ? 32'b0 : B_conD_format_cw) : (opcode [8] ? 32'b0 : B_cw));
		/*
		000= B
		001= 0
		010= B.cond
		011= 0
		100= BL
		101= CBZ/CBNZ
		110= BR
		111= 0
		*/
		
	//8:1 mux to select between all other instructions
	assign other_cw = opcode[4] ? (opcode[3] ? (opcode[2] ? 32'b0 : R_ALU_cw) : (opcode [2] ? IW_cw : I_logic_cw)) : (opcode[3] ? (opcode[2] ? 32'b0 : I_artithmetic_cw) : (opcode [2] ? 32'b0 : D_format_cw));
		/*
		000= D
		001= 0
		010= I.Arith
		011= 0
		100= I.Logic
		101= IW
		110= R.ALU
		111= 0
		*/
		
endmodule

//decoder modules
module D_decoder (I, D_format_cw);
	input [31:0]I;
	output [93:0] D_format_cw;
	
	//CW = {K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB, FS;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	//easy stuff
	assign DA = I[4:0];
	assign SA = I[9:5];
	assign SB = I[4:0];
	assign K = {55'b0 ,I[20:12]};
	assign PS = 2'b01;
	assign dataMux = I[22] ? 2'b10 : 2'b11;
	assign FS = 5'b01000;
	assign PCsel = 1'b0;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign ramW = ~I[22];
	assign regW = I[22];
	assign NS = 1'b0;
	
	assign D_format_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};

endmodule

module I_artithmetic_decoder (I, I_artithmetic_cw);
	input [31:0]I;
	output [93:0] I_artithmetic_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB, FS;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	assign DA = I[4:0];
	assign SA = I[9:5];
	assign SB = 5'b00000;
	assign K = I[21:10];
	assign PS = 2'b01;
	assign dataMux = 2'b10;
	assign FS = {3'b0, I[30]};
	assign PCsel = 1'b0;
	assign Bsel = 1'b1;
	assign SL = 1'b0;
	assign ramW = 1'b0;
	assign regW = 1'b1;
	assign NS = 1'b0;
	
	assign I_artithmetic_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module I_logic_decoder (I, I_logic_cw);
	input [31:0]I;
	output [93:0] I_logic_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	assign DA = I[4:0];
	assign SA = I[9:5];
	assign SB = 5'b0;
	assign K = {52'b0, I[21:20]};
	assign PS = 2'b01;
	assign dataMux = 2'b00;
	assign FS[4] = 1'b0;
	assign FS[3] = I[30] & ~I[29];
	assign FS[2] = I[30] ^ I[29];
	assign FS[1] = 1'b0;
	assign FS[0] = 1'b0;
	assign PCsel = 1'b0;
	assign Bsel = 1'b1;
	assign SL = I[30] & I[29];
	assign ramW = 1'b0;
	assign regW = 1'b1;
	assign NS = 1'b0;
	
	assign I_logic_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module IW_decoder (I, state, IW_cw);
	input [31:0]I;
	input state;
	output [93:0] IW_cw;
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	//easy stuff first
	assign DA = I[4:0];
	assign SB = 5'b0;
	assign Bsel = 1'b1;
	assign PCsel = 1'b0;
	assign SL =  1'b0;
	assign dataMux = 2'b00; //EN = ALU
	assign ramW = 1'b0;
	assign regW = 1'b1;
	
	//hard ones
	wire I29_Snot;
	assign I29_Snot = I[29] & ~state;
	assign SA = I[29] ? I[4:0] : 5'd31;
	assign K = I29_Snot ? 64'hFFFFFFFFFFFF0000 : {48'b0, I[20:5]};
	assign PS = {1'b0, ~I29_Snot};
	assign FS = {2'b00, ~I29_Snot, 2'b00};
	assign NS = I29_Snot;
	
	//change cw to whatever format I was using. NS and K are best at the most significant
	assign IW_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
	
endmodule

module R_ALU_decoder(I, R_ALU_cw);
	input [31:0]I;
	output [93:0] R_ALU_cw;
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, EN, ramW, regW, NS;
	
	//easy stuff first
	assign DA = I[4:0];
	assign SA= I[9:5];
	assign SB = I[20:16];
	assign K = {58'b0,I[15:10]};
	assign PS = 2'b01;
	assign Bsel = I[22] & I[24];
	assign PCsel = 1'b0;
	assign dataMux = 2'b00; //EN = ALU
	assign ramW = 1'b0;
	assign regW = 1'b0;
	assign NS = 1'b0;
	
	//hard ones
	assign SL = (~I[24] & I[30] & I[29]) | (I[24] & I[22] & I[29]);
	assign FS[0] = I[24] & ~I[22] & I[30];
	assign FS[1] = 1'b0;
	assign FS[2] = ~I[24] & (I[30] ^ I[29]) | I[24] & I[22] & ~I[21];
	assign FS[3] = ~I[24] & I[30] & ~I[29] | I[24] & ~I[22];
	assign FS[4] = I[24] & I[22];
	
	//change cw to whatever format I was using. NS and K are best at the most significant
	assign R_ALU_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
	
endmodule

module B_decoder(I, B_cw);
	input [31:0]I;
	output [93:0] B_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB, FS;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	assign DA = 5'b0;
	assign SA = 5'b0;
	assign SB = 5'b0;
	assign K = {38'b0, I[25:0]};
	assign PS = 2'b11;
	assign dataMux = 2'b10;
	assign FS = 5'b0;
	assign PCsel = 1'b1;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign ramW = 1'b0;
	assign regW = 1'b0;
	assign NS = 1'b0;
	
	assign B_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module B_cond_decoder(I, status, B_conD_format_cw);
	input [31:0]I;
	input [3:0] status;
	output [93:0] B_conD_format_cw;
	
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, EN, ramW, regW, NS;
	
	wire Z, N, C, V;
	assign {V, C, Z, N} = status;
	
	//easy stuff first
	assign DA = 5'b0; //maybe
	assign SA = 5'b0;
	assign SB = 5'b0;
	assign K = I[23] ? {44'hFFFF_FFFF_FFF, 1'b1, I[23:5]} : {44'h0000_0000_000, 1'b0, I[23:5]};
	assign FS = 5'b0;
	assign PCsel = 1'b1;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign dataMux = 2'b00;
	assign ramW = 1'b0;
	assign regW = 1'b0;
	assign NS = 1'b0;
	//hard
	assign PS[0] = 1'b1;
	wire Zn_C, N_xnor_V, N_Xnor_V_Zn;
	assign Zn_C = ~Z & C;
	assign N_xnor_V = ~(N ^ V);
	assign N_Xnor_V_Zn = N_xnor_V & ~Z;
	assign PS[1] = I[3] ? ( I[2] ? (I[1] ? Z : C) : (I[1] ? N : V)) : ( I[2] ? (I[1] ? Zn_C : N_xnor_V) : (I[1] ? N_Xnor_V_Zn : ~I[0]));
		//8:1mux (PCmux_out, I[3:1], Z, C, N, V, Zn_C, N_xnor_V, N_Xnor_V_Zn, ~I[0])
 	
	//change cw to whatever format I was using. NS and K are best at the most significant
	assign B_conD_format_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
	
endmodule

module BL_decoder (I, BL_cw);
	input [31:0]I;
	output [93:0] BL_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	assign DA = 5'b11110;
	assign SA = 5'b0;
	assign SB = 5'b0;
	assign K = {38'b0, I[25:0]};
	assign PS = 2'b11;
	assign dataMux = 2'b10;
	assign FS = 5'b0;
	assign PCsel = 1'b1;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign ramW = 1'b0;
	assign regW = 1'b1;
	assign NS = 1'b0;
	
	assign BL_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module CBZ_decoder (I, Z, CBZ_cw);
	input [31:0]I;
	input Z;
	output [93:0] CBZ_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	assign DA = 5'b0;
	assign SA = I[4:0];
	assign SB = 5'b11111;
	assign K = I[23:5];
	assign PS[1] = Z ^ I[24];
	assign PS[0] = 1'b1;
	assign dataMux = 2'b00; //dont care
	assign FS = 5'b00100;
	assign PCsel = 1'b1;
	assign Bsel = 1'b0;
	assign SL = 1'b1;
	assign ramW = 1'b0;
	assign regW = 1'b0;
	assign NS = 1'b0;
	
	assign CBZ_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module BR_decoder (I, BR_cw);
	input [31:0]I;
	output [93:0] BR_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, regW, NS;
	
	assign DA = 5'b0;
	assign SA = I[4:0];
	assign SB = 5'b0; 
	assign K =  64'b0;
	assign PS = 2'b10;
	assign dataMux = 2'b00;
	assign FS = 5'b0;
	assign PCsel = 1'b0;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign ramW = 1'b0;
	assign regW = 1'b0;
	assign NS = 1'b0;
	
	assign BR_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule
