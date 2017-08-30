`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  MossbauerLab
// Engineer: EvilLord666 (Ushakov MV)
// 
// Create Date:    23:57:05 08/28/2017 
// Design Name: 
// Module Name:    messbauer_generator 
// Project Name:   messbauer_test_environment
// Target Devices: 
// Tool versions:  ISE 14.7
// Description:    ALINX AX309 Board Messbauer Generator
//
// Dependencies: 
//
// Revision: 
// Revision 1.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 `define START_AND_CHANNEL_SYNC 1
 `define CHANNEL_AFTER_MEASURE  2
 `define MAX_CHANNEL_NUMBER  4096
 `timescale 1 ns / 1 ps

 module messbauer_generator #
 (
     //parameter GCLK_FREQUENCY = 50000000,                                                           // maybe will be used in future
	  parameter GCLK_PERIOD = 20,                                                                    // nanoseconds
     parameter START_DURATION = 50,                                                                 // number of GCLK periods (aclk port), 1 clock is 20ns
     parameter CHANNEL_NUMBER = 512,                                                                // is a degree of 2 i.e. 128, 256, 512, 1024 and others smaller than 4096 ! 
     parameter CHANNEL_DURATION = (16 * (`MAX_CHANNEL_NUMBER / CHANNEL_NUMBER)) * 1000 / (2 *GCLK_PERIOD), // channel duration in clock periods
	  parameter CHANNEL_TYPE = `CHANNEL_AFTER_MEASURE                                                // options are 1) START_AND_CHANNEL_SYNC or 2) CHANNEL_AFTER_MEASURE
 )
 (
     input wire aclk,
	  input wire areset_n,
	  output reg start,
	  output reg channel
 );
 
 localparam CHANNEL_GUARD_DURATION = CHANNEL_DURATION - 4 * (1000 / GCLK_PERIOD); // for switch before 4 us
 localparam CHANNEL_MEANDR_GUARD_DURATION = CHANNEL_DURATION / 2;
 localparam START_HIGH_PHASE_DURATION = 15464 * (1000 / GCLK_PERIOD);
 
 localparam reg[2:0] INITIAL_STATE = 0;
 localparam reg[2:0] START_LOW_PHASE_STATE = 1;
 localparam reg[2:0] CHANNEL_GENERATION_STATE = 2;
 localparam reg[2:0] START_HIGH_PHASE_STATE = 3;
  
 reg[31:0] clk_counter;
 reg[2:0] state;
 reg[31:0] channel_counter;
  
 always @(posedge aclk)
 begin
     if(~areset_n)
	  begin
	      start <= 1'b1;
		   channel <= 1'b1;
			clk_counter <= 8'b0;
			state <= INITIAL_STATE;
	  end
	  else
	  begin
	      case (state)
			INITIAL_STATE:
			begin
			    state <= START_LOW_PHASE_STATE;
			    clk_counter <= 0;
			end
			START_LOW_PHASE_STATE:
			begin
			    start <= 0;
				 channel_counter <= 0;
				 if(CHANNEL_TYPE == `START_AND_CHANNEL_SYNC && clk_counter == 0)
				     channel <= 0;
				 clk_counter <= clk_counter + 1;
				 if(clk_counter == START_DURATION)
				    state <= CHANNEL_GENERATION_STATE;
			end
			CHANNEL_GENERATION_STATE:
			begin
			    start <= 1;
			    clk_counter <= clk_counter + 1;
				 if(clk_counter == CHANNEL_GUARD_DURATION)
				 begin
				     channel <= ~channel;
				 end
				 if(clk_counter == CHANNEL_DURATION)
				 begin
				     channel <= ~channel;
					  channel_counter <= channel_counter + 1;
					  clk_counter <= 0;
					  if((channel_counter == CHANNEL_NUMBER - 1 && CHANNEL_TYPE != `START_AND_CHANNEL_SYNC) ||
					     (channel_counter == CHANNEL_NUMBER && CHANNEL_TYPE == `START_AND_CHANNEL_SYNC))
					  begin
					      state <= START_HIGH_PHASE_STATE;
					  end
				 end
			end
			START_HIGH_PHASE_STATE:
			begin
			    start <= 1;
				 channel <= 1;
				 clk_counter <= clk_counter + 1;
				 if(clk_counter == START_HIGH_PHASE_DURATION)
				     state <= INITIAL_STATE;
			end
			default:
			begin
			end
			endcase
	  end
 end
  
 endmodule
