//Nicholas Klein
//Last edit April 15, 2018

module checkAddress (ramCheck, in);
	output ramCheck;
	input [63:0] in;
	
	wire ramCheck1, ramCheck2, ramCheck3, ramCheck4, ramCheck5, ramCheck6;

	assign ramCheck1 = in[8] | in[9] | in[60] | in[61] | in[62] | in[63];
	assign ramCheck2 = in[10] | in[11] | in[12] | in[13] | in[14] | in[15] | in[16] | in[17] | in[18] | in[19];
	assign ramCheck3 = in[20] | in[21] | in[22] | in[23] | in[24] | in[25] | in[26] | in[27] | in[28] | in[29];
	assign ramCheck4 = in[30] | in[31] | in[32] | in[33] | in[34] | in[35] | in[36] | in[37] | in[38] | in[39];
	assign ramCheck5 = in[40] | in[41] | in[42] | in[43] | in[44] | in[45] | in[46] | in[47] | in[48] | in[49];
	assign ramCheck6 = in[50] | in[51] | in[52] | in[53] | in[54] | in[55] | in[56] | in[57] | in[58] | in[59];
	
	assign ramCheck = ramCheck1 | ramCheck2 | ramCheck3 | ramCheck4 | ramCheck5 | ramCheck6;
	
endmodule
