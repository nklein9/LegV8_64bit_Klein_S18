//Nicholas Klein
//Last Edit Feb 19, 2018
module datapath_Testbench ();
	wire [63:0] data;
	wire [3:0] status;
	reg clock;
	reg [63:0] k; //constant
	reg [4:0] DA, SA, SB, FS;
	reg dataMux, regW, ramW, R, Bsel;
	
	//trying to pull out info from hierarchy
	wire [63:0]A, B1, B2, aluOut, ramOut, ramOut0, ramOut1, ramOut2, ramOut3, ramOut4, ramOut5;
	assign A = dut.A;
	assign B1 = dut.B1;
	assign B2 = dut.B2;
	assign aluOut = dut.aluOut;
	assign ramOut = dut.ramOut;
	assign ramOut0= dut.ram_inst.mem[0];
	assign ramOut1= dut.ram_inst.mem[1];
	assign ramOut2= dut.ram_inst.mem[2];
	assign ramOut3= dut.ram_inst.mem[3];
	assign ramOut4= dut.ram_inst.mem[4];
	assign ramOut5= dut.ram_inst.mem[5];
	
	datapath dut (data, status, clock, k, DA, SA, SB, FS, dataMux, regW, ramW, R, Bsel);
	
	initial begin
		//setup
		clock <= 1'b1;
		k <= 64'b0;
		DA <= 5'b0;
		SA <= 5'b0;
		SB <= 5'b0;
		FS <= 5'b0;
		dataMux <= 1'b0;
		regW <= 1'b0;
		ramW <= 1'b0;
		R <= 1'b1;
		Bsel <= 1'b0;

		#250 $stop;
	end
	
	//clock cycle
	always begin
		#5
		clock <= ~clock;
	end
	
	//reg setup
	always begin
		#10
		if (DA<=64'd5) begin
			#10
			k <= k+1'b1;
			DA <= DA+1'b1;
			SA <= 5'b0;
			SB <= SB+1'b0;
			FS <= 5'b00100;
			regW <= 1'b1;
			ramW <= 1'b1;
			R <= 1'b0;
		end else begin
		//add test
			if (DA<=64'd6) begin
				#10
				//k <= 64'b0;
				//DA <= 5'b0;
				SA <= 5'b00001;
				SB <= 5'b00010;
				FS <= 5'b01000;
				//dataMux <= 1'b0;
				//regW <= 1'b0;
				ramW <= 1'b0;
				//R <= 1'b0;
				Bsel <= 1'b1;
				#10
				DA <= DA+1'b1;
			end else begin
			//shift test
				#10
				//k <= 64'b0;
				//DA <= 5'b0;
				SA <= 5'b00011;
				SB <= 5'b00100;
				FS <= 5'b10000;
				//dataMux <= 1'b0;
				//regW <= 1'b0;
				//ramW <= 1'b0;
				//R <= 1'b0;
				Bsel <= 1'b1;
				/*if () begin
					#10
					k <= 64'b0;
					DA <= 5'b0;
					SA <= 5'b00000;
					SB <= 5'b00010;
					FS <= 5'b10000;
					//dataMux <= 1'b0;
					//regW <= 1'b0;
					ramW <= 1'b1;
					//R <= 1'b0;
					Bsel <= 1'b0;
				end*/
			end
		end
	end
	
	always begin
		#5 if(B1 != ramOut) $display("time: %d, k: %d, DA: %d, SA: %d, SB: %d, FS: %d, dataMux: %d, regW: %d, ramW: %d, R: %d, Bsel: %d, A: %d, B1: %d, B2: %d, aluOut: %d, ramOut: %d", $time, k, DA, SA, SB, FS, dataMux, regW, ramW, R, Bsel, A, B1, B2, aluOut, ramOut);
	end
	
	
endmodule
