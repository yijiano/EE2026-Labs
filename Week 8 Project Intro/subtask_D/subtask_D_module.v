`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 00:55:57
// Design Name: 
// Module Name: subtask_D_module
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


module subtask_D_module(input clk, 
                        input [4:0] btn,
                        input pause,
                        output [7:0] JB);

    wire clk_6p25MHz;
    wire clk_25MHz;
    wire [12:0] pixel_index;
    wire [15:0] pixel_data;

    screen_printer_module screen(.clk(clk),
                                .btn(btn),
                                .pause(pause),
                                .pixel_index(pixel_index),
                                .pixel_data(pixel_data));

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
