`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2024 21:14:08
// Design Name: 
// Module Name: mouse_oled_mapper
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


module mouse_oled_mapper(
    input [11:0] xpos,
    input [11:0] ypos,
    output reg [6:0] oled_x = 0,
    output reg [5:0] oled_y = 0
);
    ////////////////////////////////////////////////////////////////////////////////////
    //
    // TL;DR From experimentation xpos and ypos values vary in the range:
    // xpos -> 0 - 960 
    // ypos -> 0 - 640
    //
    // Essentially this means that the [11:10] bits are completely useless.
    // 
    ////////////////////////////////////////////////////////////////////////////////////

    always @ (*) begin
        oled_x <= (xpos[9:0] / 10 == 0) ? 0 : (xpos[9:0] / 10 - 1);
        oled_y <= (ypos[9:0] / 10 == 0) ? 0 : (ypos[9:0] / 10 - 1);
    end

endmodule
