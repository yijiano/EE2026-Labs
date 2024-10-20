`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 01:05:07
// Design Name: 
// Module Name: pixel_index_to_coord_module
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


module pixel_index_to_coord_module( output [6:0] x,
                                    output [5:0] y,
                                    input [12:0] pixel_index);
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
endmodule
