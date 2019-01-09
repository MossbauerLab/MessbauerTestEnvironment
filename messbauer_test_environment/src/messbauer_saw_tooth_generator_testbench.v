`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:51:39 01/09/2019
// Design Name:   messbauer_saw_tooth_generator
// Module Name:   E:/PLD/MessbauerTestEnvironment/messbauer_test_environment/src/messbauer_saw_tooth_generator_testbench.v
// Project Name:  messbauer_test_environment
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: messbauer_saw_tooth_generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module messbauer_saw_tooth_generator_testbench;

	// Inputs
	reg channel;
	reg areset_n;

	// Outputs
	wire [7:0] out_value;

	// Instantiate the Unit Under Test (UUT)
	messbauer_saw_tooth_generator uut (
		.channel(channel), 
		.areset_n(areset_n), 
		.out_value(out_value)
	);

	initial begin
		// Initialize Inputs
		channel = 0;
		areset_n = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

