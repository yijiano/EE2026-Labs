`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 15:37:59
// Design Name: 
// Module Name: three_bit_parallel_adder
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


module three_bit_adder(
    input [2:0] A,
    input [2:0] B,
    output [2:0] S,
    output COUT
    );
    
    wire C1, C2;
    
    full_adder fa1(.A(A[0]), .B(B[0]), .CIN(1'b0), .S(S[0]), .COUT(C1));
    full_adder fa2(.A(A[1]), .B(B[1]), .CIN(C1), .S(S[1]), .COUT(C2));
    full_adder fa3(.A(A[2]), .B(B[2]), .CIN(C2), .S(S[2]), .COUT(COUT));
    
endmodule
