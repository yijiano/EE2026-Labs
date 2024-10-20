`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 07:29:14
// Design Name: 
// Module Name: default_screen_module
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


module default_screen_module(   input clk,
                                output [7:0] JB);
    wire [12:0] pixel_index;
    reg [15:0] pixel_data;

    wire clk_25MHz;
    clock_module clk_25MHz_module(  .clk(clk),
                                    .f_out(25_000_000),
                                    .out(clk_25MHz));

    wire print_one;
    square_drawer_module one(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(39),
                                .x2(44),
                                .y1(7),
                                .y2(52),
                                .print(print_one));

    reg print_two;
    wire print_two_part1;
    square_drawer_module two_part1(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(51),
                                .x2(82),
                                .y1(7),
                                .y2(12),
                                .print(print_two_part1));

    wire print_two_part2;
    square_drawer_module two_part2(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(77),
                                .x2(82),
                                .y1(7),
                                .y2(33),
                                .print(print_two_part2));

    wire print_two_part3;
    square_drawer_module two_part3(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(51),
                                .x2(82),
                                .y1(27),
                                .y2(33),
                                .print(print_two_part3));

    wire print_two_part4;
    square_drawer_module two_part4(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(51),
                                .x2(56),
                                .y1(27),
                                .y2(52),
                                .print(print_two_part4));

    wire print_two_part5;
    square_drawer_module two_part5(.clk_25MHz(clk_25MHz),
                                .pixel_index(pixel_index),
                                .x1(51),
                                .x2(82),
                                .y1(47),
                                .y2(52),
                                .print(print_two_part5));

    reg [15:0] white_colour = 16'b11111_111111_11111;
    reg [15:0] black_colour = 16'b00000_000000_00000;
    
    always @ (posedge clk_25MHz)
    begin
        print_two <= print_two_part1 || print_two_part2 || print_two_part3 || print_two_part4 || print_two_part5;
        if (print_one || print_two)
            pixel_data <= white_colour;
        else
            pixel_data <= black_colour;
    end

    wire clk_6p25MHz;
    clock_module clk_6p25MHz_module(.clk(clk),
                                    .f_out(6_250_000), //7
                                    .out(clk_6p25MHz));
    
    Oled_Display my_oled_unit(.clk(clk_6p25MHz), 
                              .reset(0),
                              .frame_begin(0),
                              .sending_pixels(0),
                              .sample_pixel(0),
                              .pixel_index(pixel_index),
                              .pixel_data(pixel_data),
                              .cs(JB[0]),
                              .sdin(JB[1]),
                              .sclk(JB[3]),
                              .d_cn(JB[4]),
                              .resn(JB[5]),
                              .vccen(JB[6]),
                              .pmoden(JB[7]));
endmodule
