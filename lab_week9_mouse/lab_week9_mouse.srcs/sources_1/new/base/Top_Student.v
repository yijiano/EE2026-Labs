`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  I am on the bus to the next world.
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input clk, 
                    input [15:0] sw, 
                    inout PS2Clk,
                    inout PS2Data,
                    output [15:0] led,
                    output [7:0] JB);

    colour_constants colour();

    wire [12:0] pixel_index;
    reg [15:0] pixel_data;

    wire clk_10Hz;
    wire clk_6p25MHz;
    wire clk_25MHz;
    clock_module clk_1Hz_module(.clk(clk), .f_out(10), .out(clk_10Hz));
    clock_module clk_6p25MHz_module(.clk(clk), .f_out(6_250_000), .out(clk_6p25MHz));
    clock_module clk_25MHz_module(.clk(clk), .f_out(25_000_000), .out(clk_25MHz));

    Oled_Display my_oled_unit(
        .clk(clk_6p25MHz), 
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
        .pmoden(JB[7])
    );

    wire draw_cursor;
    wire mouse_click;
    wire [6:0] cursor_x;
    wire [5:0] cursor_y;
    cursor_handler cursor(  
        .clk(clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data),
        .cursor_x(cursor_x),
        .cursor_y(cursor_y),
        .is_cursor_pixel(draw_cursor),
        .is_cursor_clicked(mouse_click)
    );


    wire [6:0] pixel_x;
    wire [5:0] pixel_y;
    pixel_index_to_coord_module xycoord_module( 
        .x(pixel_x),
        .y(pixel_y),
        .pixel_index(pixel_index)
    );
    
    // Fish xy-Coordinates Handler
    reg [6:0] fish_x = 96 / 2;
    reg [5:0] fish_y = 64 / 2;
    reg signed [1:0] fish_dx = 0;
    reg signed [1:0] fish_dy = 0;
    wire draw_fish;

    fish_drawer fish_drawer_module(
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .fish_x(fish_x),
        .fish_y(fish_y),
        .is_fish(draw_fish)
    );

    always @ (posedge clk_10Hz) begin
        fish_dx <= (fish_x == target_x)
            ? 0
            : (fish_x > target_x
                ? -1
                : 1);

        fish_dy <= (fish_y == target_y)
            ? 0
            : (fish_y > target_y
                ? -1
                : 1);
        case(fish_dx)
            -1  : fish_x <= (fish_x == 0) ? fish_x : fish_x - 1;
            0   : fish_x <= fish_x;
            1   : fish_x <= (fish_x == 93) ? fish_x : fish_x + 1;
        endcase

        case(fish_dy)
            -1  : fish_y <= (fish_y == 0) ? fish_y : fish_y - 1;
            0   : fish_y <= fish_y;
            1   : fish_y <= (fish_y == 63) ? fish_y : fish_y + 1;
        endcase
    end
    
    // Target xy-Coordinates Handler
    reg [6:0] target_x = 96 / 2;
    reg [5:0] target_y = 64 / 2;
    wire draw_target;
    always @ (*) begin
        target_x <= mouse_click ? cursor_x : target_x;
        target_y <= mouse_click ? cursor_y : target_y;
    end
    target_handler target(  
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .target_x(target_x),
        .target_y(target_y),
        .fish_x(fish_x),
        .fish_y(fish_y),
        .is_target(draw_target)
    );

    wire draw_line;
    line_drawer target_fish_line(   
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .fish_x(fish_x),
        .fish_y(fish_y),
        .target_x(target_x),
        .target_y(target_y),
        .is_line(draw_line)
    );

    always @ (posedge clk_25MHz)
    begin
        // Cursor Drawer
        if (draw_cursor)
            pixel_data <= mouse_click ? colour.LIGHT_GREEN : colour.GREEN;

        // Fish Drawer
        else if (draw_fish)
            pixel_data <= colour.ORANGE;
        
        // Target-Fish Line Drawer
        else if (draw_line)
            pixel_data <= colour.WHITE;

        // Target Drawer
        else if (draw_target)
            pixel_data <= colour.RED;

        // Blank Screen    
        else
            pixel_data <= colour.BLACK;

    end
endmodule
