`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2024 16:38:36
// Design Name: 
// Module Name: line_drawer
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


module line_drawer( 
    input [6:0] pixel_x,
    input [5:0] pixel_y,
    input [6:0] target_x,
    input [5:0] target_y,
    input [6:0] fish_x,
    input [5:0] fish_y,
    output reg is_line
);

    // Declare variables for line equation
    reg signed [7:0] dx, dy;
    reg signed [13:0] cross_product; // 14 bits to accommodate possible range
    reg [6:0] min_x, max_x;
    reg [5:0] min_y, max_y;

    // Implement line drawing algorithm for all cases
    always @(*) begin
        // Calculate differences
        dx = (target_x > fish_x) ? (target_x - fish_x) : (fish_x - target_x);
        dy = (target_y > fish_y) ? (target_y - fish_y) : (fish_y - target_y);

        // Determine min and max x, y coordinates
        min_x = (fish_x < target_x) ? fish_x : target_x;
        max_x = (fish_x > target_x) ? fish_x : target_x;
        min_y = (fish_y < target_y) ? fish_y : target_y;
        max_y = (fish_y > target_y) ? fish_y : target_y;

        // Calculate cross product to determine if point is on the line
        cross_product = ((pixel_x - fish_x) * (target_y - fish_y)) - 
                        ((pixel_y - fish_y) * (target_x - fish_x));

        // Check if the current pixel is on or very close to the line
        if (pixel_x >= min_x && pixel_x <= max_x && 
            pixel_y >= min_y && pixel_y <= max_y) begin
            if (dx > dy) begin
                // For more horizontal lines
                if (cross_product <= dx && cross_product >= -dx) begin
                    is_line = 1;
                end else begin
                    is_line = 0;
                end
            end else begin
                // For more vertical lines
                if (cross_product <= dy && cross_product >= -dy) begin
                    is_line = 1;
                end else begin
                    is_line = 0;
                end
            end
        end else begin
            is_line = 0;
        end
    end

endmodule
