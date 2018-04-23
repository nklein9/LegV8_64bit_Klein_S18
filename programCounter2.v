//Nicholas Klein
//Last Edit Mar 26, 2018
module programCounter2(PC, PC4, PS, in, reset, clock);
	output [63:0]PC;
	output [63:0]PC4;
	input [1:0]PS;
	input [63:0]in;
	input reset;
	input clock;

	wire [63:0] addOut, muxOut, regOut;
	
	RegisterNbit reg_inst (regOut, muxOut, 1'b1, reset, clock);
	
	assign PC4 = PC + 3'd4;
	assign addOut = {in[61:0], 2'b00} + PC4;
	assign muxOut = PS[1] ? (PS[0] ? addOut : in) : (PS[0] ? PC4 : regOut);
		//00: PC<=PC
		//01: PC<=PC4
		//10: PC<=in
		//11: PC<=PC4+in*4
	assign PC = regOut;
	
endmodule