module RegisterNbit(Q, D, load, reset, clock);
	/*
		Created by David Russo
		Last Edited 4/21/18 (Comments only)
		
		RegisterNbit:
		- is instantiated in the Register File 31 times
		- is instantiated in the Datapath as a 4-bit status_reg
		- is instantiated in the Program Counter (64-bit PC_reg)
		- Loads on the positive edge clock
		- Asynchronous positive edge reset
		- The load signal determines whether the value stored in the register updates or not
	*/
	
	parameter N = 64; // Default parameter of module
	
	// inputs and outputs	
	input load;  // Positive logic: 1 is active, 0 is inactive
	input reset; // asynchonous positive logic reset
	input clock; // Positive edge
	input [N-1:0]D; // data input of size N
	output reg [N-1:0]Q;
	
	// implementation
	always @(posedge clock or posedge reset) begin
		if(reset)
			Q <= 0;
		else if(load)
			Q <= D;
		else
			Q <= Q;
	end
	
endmodule
	