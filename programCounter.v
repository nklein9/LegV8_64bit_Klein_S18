//Nicholas Klein
//Last Edit March 26, 2018
module programCounter(PC, PC4, PS, in, reset, clock);
	output [63:0]PC;
	output [63:0]PC4;
	input [1:0]PS;
	input [63:0]in;
	input reset;
	input clock;

	wire [63:0] PCbus, PC4bus, mux1out, mux2out, addout;
	wire regload;
	
	RegisterNbit reg_inst (PCbus, mux2out, regload, reset, clock);
	
	assign mux1out = PS[0] ? {in[61:0], 2'b00} : in;
	assign PC4bus = PCbus + 3'b100;
	assign PC4 = PC4bus;
	assign addout = PC4 + mux1out;
	assign mux2out = PS[1] ? addout : PC4bus;
	assign regload = PS[0] | PS[1];
	assign PC = PCbus;
	
endmodule
