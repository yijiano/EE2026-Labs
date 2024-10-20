`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 22:43:29
// Design Name: 
// Module Name: fish_drawer
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


module fish_drawer(
    input [6:0] pixel_x,
    input [5:0] pixel_y,
    input [6:0] fish_x,
    input [5:0] fish_y,
    output reg is_fish
);
    always @ (*) begin
        if (fish_x - 2 >= 0 && fish_x + 2 <= 93 && fish_y - 2 >= 0 && fish_y + 2 <= 63) begin
            is_fish <= (pixel_x >= fish_x - 2 && pixel_x <= fish_x + 2 && 
                pixel_y >= fish_y - 2 && pixel_y <= fish_y + 2);
        end

        else is_fish <= 0;
    end

endmodule
