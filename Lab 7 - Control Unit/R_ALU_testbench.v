module R_ALU_testbench();
	//inputs are registers and outputs are wires
	reg [31:0]i;
	wire [93:0]CW;
	
	/*
	Testbench design:
	Ten instructions will be tested:
	1. ADD
	2. SUB
	3. ADDS
	4. SUBS
	5. AND
	6. ORR
	7. EOR
	8. ANDS
	9. LSR
	10.LSL
	Then the outputs of each will be observed
	*/
	
	// internal wires
	wire [4:0]DA, SA, SB, FS;
	wire [1:0]PS, enable;
	wire regWrite, memWrite, PC_sel, B_sel, status_load;
	wire [63:0]k;
	wire state;
	
	//initialization
	R_ALU dut(i, CW);
	
	assign DA = dut.DA;
	assign SA = dut.SA;
	assign SB = dut.SB;
	assign FS = dut.FS;
	assign PS = dut.PS;
	assign enable = dut.enable;
	assign regWrite = dut.regWrite;
	assign memWrite = dut.memWrite;
	assign PC_sel = dut.PC_sel;
	assign B_sel = dut.B_sel;
	assign status_load = dut.status_load;
	assign k = dut.k;
	assign state = dut.state;
	
	//Start of testing
	initial begin
		i <= 32'b0;
	end
	
	always begin
		#10
		i <= 32'b10001011000_00001_000000_10000_00100; // ADD instruction
		
		#10
		i <= 32'b11001011000_00011_000000_10000_00100; // SUB instruction
		
		#10
		i <= 32'b10101011000_00111_000000_10000_00100; // ADDS instruction
		
		#10
		i <= 32'b11101011000_01111_000000_10000_00100; // SUBS instruction
				
		#10
		i <= 32'b11010011010_00001_000010_10000_00100; // LSR instruction
		
		#10
		i <= 32'b11010011011_00000_000010_10000_00100; // LSL instruction
		
		#50 $stop;
	end
	

endmodule
