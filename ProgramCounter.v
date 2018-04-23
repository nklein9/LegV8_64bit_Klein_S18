module ProgramCounter(in, PS, reset, clock, PC, PC4);
	// I/O
	input [63:0]in;
	input [1:0]PS;
	input clock, reset;
	output [63:0]PC, PC4;
	
	//wires
	wire [63:0]in2, in3, PC_mux_out;
	wire Cout_0, Cout_1;
	
	//Logic
	assign in2 = in << 2;
	assign PC_mux_out = PS[1] ? (PS[0] ? in3 : in) : (PS[0] ? PC4 : PC);
	
	//instantiations
	RippleCarryAdder PC_RCA_0(PC, 64'd4, 1'd0, PC4, Cout_0);
	RippleCarryAdder PC_RCA_1(PC4, in2, 1'b0, in3, Cout_1);
	RegisterNbit PC_reg(PC, PC_mux_out, 1'b1, reset, clock);
	
endmodule
