`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 01:16:51
// Design Name: 
// Module Name: screen_printer_module
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


module screen_printer_module(   input clk,
                                input [4:0] btn,
                                input [12:0] pixel_index,
                                input pause,
                                output reg [15:0] pixel_data);

    wire clk_25MHz;
    clock_module clk_25MHz_module(  .clk(clk),
                                    .f_out(25_000_000),
                                    .out(clk_25MHz));


    wire clk_20Hz;
    clock_module clk_1Hz_module(    .clk(clk),
                                    .f_out(20),
                                    .out(clk_20Hz));

    parameter small_square_size = 7;
    reg [7:0] x1;
    reg [6:0] y1;
    reg [7:0] x2;
    reg [6:0] y2;
    wire print_small_square;
    square_drawer_module small_square(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(x1),
                                .x2(x2),
                                .y1(y1),
                                .y2(y2),
                                .print(print_small_square));
    
    parameter x3 = 35;
    parameter x4 = 60;
    parameter y3 = 20;
    parameter y4 = 45;
    wire print_big_square;
    square_drawer_module big_square(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(x3),
                                .x2(x4),
                                .y1(y3),
                                .y2(y4),
                                .print(print_big_square));


    wire [1:0] dir;
    wire stop;
    reg moving = 0;
    button_handler_module button_handler(   .clk(clk),
                                            .btn(btn),
                                            .pause(pause),
                                            .stop(stop),
                                            .dir(dir));


    reg btnU_collision;
    reg btnL_collision;
    reg btnR_collision;
    reg btnD_collision;
    always @ (*)
    begin
        x2 <= x1 + small_square_size;
        y2 <= y1 + small_square_size;
        btnU_collision <= ((x2 > x3 && x1 < x4) && y1 == y4 && y2 > y4) ? 1 : 0;
        btnL_collision <= ((y2 > y3 && y1 < y4) && x1 == x4 && x2 > x4) ? 1 : 0;
        btnR_collision <= ((y2 > y3 && y1 < y4) && x1 < x3 && x2 == x3) ? 1 : 0;
        btnD_collision <= ((x2 > x3 && x1 < x4) && y1 < y3 && y2 == y3) ? 1 : 0;
    end

    always @ (posedge clk_20Hz)
    begin
        if (pause)
        begin
            moving <= 0;
            x1 <= 0;
            y1 <= 0;
        end

        else
        begin
            if (stop == 0 && !btnU_collision && dir == 2'b00 && y1 > 0)
            begin
                moving <= 1;
                x1 <= x1;
                y1 <= y1 - 1;
            end

            else if (stop == 0 && !btnL_collision && dir == 2'b01 && x1 > 0)
            begin
                moving <= 1;
                x1 <= x1 - 1;
                y1 <= y1;
            end

            else if (stop == 0 && !btnR_collision && dir == 2'b10 && x2 < 96)
            begin
                moving <= 1;
                x1 <= x1 + 1;
                y1 <= y1;
            end

            else if (stop == 0 && !btnD_collision && dir == 2'b11 && y2 < 64)
            begin
                moving <= 1;
                x1 <= x1;
                y1 <= y1 + 1;
            end

            else
            begin
                moving <= 0;
                x1 <= x1;
                y1 <= y1;
            end
        end        
    end
    
    reg [15:0] green_colour = 16'b00000_111111_00000;
    reg [15:0] red_colour = 16'b11111_000000_00000;
    reg [15:0] orange_colour = 16'b11111_011111_00000;
    reg [15:0] black_colour = 16'b00000_000000_00000;
    
    always @ (posedge clk_25MHz)
    begin
        if (print_small_square)
            pixel_data <= green_colour;
        else if (print_big_square)
            pixel_data <= (!moving ? red_colour : orange_colour);
        else
            pixel_data <= black_colour;
    end

endmodule
