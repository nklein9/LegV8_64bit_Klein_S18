module ALU64bit (ain, bin, cin, pass, S, f, cout, set, zero, overflow);
	input [63:0] ain, bin; //numbers to be worked on
	input [63:0] cin; //carry in, 0th bit must be set to 1 if inverting, others are connected to previous
	input [63:0] pass; //idk what this does
	input [3:0] S; //select operation
		//00: and, 01: or, 10: arithmatic, 11: Compare and Branch Zero
		//NOTE: S[3] is invert A, S[2] is invert B
	output [63:0] f; //individual results
	output [63:0] cout;
	output [63:0] set;  //idk what this does
	output zero; //checks for all zero result
	output overflow; //idk what this does. NOT YET IMPLIMENTED!!!
	
	wire inv; //adds one to 0th bit when subtracting
	assign inv = S[3] ^ S[2];
	
	wire checkZero;
	assign checkZero = (f[0] | f[1] | f[2] | f[3] | f[4] | f[5] | f[6] | f[7] | f[8] | f[9] |
						f[10] | f[11] | f[12] | f[13] | f[14] | f[15] | f[16] | f[17] | f[18] | f[19] |
						f[20] | f[21] | f[22] | f[23] | f[24] | f[25] | f[26] | f[27] | f[28] | f[29] |
						f[30] | f[31] | f[32] | f[33] | f[34] | f[35] | f[36] | f[37] | f[38] | f[39] |
						f[40] | f[41] | f[42] | f[43] | f[44] | f[45] | f[46] | f[47] | f[48] | f[49] |
						f[50] | f[51] | f[52] | f[53] | f[54] | f[55] | f[56] | f[57] | f[58] | f[59] |
						f[60] | f[61] | f[62] | f[63]);
	assign zero = ~checkZero;
	
	ALU1bit ALU00 (ain[0], bin[0], inv, set[63], S, f[0], cout[0], set[0]);
	ALU1bit ALU01 (ain[1], bin[1], cout[0], 0, S, f[1], cout[1], set[1]);
	ALU1bit ALU02 (ain[2], bin[2], cout[1], 0, S, f[2], cout[2], set[2]);
	ALU1bit ALU03 (ain[3], bin[3], cout[2], 0, S, f[3], cout[3], set[3]);
	ALU1bit ALU04 (ain[4], bin[4], cout[3], 0, S, f[4], cout[4], set[4]);
	ALU1bit ALU05 (ain[5], bin[5], cout[4], 0, S, f[5], cout[5], set[5]);
	ALU1bit ALU06 (ain[6], bin[6], cout[5], 0, S, f[6], cout[6], set[6]);
	ALU1bit ALU07 (ain[7], bin[7], cout[6], 0, S, f[7], cout[7], set[7]);
	ALU1bit ALU08 (ain[8], bin[8], cout[7], 0, S, f[8], cout[8], set[8]);
	ALU1bit ALU09 (ain[9], bin[9], cout[8], 0, S, f[9], cout[9], set[9]);
	ALU1bit ALU10 (ain[10], bin[10], cout[9], 0, S, f[10], cout[10], set[10]);
	ALU1bit ALU11 (ain[11], bin[11], cout[10], 0, S, f[11], cout[11], set[11]);
	ALU1bit ALU12 (ain[12], bin[12], cout[11], 0, S, f[12], cout[12], set[12]);
	ALU1bit ALU13 (ain[13], bin[13], cout[12], 0, S, f[13], cout[13], set[13]);
	ALU1bit ALU14 (ain[14], bin[14], cout[13], 0, S, f[14], cout[14], set[14]);
	ALU1bit ALU15 (ain[15], bin[15], cout[14], 0, S, f[15], cout[15], set[15]);
	ALU1bit ALU16 (ain[16], bin[16], cout[15], 0, S, f[16], cout[16], set[16]);
	ALU1bit ALU17 (ain[17], bin[17], cout[16], 0, S, f[17], cout[17], set[17]);
	ALU1bit ALU18 (ain[18], bin[18], cout[17], 0, S, f[18], cout[18], set[18]);
	ALU1bit ALU19 (ain[19], bin[19], cout[18], 0, S, f[19], cout[19], set[19]);
	ALU1bit ALU20 (ain[20], bin[20], cout[19], 0, S, f[20], cout[20], set[20]);
	ALU1bit ALU21 (ain[21], bin[21], cout[20], 0, S, f[21], cout[21], set[21]);
	ALU1bit ALU22 (ain[22], bin[22], cout[21], 0, S, f[22], cout[22], set[22]);
	ALU1bit ALU23 (ain[23], bin[23], cout[22], 0, S, f[23], cout[23], set[23]);
	ALU1bit ALU24 (ain[24], bin[24], cout[23], 0, S, f[24], cout[24], set[24]);
	ALU1bit ALU25 (ain[25], bin[25], cout[24], 0, S, f[25], cout[25], set[25]);
	ALU1bit ALU26 (ain[26], bin[26], cout[25], 0, S, f[26], cout[26], set[26]);
	ALU1bit ALU27 (ain[27], bin[27], cout[26], 0, S, f[27], cout[27], set[27]);
	ALU1bit ALU28 (ain[28], bin[28], cout[27], 0, S, f[28], cout[28], set[28]);
	ALU1bit ALU29 (ain[29], bin[29], cout[28], 0, S, f[29], cout[29], set[29]);
	ALU1bit ALU30 (ain[30], bin[30], cout[29], 0, S, f[30], cout[30], set[30]);
	ALU1bit ALU31 (ain[31], bin[31], cout[30], 0, S, f[31], cout[31], set[31]);
	ALU1bit ALU32 (ain[32], bin[32], cout[31], 0, S, f[32], cout[32], set[32]);
	ALU1bit ALU33 (ain[33], bin[33], cout[32], 0, S, f[33], cout[33], set[33]);
	ALU1bit ALU34 (ain[34], bin[34], cout[33], 0, S, f[34], cout[34], set[34]);
	ALU1bit ALU35 (ain[35], bin[35], cout[34], 0, S, f[35], cout[35], set[35]);
	ALU1bit ALU36 (ain[36], bin[36], cout[35], 0, S, f[36], cout[36], set[36]);
	ALU1bit ALU37 (ain[37], bin[37], cout[36], 0, S, f[37], cout[37], set[37]);
	ALU1bit ALU38 (ain[38], bin[38], cout[37], 0, S, f[38], cout[38], set[38]);
	ALU1bit ALU39 (ain[39], bin[39], cout[38], 0, S, f[39], cout[39], set[39]);
	ALU1bit ALU40 (ain[40], bin[40], cout[39], 0, S, f[40], cout[40], set[40]);
	ALU1bit ALU41 (ain[41], bin[41], cout[40], 0, S, f[41], cout[41], set[41]);
	ALU1bit ALU42 (ain[42], bin[42], cout[41], 0, S, f[42], cout[42], set[42]);
	ALU1bit ALU43 (ain[43], bin[43], cout[42], 0, S, f[43], cout[43], set[43]);
	ALU1bit ALU44 (ain[44], bin[44], cout[43], 0, S, f[44], cout[44], set[44]);
	ALU1bit ALU45 (ain[45], bin[45], cout[44], 0, S, f[45], cout[45], set[45]);
	ALU1bit ALU46 (ain[46], bin[46], cout[45], 0, S, f[46], cout[46], set[46]);
	ALU1bit ALU47 (ain[47], bin[47], cout[46], 0, S, f[47], cout[47], set[47]);
	ALU1bit ALU48 (ain[48], bin[48], cout[47], 0, S, f[48], cout[48], set[48]);
	ALU1bit ALU49 (ain[49], bin[49], cout[48], 0, S, f[49], cout[49], set[49]);
	ALU1bit ALU50 (ain[50], bin[50], cout[49], 0, S, f[50], cout[50], set[50]);
	ALU1bit ALU51 (ain[51], bin[51], cout[50], 0, S, f[51], cout[51], set[51]);
	ALU1bit ALU52 (ain[52], bin[52], cout[51], 0, S, f[52], cout[52], set[52]);
	ALU1bit ALU53 (ain[53], bin[53], cout[52], 0, S, f[53], cout[53], set[53]);
	ALU1bit ALU54 (ain[54], bin[54], cout[53], 0, S, f[54], cout[54], set[54]);
	ALU1bit ALU55 (ain[55], bin[55], cout[54], 0, S, f[55], cout[55], set[55]);
	ALU1bit ALU56 (ain[56], bin[56], cout[55], 0, S, f[56], cout[56], set[56]);
	ALU1bit ALU57 (ain[57], bin[57], cout[56], 0, S, f[57], cout[57], set[57]);
	ALU1bit ALU58 (ain[58], bin[58], cout[57], 0, S, f[58], cout[58], set[58]);
	ALU1bit ALU59 (ain[59], bin[59], cout[58], 0, S, f[59], cout[59], set[59]);
	ALU1bit ALU60 (ain[60], bin[60], cout[59], 0, S, f[60], cout[60], set[60]);
	ALU1bit ALU61 (ain[61], bin[61], cout[60], 0, S, f[61], cout[61], set[61]);
	ALU1bit ALU62 (ain[62], bin[62], cout[61], 0, S, f[62], cout[62], set[62]);
	ALU1bit ALU63 (ain[63], bin[63], cout[62], 0, S, f[63], cout[63], set[63]);


	/*
	wire athru, bthru;
	wire aandb, aorb, sum;
	
	assign athru = aInvert ? ain : ~ain;
	assign bthru = bInvert ? bin : ~bin;
	assign aandb = athru & bthru;
	assign aorb = athru + bthru;
	assign cout = (athru & bthru) + (bthru & cin) + (athru + cin);
	assign sum = (athru ^ bthru ^ cin) + (athru & bthru & cin);
	assign set = sum;
	
	assign f = S[1] ? ( S[0] ? pass : sum) : (S[0] ? aandb : aorb);
	*/
	
endmodule