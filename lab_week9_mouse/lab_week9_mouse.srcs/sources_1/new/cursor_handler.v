`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2024 21:26:33
// Design Name: 
// Module Name: cursor_handler
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


module cursor_handler(  input clk,
                        input [6:0] pixel_x,
                        input [5:0] pixel_y,
                        inout ps2_clk,
                        inout ps2_data,
                        output reg [6:0] cursor_x,
                        output reg [5:0] cursor_y,
                        output reg is_cursor_pixel,
                        output reg is_cursor_clicked);

    wire [11:0] xpos;
    wire [11:0] ypos;
    wire mouse_left;
    wire mouse_right;
    MouseCtl mouse_control( .clk(clk),
                            .xpos(xpos),
                            .ypos(ypos),
                            .left(mouse_left),
                            .right(mouse_right),
                            .ps2_clk(ps2_clk),
                            .ps2_data(ps2_data));

    wire [6:0] mapped_x;
    wire [5:0] mapped_y;
    mouse_oled_mapper mouse_to_oled(.xpos(xpos),
                                    .ypos(ypos),
                                    .oled_x(mapped_x),
                                    .oled_y(mapped_y));


    always @ (*) begin
        is_cursor_clicked <= mouse_left || mouse_right;
        cursor_x <= mapped_x;
        cursor_y <= mapped_y;
        
        if (pixel_x == mapped_x && pixel_y == mapped_y)
            is_cursor_pixel <= 1;
        else if (pixel_x == mapped_x + 1 && pixel_y == mapped_y + 1 && mapped_y < 95)
            is_cursor_pixel <= 1;
        else if (pixel_x == mapped_x + 1 && pixel_y == mapped_y - 1 && mapped_y > 0)
            is_cursor_pixel <= 1;
        else if (pixel_x == mapped_x - 1 && pixel_y == mapped_y + 1 && mapped_y < 95)
            is_cursor_pixel <= 1;
        else if (pixel_x == mapped_x - 1 && pixel_y == mapped_y - 1  && mapped_y > 0)
            is_cursor_pixel <= 1;
        else
            is_cursor_pixel <= 0;
    end
endmodule
