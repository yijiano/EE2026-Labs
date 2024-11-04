`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2024 14:14:54
// Design Name: 
// Module Name: seg_multiplexer
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

// (MSB) F - A (LSB)
/*
parameter SEG_CLEAR = ~7'b0;
parameter SEG_DIGIT_5 = 7'b0010010;
parameter SEG_DIGIT_1 = 7'b1111001;
parameter SEG_DIGIT_0 = 7'b1000000;
parameter SEG_DIGIT_4 = 7'b0011001;
*/
module seg_multiplexer(
    input clk, 
    input [6:0] seg0, seg1, seg2, seg3,
    input dp0, dp1, dp2, dp3,
    output reg [6:0] seg, 
    output reg dp,
    output reg [3:0] an
);
    wire clk_10000hz;
    clk_counter #(5_000, 30)    clk_100hz_module(clk, clk_10000hz);  // Looks like PWM
    reg [4:0] state = 0;
    always @ (posedge clk_10000hz) begin
        state <= state + 1;
        if (state == 0) begin 
            seg <= seg0;
            dp <= dp0;
            an <= 4'b1110;
        end else if (state == 1) begin 
            seg <= seg1;
            dp <= dp1;
            an <= 4'b1101;
        end else if (state == 2) begin 
            seg <= seg2;
            dp <= dp2;
            an <= 4'b1011;
        end else if (state == 3) begin 
            seg <= seg3;
            dp <= dp3;
            an <= 4'b0111;
            state <= 0; // Reset
        end  
    end
endmodule