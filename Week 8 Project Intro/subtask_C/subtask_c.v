`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 00:55:57
// Design Name: 
// Module Name: subtask_C_module
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


module subtask_C_module (input clk, btnC, btnU, pause, output [7:0] JC);

    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index; // 0-6193, snake-shape
    wire clk_625MHz; // need to be initialized
    wire [15:0] oled_color;
    
    clock_divider clk625(clk, 7, clk_625MHz);
    
    Oled_Display test_unit_oled (.clk(clk_625MHz), .reset(0), 
    .frame_begin(frame_begin), .sending_pixels(sending_pixels), .sample_pixel(sample_pixel), .pixel_index(pixel_index), .pixel_data(oled_color), 
    .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]), .d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7])); //reset(0) is to connect to GND
    
    oled_module_C test_unit_C(.pixel_index(pixel_index), .clk_625MHz(clk_625MHz), .pause(pause), .btnC(btnC), .btnU(btnU), .oled_color(oled_color));

endmodule