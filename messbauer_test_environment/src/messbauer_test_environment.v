`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        MossbauerLab
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
    input global_clock,          // 50 MHz GCLK, T8
    input global_reset,          // L3 as Button
	 // Left Side of AX309 Board
    output v1_channel,           // H15
    output v1_start,             // F16
    output v1_lower_threshold,   // C10
    output v1_upper_threshold,   // D16
    // Right Side of AX309 Board
    output v2_channel,           // L16
    output v2_start,             // M15
    output v2_lower_threshold,   // R16
    output v2_upper_threshold    // T14
);

reg internal_reset;
reg [5:0] counter;

// Left Side (v1) interface
messbauer_generator #(.CHANNEL_NUMBER(512), .CHANNEL_TYPE(1)) v1_generator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .start(v1_start), .channel(v1_channel));
messbauer_diff_discriminator_signals v1_diff_discriminator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .channel(v1_channel), .lower_threshold(v1_lower_threshold), .upper_threshold(v1_upper_threshold));

// Right Side (v1) interface
messbauer_generator #(.CHANNEL_NUMBER(512), .CHANNEL_TYPE(2)) v2_generator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .start(v2_start), .channel(v2_channel));
messbauer_diff_discriminator_signals v2_diff_discriminator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .channel(v2_channel), .lower_threshold(v2_lower_threshold), .upper_threshold(v2_upper_threshold));

always @(posedge global_clock)
begin
    if(~global_reset)
	 begin
	     internal_reset <= 1;
		  counter <= 0;
	 end
	 if(counter < 16)
	     counter <= counter + 1'b1;
	 if(counter >= 16 && counter < 32)
	 begin
	     counter <= counter + 1'b1;
		  internal_reset <= 0;
	 end
	 if(counter == 32)
	     internal_reset <= 1;
end

endmodule
