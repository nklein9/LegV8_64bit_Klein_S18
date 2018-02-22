module ALU1bit (ain, bin, cin, pass, S, f, cout, set);
	input ain, bin; //numbers to be worked on
	input cin; //carry in, 0th bit must be set to 1 if inverting, others are connected to previous
	input pass; //idk what this does, something with "set on less than"
	input [3:0] S; //select operation
		/*
		0000: or
			1100: NOR
		0001: and
		0010: arithmatic (add)
			0110: subtract a-b
			1010: subtract b-a
		0011: Set on less than
		
		NOTE: S[3] is invert A, S[2] is invert B
		*/
	output f; //result
	output cout;
	output set;  //idk what this does, something with "set on less than"
	
	wire athru, bthru;
	wire aandb, aorb, sum;
	
	assign athru = S[3] ? ain : ~ain;
	assign bthru = S[2] ? bin : ~bin;
	assign aandb = athru & bthru;
	assign aorb = athru | bthru;
	assign cout = (athru & bthru) | (bthru & cin) | (athru & cin);
	assign sum = (athru ^ bthru ^ cin) | (athru & bthru & cin);
	assign set = sum;
	
	assign f = S[1] ? ( S[0] ? pass : sum) : (S[0] ? aorb : aandb);
	
endmodule
