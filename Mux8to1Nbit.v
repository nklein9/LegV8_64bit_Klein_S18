//Nicholas Klein
//Last Edit Feb 19, 2018
module Mux8to1Nbit (I0, I1, I2, I3, I4, I5, I6, I7, S, F);
	parameter N = 64;
	input [N-1:0] I0, I1, I2, I3, I4, I5, I6, I7;
	input [2:0] S; //select
			/*
			000 and
			001 or
			010 add
			011 XOR
			100 shift left
			101 shift right
			110 not used
			111 not used
			*/
	output [N-1:0] F;
	
assign F = S[2] ? (S[1] ? (S[0] ? I7 : I6) : (S[0] ? I5 : I4)) : (S[1] ? (S[0] ? I3 : I2) : (S[0] ? I1 : I0));

endmodule
