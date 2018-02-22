module Shifter (A, shift_amt, left, right);
	input [63:0] A;
	input [5:0] shift_amt;
	output [63:0] left, right;
	
	assign left = A << shift shift_amt;
	assign right = A >> shift_amt;
	
endmodule

module Adder (F, Cout, A, B, Cin);
	input [63:0] A, B;
	input Cin;
	output [63:0] F;
	output Cout;
	
	assign {Cout, F} = A + B + Cin;
	
endmodule

/* have one already
module Mux8to1Nbit (F, S, I0, I1, I2, I3, I4, I5, I6, I7);
	parameter N = 8;
	input [N-1:0]  I0, I1, I2, I3, I4, I5, I6, I7;
	input [2:0] S;
	output [N-1:0] F;
	
	assign F = S[2] ? (S[1] ? (S[0] ? I7 : I6) : (S[0] ? I5 : I4)) : (S[1] ? (S[0] ? I3 : I2) : (S[0] ? I1 : I0));

endmodule
*/
