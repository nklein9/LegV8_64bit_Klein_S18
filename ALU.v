//Nicholas Klein
//Last Edit Feb 19, 2018
module ALU(F, status, A, B, FS);
	output [63:0] F;
	output [3:0] status;
		/*
		V(overflow)= ~(A[63]^B[63]) & (A[63]^F[63])
		C(out) =
		Z(ero) = ~(F[63]...F[0])
		N(egative) = F[63]
		*/
	input [63:0] A, B;
	input [4:0] FS;
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
	wire [63:0] Avalue, Bvalue, aandb, aorb, sum, axorb, sleft, sright;
	wire V, C, Z, N;
	assign status = {V, C, Z, N};
	
	assign Avalue = FS[1] ? ~A : A;
	assign Bvalue = FS[0] ? ~B : B;
	assign aandb = Avalue & Bvalue;
	assign aorb = Avalue | Bvalue;
	Adder add_inst (sum, C, Avalue, Bvalue, FS[0]);
	assign axorb = Avalue^Bvalue;
	Shifter shift_inst (A, B[5:0], sleft, sright);
	Mux8to1Nbit ALU_Mux(aandb, aorb, sum, axorb, sleft, sright, 64'b0, 64'b0, FS[4:2], F);
	
	assign N = F[63];
	assign Z = (F == 64'b0) ? 1'b1 : 1'b0;
	assign V =  ~(A[63]^B[63]) & (A[63]^F[63]);
	
	defparam ALU_Mux.N = 64;
	
endmodule


module Shifter (A, shift_amt, left, right);
	input [63:0] A;
	input [5:0] shift_amt;
	output [63:0] left, right;
	
	assign left = A << shift_amt;
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
