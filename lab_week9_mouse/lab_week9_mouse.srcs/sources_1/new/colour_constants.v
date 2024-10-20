`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2024 15:10:50
// Design Name: 
// Module Name: colour_constants
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

module colour_constants();

    parameter RED = 16'b11111_000000_00000;
    parameter GREEN = 16'b00000_101010_00000;
    parameter BLUE = 16'b00000_000000_11111;
    parameter YELLOW = 16'b11111_111111_00000;
    parameter CYAN = 16'b00000_111111_11111;
    parameter MAGENTA = 16'b11111_000000_11111;
    parameter ORANGE = 16'b11111_011000_00000;
    parameter PURPLE = 16'b01111_000000_11111;
    parameter PINK = 16'b11111_010010_10111;
    parameter BROWN = 16'b01111_010100_00000;
    parameter WHITE = 16'b11111_111111_11111;
    parameter GRAY = 16'b01010_010101_01010;
    parameter LIGHT_BLUE = 16'b01111_011111_11111;
    parameter LIGHT_GREEN = 16'b01000_111111_01000;
    parameter LIGHT_YELLOW = 16'b11111_111111_01000;
    parameter LIGHT_PURPLE = 16'b10111_010000_10111;
    parameter LIGHT_GRAY = 16'b10101_101010_10101;
    parameter DARK_GRAY = 16'b00101_001010_00101;
    parameter BLACK = 16'd0;

endmodule
