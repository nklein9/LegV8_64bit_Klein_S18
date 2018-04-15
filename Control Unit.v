//Nicholas Klein
//Last edit April 9, 2018

`define CW_BITS 93; //check when you get a cw
//CW = {K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA}
module controlUnit (control_word, literal, instruction, status, reset, clock);
	input [31:0] instruction;
								//registered, instant
	input [4:0] status; // V, C, N, Z
	input reset, clock
	output [`CW_BITS-1:0] control_word;
	output [63:0] literal;

	wire [10:0] opcode;

	assign opcode - instruction[31:21];

	//partial control words
	wire [`CW_BITS:0] branch_cw, other_cw;
	wire [`CW_BITS:0] D_format_cw, I_artithmetic_cw, I_logic_cw, IW_cw, R_ALU_cw;
	wire [`CW_BITS:0] B_cw, B_cond_cw, BL_cw, CBZ_cw, BR_cw;

	//state logic
	wire NS;
	reg state;
	always @ (posedge clock or posedge reset) begin
		if (reset)
			state <= 1'b0;
		else
			state <= NS;
	end

	//partial control unit decoders
	D_decoder dec0_000 (instruction, D_format_cw);
	I_artithmetic_decoder dec0_010 (instruction, I_artithmetic_cw);
	I_logic_decoder dec0_100 (instruction, I_logic_cw);
	IW_decoder dec0_101 (instruction, state, I_logic_cw);
	R_ALU_decoder dec0_110 (instruction, R_ALU_cw);
	B_decoder dec1_000 (instruction, B_cw);
	B_cond_decoder dec1_010 (instruction, status[4:1], B_cond_cw);
	BL_decoder dec1_100 (instruction, BL_cw);
	CBZ_decoder dec1_101 (instruction, status[0], CBZ_cw);
	BR_decoder dec1_110 (instruction, BR_cw);

	//2:1 mux to select between branch instructions and all others
	assign control_word = opcode[5] ? branch_cw : other_cw;

	//8:1 mux to select between branch instructions
	//assign branch_cw = opcode[10:8], B_cw, 0, B_cond_cw, 0, BL_cw, CBZ_cw, BR_cw, 0;
		
	//8:1 mux to select between all other instructions
	//assign other_cw = opcode [4:2], D_format_cw, 0, I_artithmetic_cw, 0, I_logic_cw, IW_cw, R_ALU_cw, 0;
		
endmodule

//decoder modules
module D_decoder (instruction, D_format_cw);
	input [31:0]I;
	output [`CW_BITS:0] D_format_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
	//easy stuff
	assign DA = I[4:0];
	assign SA = I[9:5];
	assign SB = I[4:0];
	assign K = {55'b0 ,I[20:12]};
	assign PS = 2'b00;
	assign dataMux = I[22] ? 2b'10 : 2b'11;
	assign FS = 5'b01000;
	assign PCsel = 1'b0;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign ramW = ~I[22];
	assign regW = I[22];
	assign NS = 1b'0;
	
	assign D_format_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};

endmodule

module I_artithmetic_decoder (instruction, I_artithmetic_cw);
	input [31:0]I;
	output [`CW_BITS:0] I_artithmetic_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
	assign DA = I[4:0];
	assign SA = I[9:5];
	assign SB = 5b'00000;
	assign K = I[21:10];
	assign PS = 2'b00;
	assign dataMux = 2'b10;
	assign FS = {3'b0, I[30]};
	assign PCsel = 2'00;
	assign Bsel = 1'b1;
	assign SL = 1'b0;
	assign ramW = 1'b0;
	assign regW = 1'b1;
	assign NS = 1b'0;
	
	assign I_artithmetic_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module I_logic_decoder (instruction, I_logic_cw);
	input [31:0]I;
	output [`CW_BITS:0] I_logic_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
	assign DA = I[4:0];
	assign SA = I[9:5];
	assign SB = 5'b0;
	assign K = {52'b0, I[21:20]};
	assign PS = 2'b0;
	assign dataMux = 2'b00;
	assign FS[4] = 1'b0;
	assign FS[3] = I[30] & ~I[29];
	assign FS[2] = I[30] ^ I[29];
	assign FS[1] = 1'b0;
	assign FS[0] = 1'b0;
	assign PCsel = 2'b00;
	assign Bsel = 1'b1;
	assign SL = I[30] & I[29];
	assign ramW = 1'b0;
	assign regW = 1'b1;
	assign NS = 1'b0;
	
	assign I_logic_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module IW_decoder (instruction, state, I_logic_cw);
	input [31:0]I;
	input state;
	output [`CW_BITS:0] I_logic_cw
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
	//easy stuff first
	assign DA = I[4:0];
	assign SB = 5'b0;
	assign Bsel = 1'b1;
	assign PCsel = 1'b0;
	assign SL =  1'b0;
	assign dataMux = 2'00; //EN = ALU
	assign WM = 1'b0;
	assign WR = 1'b1;
	
	//hard ones
	wire I29_Snot;
	assign I29_Snot = I[29] & ~state;
	assign SA = I[29] ? I[4:0] : 5'd31;
	assign K = I29_Snot ? 64'hFFFFFFFFFFFF0000 : {48'b0, I[20:5]};
	assign PS = {1'b0, ~I29_Snot}
	assign FS = {2'b00, ~I29_Snot, 2'b00}
	assign NS = I29_Snot;
	
	//change cw to whatever format I was using. NS and K are best at the most significant
	assign I_logic_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
	
endmodule

module R_ALU_decoder(instruction, R_ALU_cw);
	input [31:0]I;
	output [`CW_BITS:0] R_ALU_cw;
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, EN, WM, WR, NS;
	
	//easy stuff first
	assign DA = I[4:0];
	assign SA= I[9:5];
	assign SB = I[20:16];
	assign K = {58b'0,I[15:10]}
	assign PS = 2'b01
	assign Bsel = I[22] & I[24];
	assign PCsel = 1'b0;
	assign dataMux = 2'00; //EN = ALU
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

module B_decoder(instruction, B_cw);
	input [31:0]I;
	output [`CW_BITS:0] B_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
	assign DA = 5'b0;
	assign SA = 5'b0;
	assign SB = 5'b0;
	assign K = {38'b0, I[25:0]};
	assign PS = 2'b11;
	assign dataMux = 2b'10;
	assign FS = 5'b0;
	assign PCsel = 1b'1;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign ramW = 1'b0;
	assign regW = 1'b0;
	assign NS = 1'b0;
	
	assign B_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module B_cond_decoder(instruction, status[4:1], B_cond_cw);
	input [31:0]I;
	input state;
	output [`CW_BITS:0] B_cond_cw;
	
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, EN, WM, WR, NS;
	
	wire Z, N, C, V;
	assign {V, C, N, Z} = status;
	
	//easy stuff first
	assign DA = 5'b0;
	assign SA = 5'b0;
	assign SB = 5'b0;
	assign K = {45[I[23]], I[23:5]};
	assign FS = 5'b0;
	assign PCsel = 1'b1;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign EN = //zero
	assign WM = 1'b0;
	assign WR 1'b0;
	assign NS 1'b0;
	//hard
	assign PS[0] = 1'b1;
	wire Zn_C, N_xnor_V, N_Xnor_V_Zn;
	assign Zn_C = ~Z & C;
	assign N_xnor_V = ~(N ^ V);
	assign N_Xnor_V_Zn = N_xnor_V & ~Z;
	assign PS[1] =//8:1mux (PCmux_out, I[3:1], Z, C, N, V, Zn_C, N_xnor_V, N_Xnor_V_Zn, ~I[0])
 	
	//change cw to whatever format I was using. NS and K are best at the most significant
	assign B_cond_cw =  {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
	
endmodule

module BL_decoder (instruction, BL_cw);
	input [31:0]I;
	output [`CW_BITS:0] BL_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
	assign DA = //don't know yet
	assign SA = 5'b0;
	assign SB = 5'b0;
	assign K = {38'b0, I[25:0]};
	assign PS = 2'b11;
	assign dataMux = 2b'10;
	assign FS = 5'b0;
	assign PCsel = 1b'1;
	assign Bsel = 1'b0;
	assign SL = 1'b0;
	assign ramW = 1'b0;
	assign regW = 1'b1;
	assign NS = 1'b0;
	
	assign BL_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module CBZ_decoder (instruction, status[0], CBZ_cw);
	input [31:0]I;
	output [`CW_BITS:0] B_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
	assign DA =
	assign SA =
	assign SB = 
	assign K = 
	assign PS = 
	assign dataMux = 
	assign FS =
	assign PCsel = 
	assign Bsel = 
	assign SL = 
	assign ramW = 
	assign regW = 
	assign NS = 
	
	assign B_cw = {NS, K, SL, Bsel, PCsel, ramW, regW, dataMux, PS, FS, SB, SA, DA};
endmodule

module BR_decoder (instruction, BR_cw);
	input [31:0]I;
	output [`CW_BITS:0] BR_cw;
	
	//CW = {K, Bsel, PCsel ramW, regW, dataMux, PS, FS, SB, SA, DA}
	//wires for all control signals
	wire [4:0] DA, SA, SB;
	wire [63:0] K;
	wire [1:0] PS, dataMux;
	wire [4:0] FS;
	wire PCsel, Bsel, SL, ramW, RegW, NS;
	
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
