`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        MossbauerLav
// Engineer:       EvilLord666 (Ushakov MV)
// 
// Create Date:    11:24:46 09/19/2017 
// Design Name: 
// Module Name:    messbauer_test_environment 
// Project Name: 
// Target Devices: Spartan 6
// Tool versions:  Xilinx ISE 14.7
// Description:    
//
// Dependencies: 
//
// Revision: 
// Revision 1.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module messbauer_test_environment
(
    input aclk,                  // 50 MHz GCLK, T8
    input areset_n,              // L3 as Button
	 // Left Side of AX309 Board
    output v1_channel,           // H15
    output v1_start,             // F16
    output v1_lower_threshold,   // C10
    output v1_upper_threshold,   // D16
    // Right Side of AX309 Board
    output v2_channel,           // L16
    output v2_start,             // M15
    output v2_lower_threshold,   // R16
    output v2_upper_threshold    // T15
);

// Left Side (v1) interface
messbauer_generator #(.CHANNEL_NUMBER(512), .CHANNEL_TYPE(1)) v1_generator(.aclk(aclk), .areset_n(areset_n), .start(v1_start), .channel(v1_channel));
messbauer_diff_discriminator_signals v1_diff_discriminator(.aclk(aclk), .areset_n(areset_n), .channel(v1_channel), .lower_threshold(v1_lower_threshold), .upper_threshold(v1_upper_threshold));

// Right Side (v1) interface
messbauer_generator #(.CHANNEL_NUMBER(512), .CHANNEL_TYPE(1)) v2_generator(.aclk(aclk), .areset_n(areset_n), .start(v2_start), .channel(v2_channel));
messbauer_diff_discriminator_signals v2_diff_discriminator(.aclk(aclk), .areset_n(areset_n), .channel(v2_channel), .lower_threshold(v2_lower_threshold), .upper_threshold(v2_upper_threshold));

endmodule