module CPU(clock, reset, Databus);
	
	// inputs and outputs
	input clock, reset;
	output [63:0]Databus;
	
	// wires
	wire [28:0]cw;
	wire [63:0]k;
	wire [31:0]i;
	wire [3:0]status;
	wire z;
	
	// instantiations
	Datapath Datapath_inst(cw, k, reset, clock, Databus, status, z, i);
	control_unit CU_inst(i, z, status, clock, reset, cw, k);

endmodule
