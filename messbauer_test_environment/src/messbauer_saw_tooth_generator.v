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
module messbauer_saw_tooth_generator #
(
    parameter DIRECT_SLOPE_DURATION = 100,
    parameter REVERSE_SLOPE_DURATION = 10,
    parameter DATA_WIDTH = 8
)
(
    input wire channel,
    input wire areset_n,
    output reg [DATA_WIDTH-1:0] out_value
);
    localparam RATIO_SLOPE_DURATOIN = DIRECT_SLOPE_DURATION / REVERSE_SLOPE_DURATION;
	 reg dir;
	 
    always @ (posedge channel)
    begin
	     if (!areset_n) 
	     begin
		      out_value <= 0;
		      dir <= 0;
	     end 
	     else 
	     begin
            if(dir == 0)
            begin 
                out_value <= out_value + 1;
                if(out_value == DIRECT_SLOPE_DURATION)
                    dir <= 1;
            end
            else
            begin
                out_value <= out_value > RATIO_SLOPE_DURATOIN ? out_value - RATIO_SLOPE_DURATOIN : 0;
                if(out_value == 0)
                    dir <= 0;
            end
		  end
    end

endmodule
