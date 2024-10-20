`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2024 21:45:20
// Design Name: 
// Module Name: SquareColorRetriever
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


module SquareColorRetriever (
    input [6:0] x, 
    input [6:0] y, 
    input [15:0] color_top,    
    input [15:0] color_middle, 
    input [15:0] color_bottom, 
    input [15:0] color_fourth,
    output reg [15:0] pixel_color 
);

  always @(*) begin
    pixel_color = 16'h0000; 

    if (x >= 43 && x < 53 && y >= 5 && y < 15) begin
        pixel_color = color_top;   //top square
    end 
    if (x >= 43 && x < 53 && y >= 18 && y < 28) begin
        pixel_color = color_middle; //middle square
    end 

    if (x >= 43 && x < 53 && y >= 31 && y < 41) begin
        pixel_color = color_bottom; //bottom square
    end 
   
    if (x >= 43 && x < 53 && y >= 44 && y < 54) begin
        pixel_color = color_fourth; 
    end 
end

endmodule
