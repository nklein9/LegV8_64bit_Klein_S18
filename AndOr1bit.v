module AndOr1bit (a, b, S, f);
	input a, b;
	input S;
	output f;
	
	wire aandb, aorb;
	
	assign aandb = a & b;
	assign aorb = a + b;
	
	assign f = S ? aorb : aandb;
	
endmodule
