module ProgramCounter_Testbench();

	// I/O wires and registers
	reg [63:0]in;
	reg [1:0]PS; // 2 bit Program Select signal
	reg reset;
	reg clock;
	wire [63:0]PC;
	wire [63:0]PC4; // PC + 4 Signal

	ProgramCounter dut(in, PS, reset, clock, PC, PC4);
	
	initial begin
		in <= 64'b0;
		PS <= 2'b00;
		reset <= 1'b1;
		clock <= 1'b0;
	end
	
	always
	begin
		#5 clock <= ~clock;	
	end
	
	/*
		Functionality:
		case PS 
		00: PC <= PC
		01: PC <= PC + 4
		10: PC <= PC + 4 + in
		11: PC <= PC + 4 + in * 4
	*/

	always @(negedge clock)
	begin
		#10
		reset <= 0;		
		
		// PS = {0,0}: PC <= PC
		#10
		PS <= 2'b00;
		in <= 64'd10;
		
		
		// PS = {0,1}: PC <= PC + 4
		#10
		PS <= 2'b01;
		in <= 64'd10;
	
		// PS = {1,0}: PC <= PC + 4 + in
		#10
		PS <= 2'b10;
		in <= 64'd10;

		// PS = {1,1}: PC <= PC + 4 + in * 4
		#10
		PS <= 2'b11;
		in <= 64'd10;
		
		#10
		PS <= 2'b00;
		
		#30
		reset <= 1;
		
		#10
		$stop;
	end

endmodule
