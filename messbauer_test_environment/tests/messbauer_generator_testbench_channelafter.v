`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:36:12 08/30/2017
// Design Name:   messbauer_generator
// Module Name:   E:/PLD/MessbauerTestEnvironment/messbaue_test_environment/tests/messbauer_generator_testbench_channelafter.v
// Project Name:  messbaue_test_environment
// Target Device:  
// Tool versions: Xilinx ISE 14.7
// Description: 
//
// Verilog Test Fixture created by ISE for module: messbauer_generator
//
// Dependencies:
// 
// Revision:
// Revision 1.0
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module messbauer_generator_testbench_channelafter;

    // Inputs
    reg aclk;
    reg areset_n;

    // Outputs
    wire start;
    wire channel;

    // Instantiate the Unit Under Test (UUT)
    messbauer_generator # (.CHANNEL_TYPE(2))  // channel after measurements
    uut 
    (
        .aclk(aclk), 
        .areset_n(areset_n), 
        .start(start), 
        .channel(channel)
    );

    initial begin
        // Initialize Inputs
        aclk = 0;
        areset_n = 0;

        // Wait 100 ns for global reset to finish
        #100;
      areset_n = 1;
        // Add stimulus here
    end
    
    always 
    begin
        #20 aclk = ~aclk;
    end
      
endmodule

