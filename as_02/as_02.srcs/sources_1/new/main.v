`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 15:19:41
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
    input [6:0] A, 
    input [6:0] B,
    input pb,
    output [6:0] S,
    output [3:0] T,
    output [3:0] an,
    output [7:0] seg
    );
    
    wire [6:0] DR, AR;
    wire CARRY_LSB_TO_MSB;
    
    assign seg = 8'b11101010;
    assign an = 4'b1100;
    
    three_bit_adder least_significant_bits(.A(A[2:0]), .B(B[2:0]), .S(DR[2:0]), .COUT(CARRY_LSB_TO_MSB));
    four_bit_adder  most_significant_bits(.A(A[6:3]), .B(B[6:3]), .CIN(CARRY_LSB_TO_MSB), .S(DR[6:3]));
    assign AR = DR << 2;
    assign S = pb ? AR : DR;
    assign T = {4 {pb}};
    
    
    
endmodule
