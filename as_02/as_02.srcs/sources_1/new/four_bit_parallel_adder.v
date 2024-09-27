`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 15:41:46
// Design Name: 
// Module Name: four_bit_parallel_adder
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


module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output [3:0] S
    );
    
    wire C1, C2, C3;
    wire COUT;
    
    full_adder fa1(.A(A[0]), .B(B[0]), .CIN(CIN), .S(S[0]), .COUT(C1));
    full_adder fa2(.A(A[1]), .B(B[1]), .CIN(C1), .S(S[1]), .COUT(C2));
    full_adder fa3(.A(A[2]), .B(B[2]), .CIN(C2), .S(S[2]), .COUT(C3));
    full_adder fa4(.A(A[3]), .B(B[3]), .CIN(C3), .S(S[3]), .COUT(COUT));
    
endmodule
