module CPU(data_in, clock, reset, Databus, Write);
	/*
		Created by David Russo
		Last Edited 4/24/18
		
		The CPU:
		- instantiates the control unit and the datapath
		- has a clock and reset
		- has a 64-bit data_in signal in order to get data from peripherals
		- outputs the 64-bit Databus and 1-bit Write back to peripherals
		- currently run's Muhlbiaer's ROM case
	*/
	
	// inputs and outputs
	input [63:0]data_in; // from peripherals
	input clock, reset;
	output [63:0]Databus;
	output Write;
	
	// wires
	wire [28:0]cw;
	wire [63:0]k;
	wire [31:0]i;
	wire [3:0]status;
	wire z;
	
	// instantiations
	Datapath Datapath_inst(cw, k, reset, data_in, clock, Databus, status, z, i, Write);
	control_unit CU_inst(i, z, status, clock, reset, cw, k);

endmodule
