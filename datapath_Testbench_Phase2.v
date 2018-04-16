//Nicholas Klein
//Last Edit April 1, 2018
module datapath_Testbench_Phase2 ();
	wire [63:0] data;
	wire [3:0] status;
	wire [31:0] iToCU;
	reg clock;
	reg [63:0] k; //constant
	reg [4:0] DA, SA, SB, FS;
	reg [3:0] PS;
	reg [1:0]dataMux;
	reg regW, ramW, R, PCsel, Bsel;
	
	datapath dut (data, status, iToCU, clock, k, DA, SA, SB, FS, PS, dataMux, regW, ramW, R, PCsel, Bsel);
	
	initial begin
		//setup
		clock <= 1'b1;
		k <= 64'b0;
		DA <= 5'b0;
		SA <= 5'b0;
		SB <= 5'b0;
		FS <= 5'b0;
		PS <= 4'b0;
		dataMux <= 2'b0;
		regW <= 1'b0;
		ramW <= 1'b0;
		R <= 1'b1;
		PCsel <= 1'b1;
		Bsel <= 1'b1;

		#2000 $stop;
	end 

	//clock cycle
	always begin
		#5
		clock <= ~clock;
	end
	
	//reg setup 
	always begin
		#10
		if (DA<=30'd5) begin
			#10
			k <= k+1'b1;
			DA <= DA+1'b1;
			SA <= 5'b0;
			SB <= SB+1'b0;
			FS <= 5'b00100;
			PS <= 4'b0;
			regW <= 1'b1;
			ramW <= 1'b1;
			R <= 1'b0;
		end else begin
		//add test
			#10
			//k <= 64'b0;
			DA <= 5'b00111;
			SA <= 5'b00001;
			SB <= 5'b00010;
			FS <= 5'b01000;
			//PS <= 4'b0;
			//dataMux <= 2'b00;
			//regW <= 1'b0;
			ramW <= 1'b0;
			//R <= 1'b0;
			//PCsel <= 1'b0;
			Bsel <= 1'b0;
			#10
			regW <= 1'b0;
			#30
		//shift test
			#10
			//k <= 64'b0;
			DA <= 5'b01000;
			SA <= 5'b00011;
			SB <= 5'b00100;
			FS <= 5'b10000;
			//PS <= 4'b0;
			//dataMux <= 2'b00;
			regW <= 1'b1;
			//ramW <= 1'b0;
			//R <= 1'b0;
			//PCsel <= 1'b0;
			Bsel <= 1'b0;
			#10
			regW <= 1'b0;
			#30
		//send address to PC	& store PC4			****THIS IS WHAT YOURE WORKING ON- IF STATEMENT INCRIMENTING SO YOU CAN GO THRU PC FUNCTIONS
			#10
			k <= 64'd0;
			DA <= 5'b01001;
			//SA <= 5'b00001;
			//SB <= 5'b00010;
			//FS <= 5'b01000;
			PS <= 4'b0;
			dataMux <= 2'b10;
			regW <= 1'b1;
			//ramW <= 1'b0;
			//R <= 1'b0;
			PCsel <= 1'b1;
			//Bsel <= 1'b1;
			#10
			regW <= 1'b0;
			if (k<=5'd28) begin
				k <= k+2'b10;
				DA <= 5'b01001;
				//SA <= 5'b00001;
				//SB <= 5'b00010;
				//FS <= 5'b01000;
				//PS <= 4'b0;
				dataMux <= 2'b10;
				regW <= 1'b1;
				//ramW <= 1'b0;
				//R <= 1'b0;
				PCsel <= 1'b1;
				//Bsel <= 1'b1;
				#10
				regW <= 1'b0;
			end
			//#30
			//changing PS to see if instructions change
			//#10
		end
	end
endmodule
