module CPU_Testbench();
	
	/*
		Created By David Russo
		Last Edited 4/23/18
		
		This Testbench runs Muhlbaier's ROM case	
	*/
	
	// inputs as registers and outputs as wires
	reg clock, reset;
	wire [63:0]databus;
	
	// internal wires
	wire [63:0]X1, X2, X4, X5, X6, X7, M16, M8;
	wire [31:0]I;
	wire [93:0]CW, cw_IW, cw_R_ALU, cw_D,	cw_I_arith, cw_RI_Logic, cw_BR, cw_B, cw_BL, cw_CBZ_CBNZ, cw_B_cond;
	wire [63:0]k;
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	
	// instantiations
	CPU dut(clock, reset, databus);
	assign X1 = dut.Datapath_inst.RegisterFile_inst.R01;
	assign X2 = dut.Datapath_inst.RegisterFile_inst.R02;
	assign X4 = dut.Datapath_inst.RegisterFile_inst.R04;
	assign X5 = dut.Datapath_inst.RegisterFile_inst.R05;
	assign X6 = dut.Datapath_inst.RegisterFile_inst.R06;
	assign X7 = dut.Datapath_inst.RegisterFile_inst.R07;
	assign M16 = dut.Datapath_inst.RAM_inst.mem[16];
	assign M8 = dut.Datapath_inst.RAM_inst.mem[8];
	assign I = dut.Datapath_inst.I;
	assign DA = dut.cw[4:0];
	assign SA = dut.cw[9:5];
	assign SB = dut.cw[14:10];
	assign FS = dut.cw[19:15];
	assign PS = dut.cw[21:20];
	assign enable = dut.cw[23:22];
	assign regWrite = dut.cw[24];
	assign memWrite = dut.cw[25];
	assign PC_sel = dut.cw[26];
	assign B_sel = dut.cw[27];
	assign status_load = dut.cw[28];
	assign k = dut.k;
	assign CW = dut.CU_inst.CW;
	assign cw_IW = dut.CU_inst.cw_IW;
	assign cw_R_ALU = dut.CU_inst.cw_R_ALU;
	assign cw_D = dut.CU_inst.cw_D;
	assign cw_I_arith = dut.CU_inst.cw_I_arith;
	assign cw_RI_Logic = dut.CU_inst.cw_RI_Logic;
	assign cw_BR = dut.CU_inst.cw_BR;
	assign cw_B = dut.CU_inst.cw_B;
	assign cw_BL = dut.CU_inst.cw_BL;
	assign cw_CBZ_CBNZ = dut.CU_inst.cw_CBZ_CBNZ;
	assign cw_B_cond = dut.CU_inst.cw_B_cond;
	
	initial begin
		clock <= 1'b1;
		reset <= 1'b1;
	end
	
	always begin
		#5 clock <= ~clock;
	end
	always begin
		#4 reset <= 0;
		#5000 $stop;
	end	
	
endmodule
