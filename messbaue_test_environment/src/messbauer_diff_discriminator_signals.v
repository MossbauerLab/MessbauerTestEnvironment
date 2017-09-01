`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:28 08/30/2017 
// Design Name:    messbauer_test_environment
// Module Name:    messbauer_diff_discriminator_signals 
// Project Name: 
// Target Devices: Spartan 6
// Tool versions:  ISE 14.7
// Description:    ALINX AX309 MESSBAUER DIFF DISCRIMINATOR SIGNALS
//
// Dependencies: 
//
// Revision: 
// Revision 1.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 module messbauer_diff_discriminator_signals #
 (
     parameter GCLK_PERIOD = 20,                  // nanoseconds
      parameter LOWER_THRESHOLD_DURATION = 3,      // GCLK_PERIOD
      parameter UPPER_THRESHOLD_DURATION = 1,      // GCLK_PERIOD
      parameter DISCRIMINATOR_IMPULSES_PAUSE = 10, // GCLK_PERIOD
      parameter IMPULSES_PER_CHANNEL = 16,
      parameter IMPULSES_FOR_SELECTION = 4         // number of impulses passes through diff disriminator MUST be smaller than IMPULSES_PER_CHANNEL
 )
 (
     input wire aclk,
     input wire areset_n,
      input wire channel,
     output reg lower_threshold,
     output reg upper_threshold
 );
 
 localparam INITIAL_STATE = 0;
 localparam LOWER_THRESHOLD_HIGH_PHASE = 1;
 localparam UPPER_THRESHOLD_HIGH_PHASE = 2;
 localparam UPPER_THRESHOLD_LOW_PHASE = 3;
 localparam LOWER_THRESHOLD_LOW_PHASE = 4; 
 localparam FINAL_STATE = 5;
 
 reg enable;
 reg[7:0] clk_counter;
 reg[7:0] impulse_counter;
 reg[7:0] total_impulse_counter;
 reg[2:0] state;
 reg impulse_selected;

 always @(posedge aclk)
 begin
     if(~areset_n)
      begin
          clk_counter <= 0;
            impulse_counter <= 0;
            total_impulse_counter <= 0;
            impulse_selected <= 0;
            state <= INITIAL_STATE;
            lower_threshold <= 0;
            upper_threshold <= 0;
      end
      else
      begin
          if(enable)
            begin
                clk_counter <= clk_counter + 1;
                case (state)
                    INITIAL_STATE:
                    begin
                         clk_counter <= 0;
                          state <= LOWER_THRESHOLD_HIGH_PHASE;
                     end
                     LOWER_THRESHOLD_HIGH_PHASE:             
                    begin
                         lower_threshold <= 1;
                          clk_counter <= 0;
                          if((impulse_selected == 0 || impulse_counter == 0) && impulse_counter <= IMPULSES_FOR_SELECTION)
                          begin
                              state <= LOWER_THRESHOLD_LOW_PHASE;
                                impulse_selected <= 1;
                                impulse_counter <= impulse_counter + 1;
                          end
                         else state <= UPPER_THRESHOLD_LOW_PHASE;                      
                     end
                     UPPER_THRESHOLD_HIGH_PHASE:
                    begin
                          impulse_selected <= 0;
                     upper_threshold <= 1;
                          if(clk_counter == UPPER_THRESHOLD_DURATION)
                              state <= UPPER_THRESHOLD_LOW_PHASE;
                     end
                     UPPER_THRESHOLD_LOW_PHASE:
                    begin
                         state <= LOWER_THRESHOLD_LOW_PHASE;
                          upper_threshold <= 0;
                     end
                     LOWER_THRESHOLD_LOW_PHASE:
                    begin
                         lower_threshold <= 0;
                          if(clk_counter == LOWER_THRESHOLD_DURATION)
                          begin
                              total_impulse_counter <= total_impulse_counter + 1;
                                if(total_impulse_counter == IMPULSES_PER_CHANNEL)
                                    state <= FINAL_STATE;
                                else state <= INITIAL_STATE;
                          end
                     end
                     FINAL_STATE:
                     begin
                     end
                     default:
                     begin
                     end             
                endcase
            end
            else
            begin
             impulse_selected <= 0;
                 total_impulse_counter <= 0;
                impulse_selected <= 0;
            end
      end
 end
 
 always @(posedge channel)
 begin
     if(~areset_n)
          enable = 0;
     enable = ~enable;
 end

 endmodule
