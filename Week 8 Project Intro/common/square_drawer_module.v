`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 01:14:59
// Design Name: 
// Module Name: square_drawer_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module square_drawer_module(input clk_25MHz,
                            input [12:0] pixel_index,
                            input [7:0] x1,
                            input [7:0] x2,
                            input [6:0] y1,
                            input [6:0] y2,
                            output reg print);

    wire [7:0] x;
    wire [6:0] y;
    pixel_index_to_coord_module xycoord(.x(x),
                                        .y(y),
                                        .pixel_index(pixel_index));

    always @ (posedge clk_25MHz)
    begin
        if (x >= x1 && x <= x2 - 1 && y >= y1 && y <= y2 - 1)
            print <= 1;
        else
            print <= 0;
    end
endmodule
