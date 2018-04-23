module RippleCarryAdder(a, b, carryin, Sum, Carryout);
	
	parameter N = 64; // Default parameter of module
	
	//Inputs and Outputs
	input [N-1:0]a, b; // operands
	input carryin;     // should be 1 if performing subtraction (2's complement)
	output [N-1:0]Sum;
	output Carryout;
	
	assign {Carryout, Sum} = a + b + carryin;


endmodule
