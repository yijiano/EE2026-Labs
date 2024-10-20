`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2024 15:12:52
// Design Name: 
// Module Name: target_handler
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


module target_handler(  input [6:0] pixel_x,
                        input [5:0] pixel_y,
                        input [6:0] target_x,
                        input [5:0] target_y,
                        input [6:0] fish_x,
                        input [5:0] fish_y,
                        output reg is_target);

    parameter r = 3;

    reg [6:0] x;
    reg [5:0] y;

    always @ (*) begin   
        x <= (pixel_x > target_x) ? (pixel_x - target_x) : (target_x - pixel_x);
        y <= (pixel_y > target_y) ? (pixel_y - target_y) : (target_y - pixel_y);

        is_target <= !(target_x == fish_x && target_y == fish_y) && 
            ( (x * x + y * y == r * r) || (pixel_x == target_x && pixel_y == target_y) ) 
            ? 1 
            : 0;
    end

endmodule
