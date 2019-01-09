`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:41:52 01/09/2019 
// Design Name: 
// Module Name:    messbauer_saw_tooth_generator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef MAX_CHANNEL_NUMBER
    `define MAX_CHANNEL_NUMBER  4096
`endif

module messbauer_saw_tooth_generator #
(
    parameter GCLK_PERIOD = 20,
    parameter DIRECT_SLOPE_DURATION = 512,         // number of messbauer channels 4 code generation during direct motion
	 parameter CHANNEL_DURATION = (16 * (`MAX_CHANNEL_NUMBER / DIRECT_SLOPE_DURATION)) * 1000 / (2 * GCLK_PERIOD),
    parameter REVERSE_SLOPE_DURATION = (15464000 / (2 * GCLK_PERIOD)) / CHANNEL_DURATION ,         // number of messbauer pseudo channels during reverse motion (channel does not actually generates) 15,464 ms
    parameter DATA_WIDTH = 12
)
(
    input wire clk,
    input wire areset_n,
    output reg [DATA_WIDTH-1:0] out_value
);
    localparam RATIO_SLOPE_DURATOIN = DIRECT_SLOPE_DURATION / REVERSE_SLOPE_DURATION;
	 reg dir;
	 reg [15:0] counter;
	 
    always @ (posedge clk)
    begin
	     if (!areset_n) 
	     begin
		      out_value <= 0;
				counter <=0;
		      dir <= 0;
	     end 
	     else
	     begin
		      counter <= counter + 1;
            if(dir == 0)
            begin
				    if (counter == CHANNEL_DURATION)
					 begin  
                    out_value <= out_value + 1;
						  counter <= 0;
					 end
                if(out_value == DIRECT_SLOPE_DURATION)
                    dir <= 1;
            end
            else
            begin
				    if (counter == CHANNEL_DURATION)
					 begin
                    out_value <= out_value > RATIO_SLOPE_DURATOIN ? out_value - RATIO_SLOPE_DURATOIN : 0;
						  counter <= 0;
					 end
                if(out_value == 0)
                    dir <= 0;
            end
		  end
    end

endmodule
