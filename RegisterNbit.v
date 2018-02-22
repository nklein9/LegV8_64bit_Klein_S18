//Nicholas Klein
//Last Edit Feb 19, 2018
module RegisterNbit(Q, D, load, reset, clock);
	parameter N = 64; //default 64bit
	input load; //pos logic
	input reset; //async positive logic
	input clock; //pos edge
	input [N-1:0] D; //data input
	output reg [N-1:0] Q; // 
	
	always @ (posedge clock or posedge reset) begin
		if (reset)
			Q <= 0;
		else if (load)
			Q <= D;
		else
			Q <= Q;
	end
	
endmodule
