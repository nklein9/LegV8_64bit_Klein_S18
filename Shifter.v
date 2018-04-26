module Shifter (a, b, Left, Right); // need to make the 4 to 1 mux to an 8:1 mux
	//inputs and outputs
	input [63:0]a;
	input [5:0]b; // shift amount
	output [63:0]Left, Right;
	
	// Logic
	assign Left = a << b;
	assign Right = a >> b;

endmodule
