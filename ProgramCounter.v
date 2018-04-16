module ProgramCounter(PC, PC4, PS, in, reset, clock);
	output [63:0]PC;
	output [63:0]PC4;
	input [1:0]PS;
	input [63:0]in;
	input reset;
	input clock;
//addout = 11, in = 01, PC4 = 10, regOut = 00
//RegisterNbit (Q, D, load, reset, clock);
	wire [63:0] addOut, muxOut, regOut;
	
	RegisterNbit reg_inst (regOut, muxOut, 1'b1, reset, clock);
	
	assign PC4 = PC + 3'd4;
	assign addOut = {in[61:0], 2'b00} + PC4;
	assign muxOut = PS[0] ? (PS[1] ? addOut : in) : (PS[1] ? PC4 : regOut);
	assign PC = regOut;
	
endmodule
