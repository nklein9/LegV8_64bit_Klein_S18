module Datapath_Testbench();
	
	/*
		Created by David Russo
		Last Edited 4/23/18
		
		The Datapath_Testbench:
		- Runs Muhlbaier's ROM case
		- 11 Lines of Code are tested
		- Instruction from the ROM is manually decoded, bypassing the Control Unit
	*/
	
	//Inputs are registers. Outputs are wires
	reg [28:0]cw;
	reg [63:0]k;
	reg reset, clock;
	wire [63:0]Databus;
	wire [3:0]Status;
	wire Zero;
	wire [31:0]I;
	
	//Design under Test
	Datapath dut(cw, k, reset, clock, Databus, Status, Zero, I);
		
	//Decoding the cw signal
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;

	assign DA = cw[4:0];
	assign SA = cw[9:5];
	assign SB = cw[14:10];
	assign FS = cw[19:15];
	assign PS = cw[21:20];
	assign enable = cw[23:22];
	assign regWrite = cw[24];
	assign memWrite = cw[25];
	assign PC_sel = cw[26];
	assign B_sel = cw[27];
	assign status_load = cw[28];
	
	//trying to pull out info from hierarchy
	wire [63:0]a, b, a2, b2, ALU_out, X1, X2, X4, X5, X6, X7, RAM_out, RAM_8, RAM_16, PC, PC4;
	wire [3:0]status_ALU;

	assign a = dut.a;
	assign b = dut.b;
	assign a2 = dut.a2;
	assign b2 = dut.b2;
	assign ALU_out = dut.ALU_out;
	assign RAM_out = dut.RAM_out;
	
	assign X1 = dut.RegisterFile_inst.R01;
	assign X2 = dut.RegisterFile_inst.R02;
	assign X4 = dut.RegisterFile_inst.R04;
	assign X5 = dut.RegisterFile_inst.R05;
	assign X6 = dut.RegisterFile_inst.R06;
	assign X7 = dut.RegisterFile_inst.R07;
	
	assign RAM_8 = dut.RAM_inst.mem[8];
	assign RAM_16 = dut.RAM_inst.mem[16];
	assign PC = dut.PC;
	assign PC4 = dut.PC4;
	assign status_ALU = dut.status_ALU;
	
		
	initial begin
		//Initialize all the inputs and outputs
		
		cw <= 29'b00001000101000111111111100001;
		k <= 64'b0;
		reset <= 1'b1;
		clock <= 1'b0;
	end
	
	always begin
		#5 clock <= ~clock; // wait 5 ticks, and then switch the clock
	end
	
	always @(negedge clock)
	begin
		#14 reset <= 1'b0;
		
		// MOVZ X1, 1
		#4
		cw <= 29'b00001000101000111111111100001;
		k <= 64'd1;		
		
		// MOVZ X2, 2
		#10
		cw <= 29'b00001000100100111111111100010;
		k <= 64'd2;
				
		// ADD X4, X1, X2
		#10
		cw <= 29'b01001000100100000100000100100;
		k <= 64'b010100000010;
		
		// STUR X4, [XZR, 16]
		#10
		cw <= 29'b00010110101000001001111111111;
		k <= 64'd16;

		// LDUR X5, [XZR, 16]
		#10
		cw <= 29'b00001010101000111111111100101;
		k <= 64'd16;
		
		// BL 10
		#10
		cw <= 29'b00001101100000111110001011111;
		k <= 64'd10;
		
		// CBNZ X2, 1
		#10
		cw <= 29'b01000101101000111110001011111;
		k <= 64'd1;
		
		// B 1
		#10
		cw <= 29'b00000101100000111111111111111;
		k <= 64'd1;
		
		// B -7
		#10
		cw <= 29'b00000101100000111111111111111;
		k <= 64'hFFFF_FFFF_FFFF_FFF9;
		
		// CBZ X1, 3
		#10
		cw <= 29'b0100010?101000111110000111111;
		k <= 64'd3;
		
		// SUBS XZR, X1, X2
		#10
		cw <= 29'b11001000101001000100000111111;
		k <= 64'd0;
		
		// There is more Code from the ROM not manually decoded and shown in this Testbench
		
		#310 reset <= 1'b0;
		#10 $stop;

	end

endmodule
