//Nicholas Klein
//Last Edit April 21, 2018
module complete_datapath_testbench ();
	wire [63:0] data; //datapath
	wire [63:0] address;
	wire regW;
	wire EN_MEM;
	reg [63:0] datain;
	reg reset;
	reg clock;
	
	//Pulled for showcase
	wire [63:0] X1, X2, X3, X4, X5, X6, X7, M16, M8;
	assign X1 = dut.reg_inst.reg1.Q;
	assign X2 = dut.reg_inst.reg2.Q;
	assign X3 = dut.reg_inst.reg3.Q;
	assign X4 = dut.reg_inst.reg4.Q;
	assign X5 = dut.reg_inst.reg5.Q;
	assign X6 = dut.reg_inst.reg6.Q;
	assign X7 = dut.reg_inst.reg7.Q;
	assign M16 = dut.ram_inst.mem[16];
	assign M8 = dut.ram_inst.mem[8];
	
	//pulled for error checking
	wire [92:0] CW;
	wire [63:0] datadut, aluOut;
	wire [31:0] instruction;
	wire [4:0] FS_CW, SB_CW, SA_CW, DA_CW;
	//wire [3:0] cuStatusCheck;
	wire [1:0] dataMux_CW, PS_CW;
	wire SL_CW, Bsel_CW, PCsel_CW, ramW_CW, regW_CW;
	/*
	wire [92:0] cuCWCheck;
	wire [63:0] pcCheck, pcdutCheck, pc4Check, a_check, b1_check, b2_check, k_CW;
	wire [31:0] cuInstructionCheck;
	wire [1:0] psCheck;
	wire cuResetCheck, cuClockCheck;
	*/
	assign CW = dut.CW;
	assign datadut = dut.data;
	assign aluOut = dut.aluOut;
	assign instruction = dut.instruction;
	
	/*
	assign pcdutCheck = dut.PC;
	assign pcCheck = dut.pc_inst.PC;
	assign pc4Check = dut.pc_inst.PC4;
	assign psCheck = dut.pc_inst.PS;
	assign PCinCheck = dut.pc_inst.in;
	assign pcResetCheck = dut.pc_inst.reset;
	assign pcClockCheck = dut.pc_inst.clock;
	assign cuCWCheck = dut.CU_inst.control_word;
	assign cuInstructionCheck = dut.CU_inst.instruction;
	assign cuStatusCheck = dut.CU_inst.status;
	assign cuResetCheck = dut.CU_inst.reset;
	assign cuClockCheck = dut.CU_inst.clock;
	*/
	assign a_check = dut.A;
	assign b1_check = dut.B1;
	assign b2_check = dut.B2;
	
	
	assign k_CW = CW[92:29];
	assign SL_CW = CW[28];
	assign Bsel_CW = CW[27];
	assign PCsel_CW = CW[26];
	assign ramW_CW = CW[25];
	assign regW_CW = CW[24];
	assign dataMux_CW = CW[23:22];
	/*
		00: aluOut
		01: ramOut
		10: PC4
		11: B1 (Was GND)
	*/
	assign PS_CW = CW[21:20];
	/*
		00: PC<=PC
		01: PC<=PC4
		10: PC<=in
		11: PC<=PC4+in*4
	*/
	assign FS_CW = CW[19:15];
	/*
		FS0 B invert
		FS1 A invert
		FS4:2 operation select
			000 and
			001 or
			010 add
			011 XOR
			100 shift left
			101 shift right
			110 not used
			111 not used
	*/
	assign SB_CW = CW[14:10];
	assign SA_CW = CW[9:5];
	assign DA_CW = CW[4:0];
	
	datapath dut (data, address, regW, EN_MEM, datain, clock, reset);
	
	initial begin
		clock <= 1'b1;
		reset <= 1'b1;
		datain <= 64'b0;
		#7
		reset <= 1'b0;

		#250 $stop;
	end
	
	//clock cycle
	always begin
		#5
		clock <= ~clock;
	end
	
endmodule
