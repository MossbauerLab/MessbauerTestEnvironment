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
    input wire global_clock,                     // 50 MHz GCLK, T8
    input wire global_reset,                     // L3 as Button
    // Left Side of AX309 Board
    output wire v1_channel,                      // F16
    output wire v1_start,                        // E16
	 output wire [11:0] v1_velocity_reference,
    output wire v1_lower_threshold,              // C10
    output wire v1_upper_threshold,              // D16
    // Right Side of AX309 Board
    output wire v2_channel,                      // L16
    output wire v2_start,                        // M15
	 output wire [11:0] v2_velocity_reference,
    output wire v2_lower_threshold,              // R16
    output wire v2_upper_threshold               // T14
);

reg internal_reset;
reg [5:0] counter;

// Left Side (v1) interface
// Start, Channel generation
messbauer_generator #(.CHANNEL_NUMBER(512), .CHANNEL_TYPE(1)) v1_generator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .start(v1_start), .channel(v1_channel));
// Saw tooth generation (velocity refence signal)
messbauer_saw_tooth_generator #(.DIRECT_SLOPE_DURATION(512)) v1_velocity_reference_generator(.clk(global_clock), .areset_n(global_reset & internal_reset), .out_value(v1_velocity_reference));
// Signals 4 testing Differntial discriminator test
messbauer_diff_discriminator_signals v1_diff_discriminator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .channel(v1_channel), .lower_threshold(v1_lower_threshold), .upper_threshold(v1_upper_threshold));

// Right Side (v1) interface
// Start, Channel generation
messbauer_generator #(.CHANNEL_NUMBER(512), .CHANNEL_TYPE(2)) v2_generator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .start(v2_start), .channel(v2_channel));
// Saw tooth generation (velocity refence signal)
messbauer_saw_tooth_generator #(.DIRECT_SLOPE_DURATION(512)) v2_velocity_reference_generator(.clk(global_clock), .areset_n(global_reset & internal_reset), .out_value(v2_velocity_reference));
// Signals 4 testing Differntial discriminator test
messbauer_diff_discriminator_signals v2_diff_discriminator(.aclk(global_clock), .areset_n(global_reset & internal_reset), .channel(v2_channel), .lower_threshold(v2_lower_threshold), .upper_threshold(v2_upper_threshold));

// Reset generation
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
