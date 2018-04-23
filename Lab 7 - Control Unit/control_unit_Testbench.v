module control_unit_Testbench();
/*
	Created by David Russo
	Last edited 4/20/2018
	
	Testbench design:
	- This Testbench iterates though 10 different instructions.
	- It checks to see if the Control Word coming out of the correct mux is the same as the Control Word coming out
	
	
*/
	
	//inputs are registers and outputs are wires
	reg [31:0]i;
	reg z;
	reg [3:0]status;
	reg clock;
	reg reset;
	wire [28:0]ControlWord;
	wire [63:0]K;
	
	// internal wires
	wire state, p_state; // state bits for MOVK
	wire [10:0]Op; // assumes a general 11-bit Op code to use for mux selects
	wire [93:0]CW; // internal controlWord
	
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [93:0]cw_D, cw_I_arith, cw_RI_Logic, cw_IW, cw_R_ALU, cw_B, cw_B_cond, cw_BL, cw_CBZ_CBNZ, cw_BR, cw_ALU, cw_branch; // control words

	reg [93:0]CW_exp; // expected control word
	
	//initialization
	control_unit dut(i, z, status, clock, reset, ControlWord, K);
	
	assign Op = i[31:21];
	assign cw_D = dut.D_dec.CW;
	assign cw_I_arith = dut.I_arith_dec.CW;
	assign cw_RI_Logic = dut.RI_Logic_dec.CW;
	assign cw_IW = dut.IW_dec.CW;
	assign cw_R_ALU = dut.R_ALU_dec.CW;
	assign cw_B = dut.B_dec.CW;
	assign cw_B_cond = dut.B_cond_dec.CW;
	assign cw_BL = dut.BL_dec.CW;
	assign cw_CBZ_CBNZ = dut.CBZ_CBNZ_dec.CW;
	assign cw_BR = dut.BR_dec.CW;
	
	assign DA = ControlWord[4:0];
	assign SA = ControlWord[9:5];
	assign SB = ControlWord[14:10];
	assign FS = ControlWord[19:15];
	assign PS = ControlWord[21:21];
	assign enable = ControlWord[23:22];
	assign regWrite = ControlWord[24];
	assign memWrite = ControlWord[25];
	assign PC_sel = ControlWord[26];
	assign B_sel = ControlWord[27];
	assign status_load = ControlWord[28];
	assign state = dut.state;
	assign p_state = dut.p_state;
	assign cw_ALU = dut.cw_ALU;
	assign cw_branch = dut.cw_branch;
//	assign CW = {state, K, ControlWord};
	assign CW = dut.CW;
		
	//Start of testing
	initial begin
		i <= 32'b01010100_1000000000000000001_00000;
		status = 4'b0000;
		z <= 1'b0;
		clock <= 1'b0;
		reset <= 1'b1;
		#4 reset <= 1'b0;
		
	#5000 $stop;
	end
	
	always begin
		#5 clock <= ~clock;
	end
	
	always @(negedge clock) begin
		# 10
		i <= 32'b1001000100_000000000001_00000_00001; // ADDI from I_arith
		//status <= 4'b0000;
		//z <= 0;
		#5
		if(ControlWord != cw_I_arith[28:0])
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, ControlWord: %d, cw_I_arith[28:0]: %d", $time, i[31:21], status, z, ControlWord, cw_I_arith[28:0]);
		end
		
		#5
		i <= 32'b1001001000_000000000001_00000_00001; // ANDI from RI_Logic
		//status <= 4'b0000;
		//z <= 0;
		#5
		if(ControlWord != cw_RI_Logic[28:0])
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, ControlWord: %d, cw_RI_Logic[28:0]: %d", $time, i[31:21], status, z, ControlWord, cw_RI_Logic[28:0]);
		end

		#5
		i <= 32'b10001011000_00001_000000_10000_00100; // ADD from R_ALU
		//status <= 4'b0000;
		//z <= 0;
		#5
		if(CW != cw_R_ALU)
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, cw_R_ALU: %d", $time, i[31:21], status, z, CW, cw_R_ALU);
		end
		
		#5
		i <= 32'b11111000000_000000001_00_10000_00100; // STUR from D
		//status <= 4'b0000;
		//z <= 0;
		#5
		if(CW != cw_D)
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, cw_D: %d", $time, i[31:21], status, z, CW, cw_D);
		end
		
		#5
		i <= 32'b111100101_10_1111111111111111_00001; // MOVK from IW (2 clock cycles)
		//status <= 4'b0000;
		//z <= 0;
		#5
		if(CW != cw_IW)
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, cw_IW: %d", $time, i[31:21], status, z, CW, cw_IW);
		end
		
		#5
		i <= 32'b11010110000_11111_000000_00001_00000; // BR from BR
		//status <= 4'b0000;
		//z <= 0;
		#5
		if(CW != cw_BR)
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, cw_BR: %d", $time, i[31:21], status, z, CW, cw_BR);
		end		
		
		#5
		i <= 32'b000101_00000000000000000000000100; // B from B
		//status <= 4'b0000;
		//z <= 0;
		#5
		if(CW != cw_B)
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, cw_B: %d", $time, i[31:21], status, z, CW, cw_B);
		end

		#5
		i <= 32'b10110100_1010101010101010101_00000; // CBZ from CBZ_CBNZ
		//status <= 4'b0000;
		z = 1'b1;
		#5
		if(CW != cw_CBZ_CBNZ)
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, cw_CBZ_CBNZ: %d", $time, i[31:21], status, z, CW, cw_CBZ_CBNZ);
		end
		
		#5
		i <= 32'b01010100_1000000000000000001_00000; // B_cond from B_cond
		status <= 4'b0010; // EQ = Z
		z <= 1'b0;
		#5
		if(CW != cw_B_cond)
		begin
			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, cw_B_cond: %d", $time, i[31:21], status, z, CW, cw_B_cond);
		end
		
		#50 $stop;
		
	end
//	always begin
//		#10
//		if(CW != CW_exp)
//		begin
//			$display("time: %d, i[31:21]: %d, status: %d, z: %d, CW: %d, CW_exp: %d", $time, i[31:21], status, z, CW, CW_exp);
//		end
//	end

endmodule

