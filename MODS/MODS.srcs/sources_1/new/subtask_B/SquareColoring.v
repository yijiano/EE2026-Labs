`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.10.2024 21:53:02
// Design Name: 
// Module Name: SquareColoring
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


module SquareColoring (
    input clk,
    input debounced_up,
    input debounced_center,
    input debounced_down,
    input reset,
    output reg [15:0] color_top = 16'hFFFF,       
    output reg [15:0] color_middle = 16'hFFFF,    
    output reg [15:0] color_bottom = 16'hFFFF,   
    output reg [15:0] color_fourth = 16'hFFFF     
);

    //track the previous state of the buttons
    reg last_debounced_up = 0;
    reg last_debounced_center = 0;
    reg last_debounced_down = 0;

    always @(posedge clk) begin

        if (reset) begin
            color_top <= 16'hFFFF;
            color_middle <= 16'hFFFF;
            color_bottom <= 16'hFFFF;
            color_fourth <= 16'hFFFF;
        end else begin
        
            last_debounced_up <= debounced_up;
            last_debounced_center <= debounced_center;
            last_debounced_down <= debounced_down;

            //top square
            if (debounced_up && !last_debounced_up) begin 
            case (color_top)
                16'hFFFF: color_top <= 16'hF800; //red
                16'hF800: color_top <= 16'h07E0; //green
                16'h07E0: color_top <= 16'h001F; //blue
                16'h001F: color_top <= 16'hFFFF; //white
            endcase
            end

            //middle square
            if (debounced_center && !last_debounced_center) begin 
            case (color_middle)
                16'hFFFF: color_middle <= 16'hF800; //red
                16'hF800: color_middle <= 16'h07E0; //green
                16'h07E0: color_middle <= 16'h001F; //blue
                16'h001F: color_middle <= 16'hFFFF; //white
            endcase
            end

            //bottom square
            if (debounced_down && !last_debounced_down) begin 
                //bottom square
            case (color_bottom)
                16'hFFFF: color_bottom <= 16'hF800; //red
                16'hF800: color_bottom <= 16'h07E0; //green
                16'h07E0: color_bottom <= 16'h001F; //blue
                16'h001F: color_bottom <= 16'hFFFF; //white
            endcase
            end


            if (color_top == 16'h07E0 && color_middle == 16'h07E0 && color_bottom == 16'h07E0) begin
                color_fourth <= 16'hF800;
            end else begin
                color_fourth <= 16'hFFFF;  
            end
        end
    end
endmodule


