`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2024 00:55:57
// Design Name: 
// Module Name: subtask_B_module
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


module subtask_B_module (
    input basys_clock,
    input btnU, btnD, btnC,   
    input reset,    
    output [7:0] JB               
);

    reg [15:0] oled_colour;     
    wire [15:0] color_top, color_middle, color_bottom, color_fourth;
    wire my_6_25mhz_clock;
    wire debounced_up, debounced_down, debounced_center;
    wire [12:0] pixel_index; 

    // 6.25mhz clock
    clk_6p25M clock_gen(
        .basys_clock(basys_clock),
        .my_6_25mhz_clock(my_6_25mhz_clock)
    );

    // debouncing pushbuttons
    debounce debounce_up (
        .clk(my_6_25mhz_clock),
        .button(btnU),
        .debounced_button(debounced_up)
    );

    debounce debounce_down (
        .clk(my_6_25mhz_clock),
        .button(btnD),
        .debounced_button(debounced_down)
    );

    debounce debounce_center (
        .clk(my_6_25mhz_clock),
        .button(btnC),
        .debounced_button(debounced_center)
    );

    //determining color 
    SquareColoring square_color_logic (
        .clk(my_6_25mhz_clock),
        .debounced_up(debounced_up),
        .debounced_center(debounced_center),
        .debounced_down(debounced_down),
        .reset(reset),
        .color_top(color_top),
        .color_middle(color_middle),
        .color_bottom(color_bottom),
        .color_fourth(color_fourth)
    );

    //pixel coordinates
    wire [5:0] x, y; // 6 bits for x and y
    assign x = pixel_index % 96;   // Calculate x coordinate
    assign y = pixel_index / 96;    // Calculate y coordinate

    //coloring the pixels
    wire [15:0] pixel_color;
    SquareColorRetriever square_color_retriever (
        .x(x),
        .y(y),
        .color_top(color_top),
        .color_middle(color_middle),
        .color_bottom(color_bottom),
        .color_fourth(color_fourth),
        .pixel_color(pixel_color)
    );

    always @(posedge my_6_25mhz_clock) begin
        oled_colour <= pixel_color;
    end

    // Instantiate Oled_Display to send pixel data to the OLED screen
    Oled_Display oled_display (
        .clk(my_6_25mhz_clock),     
        .reset(1'b0),               
        .pixel_index(pixel_index),   
        .pixel_data(oled_colour),    
        .cs(JB[0]),                 
        .sdin(JB[1]),                
        .sclk(JB[3]),             
        .d_cn(JB[4]),              
        .resn(JB[5]),               
        .vccen(JB[6]),               
        .pmoden(JB[7])               
    );

endmodule



