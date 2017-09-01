`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:28:30 09/01/2017
// Design Name:   messbauer_diff_discriminator_signals
// Module Name:   E:/PLD/MessbauerTestEnvironment/messbaue_test_environment/tests/messbauer_diff_discriminator_testbench.v
// Project Name:  messbaue_test_environment
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: messbauer_diff_discriminator_signals
//
// Dependencies:
// 
// Revision:
// Revision  1.0
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module messbauer_diff_discriminator_testbench;

    // Inputs
    reg aclk;
    reg areset_n;
    reg channel;

    // Outputs
    wire lower_threshold;
    wire upper_threshold;

    // Instantiate the Unit Under Test (UUT)
    messbauer_diff_discriminator_signals 
    uut 
    (
        .aclk(aclk), 
        .areset_n(areset_n), 
        .channel(channel), 
        .lower_threshold(lower_threshold), 
        .upper_threshold(upper_threshold)
    );
    
    localparam CHANNEL_WAIT_COUNTER_CYCLES = 10;
    
    reg [7:0]channel_wait_counter;
    reg channel_generation_enabled;

    initial 
    begin
        // Initialize Inputs
        aclk = 0;
        areset_n = 0;
        channel = 0;
        channel_wait_counter = 0;
        channel_generation_enabled = 0;

        // Wait 100 ns for global reset to finish
        #100;
      areset_n = 1;
        // Add stimulus here

    end
    
    always
    begin
        #20 aclk <= ~aclk;
    end
    
    always
    begin
         if(channel_wait_counter < CHANNEL_WAIT_COUNTER_CYCLES)
             #100 channel_wait_counter <= channel_wait_counter + 1;
         else
         begin
             #64000 channel <= ~channel; // 128 us per messbauer channel
         end
    end
      
endmodule

