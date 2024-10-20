`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.06.2023 15:05:29
// Design Name: 
// Module Name: paint
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


module paint(
    input clk_100M,clk_25M, clk_12p5M, clk_6p25M, slow_clk,
    input mouse_l, reset, enable,  
    input [11:0] mouse_x, mouse_y,
    input [12:0] pixel_index,
    output [15:0] led,       
    output [6:0] seg, 
    output reg [15:0] colour_chooser
    
);   
    reg clockMouse;    
    reg clk_s;    
    reg clk_6p25MHz;    
    reg clk_25;
   
    
    reg [2:0]pixel_data[360:0]; //going for 28 x 28, the scale down of 56 x 56. Original is 32 x 32, scale down of 64 x 64
    integer k;
    initial begin
          for (k=0; k<361; k=k+1) begin
              pixel_data[k] = 0;
          end
    end
    
    parameter WHITE = 16'b11111_111111_11111;
    parameter ORANGE = 16'b11111_101101_00000;
    parameter BLUE = 16'b00000_000000_11111;
    parameter GREEN = 16'b00000_111111_00000;
    parameter RED = 16'b11111_000000_00000;
    parameter PURPLE = 16'b11111_000000_11110;    
    parameter outline_color = 16'b00000_000000_00000;
    parameter background_color = 16'b11111_111111_11111;
    
    wire [6:0] row, col;
    assign col = pixel_index % 96;
    assign row = pixel_index / 96;        
    
    reg [2:0] state_choice = 3'b00;
    reg [2:0] state;
    
    // check if right click for reset with bounce detection
    reg [31:0] reset_count = 0;
    
    // initialize the reset to prevent unwanted error
    reg mouse_reset;
    initial begin
        mouse_reset = 1'b1;
    end
    
    always @ (posedge clk_100M) begin
        clk_25 = clk_25M;
        clockMouse = clk_12p5M; 
        clk_6p25MHz = clk_6p25M;  
        clk_s = slow_clk;
        // will held reset for 100ms if activate
        if (reset || reset_count > 0) begin
            reset_count = (reset_count > 999_999) ? 0 : reset_count + 1;
        end
        // double if statement to prevent premature detection under clear screen        
        mouse_reset = (reset_count > 0) ? 1 : ((mouse_reset && mouse_l && mouse_x < 55 && mouse_y < 55) ? 0 : mouse_reset);
    end
    
    // This is to generate the color plate selector
    always @(*) begin
        if (mouse_x > 66 && mouse_x < 78 && mouse_y > 5 && mouse_y < 29) state <= 3'b011;
        else if (mouse_x > 80 && mouse_x < 92 && mouse_y > 5 && mouse_y < 29) state <= 3'b001;
        else if (mouse_x > 66 && mouse_x < 78 && mouse_y > 34 && mouse_y < 58) state <= 3'b010;
        else if (mouse_x > 80 && mouse_x < 92 && mouse_y > 34 && mouse_y < 58) state <= 3'b100;        
        else if (mouse_x > 55 || mouse_y > 55) state <= 3'b000;
    end
    
    // To determine the color at each x-y coordinate, configurable    
    wire red, blue, green, orange, outline, screen;
    assign red = (col > 66 && col < 78 && row > 5 && row < 29);
    assign blue =  (col > 80 && col < 92 && row > 5 && row < 29);
    assign green =  (col > 66 && col < 78 && row > 34 && row < 58);
    assign orange =  (col > 80 && col < 92 && row > 34 && row < 58);
    assign outline = (col > 55 || row > 55);    
    assign screen = (col < 56 && row < 56); // create a 56 x 56 screen
    
    // Create a 9 x 9 cursor
    wire within_cursor; wire [15:0] cursor_color;
    assign within_cursor = ((col == mouse_x) || ((col - mouse_x) == 1) || ((mouse_x - col) == 1)) && ((row == mouse_y) || ((row - mouse_y) == 1) || ((mouse_y - row) == 1));
    assign cursor_color = ((col == mouse_x) || ((col - mouse_x) == 1) || ((mouse_x - col) == 1)) && ((row == mouse_y) || ((row - mouse_y) == 1) || ((mouse_y - row) == 1)) ? PURPLE : 0;
    
    // This is for color selection
    always @ (posedge mouse_l) begin
        if (enable) begin            
            if (mouse_l && ((mouse_x > 55) || (mouse_y > 55))) begin
                state_choice <= state; // Set colour
            end
        end
    end

    // We use 3 pixel per lines or per click    
    always @ (posedge clockMouse, posedge reset) begin
        if (reset) begin
            for (k=0; k<361; k=k+1) begin //  here corresponding change from 1024 to 784
                pixel_data[k] <= 2'b00;
            end          
        end else if (enable && mouse_l && mouse_x < 56 && mouse_y < 56) begin                                 
            pixel_data[(mouse_y/3)*19 + (mouse_x/3)] <= state_choice; // update pixel_data to chosen colour based on clicks                   
        end 
    end
    
    
    
    // This portion is necessary to generate required input for neural network       
    reg [9:0] h_cnt = 0; 
    reg [9:0] v_cnt = 0;   
    reg [9:0] mouse_press_x = 0;
    reg [9:0] mouse_press_y = 0;
    reg mouse_press = 0;
    always @ (posedge clk_6p25M) begin
        v_cnt = (h_cnt >= 55) ?  ((v_cnt >= 55) ? 0 : v_cnt + 1) : v_cnt;
        h_cnt = (h_cnt >= 55) ? 0 : h_cnt + 1;
        mouse_press_x = v_cnt;
        mouse_press_y = h_cnt;
        mouse_press = (pixel_data[(h_cnt/3)*19 + (v_cnt/3)] > 0) ? 1 : 0;                  
    end
    
    // This portion to generate the pixel data output
    always @ (pixel_index) begin
        if (enable) begin
            if (within_cursor && cursor_color != 16'b1111_11111_1111) colour_chooser <= cursor_color;
            else if (red) colour_chooser <= RED;
            else if (blue) colour_chooser <= BLUE;
            else if (green) colour_chooser <= GREEN;
            else if (orange) colour_chooser <= ORANGE;
            else if (outline) colour_chooser <= outline_color;
            else if (screen) begin                
                case (pixel_data[(19*(row/3)+ col/3)])
                    0: colour_chooser <= WHITE;
                    1: colour_chooser <= BLUE;
                    2: colour_chooser <= GREEN;
                    3: colour_chooser <= RED;
                    4: colour_chooser <= ORANGE;
                endcase
            end else colour_chooser <= background_color;
        end
    end    
    
    // Running neural network package
    wire [3:0] digit;
    wire [15:0] nums;   
    wire [10:0] nnled;
    module_pack nn_inst(.clk(clk_100M),
                .clk_2(clk_25),
                .clk_6p25MHz(clk_6p25MHz),
                .rst(mouse_reset),
                .rastSW(1'b0),
                .input_val(mouse_press),
                .X_in(mouse_press_x[9:0]),
                .Y_in(mouse_press_y[9:0]),                
                .nums(nums),
                .digit(digit),                    
                .LED(nnled));
    
    // To generate 7 segment output  
               
    ss_display ssd1(.led(nnled), .seg(seg), .clk(clk_s));
    
    // removable, for verification purpose
    assign led[10:0] = nnled;
     
endmodule


