`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 00:37:15
// Design Name: 
// Module Name: main
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


module main(
    input clk,
    input [15:0] sw,
    output reg [15:0] led,
    output reg [6:0] seg,
    output reg dp,
    output reg [3:0] an,

    input btnC, 
    input btnU, 
    input btnL, 
    input btnR, 
    input btnD);

    constants_module constants();


endmodule
