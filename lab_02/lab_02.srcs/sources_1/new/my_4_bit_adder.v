`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 14:21:52
// Design Name: 
// Module Name: my_4_bit_adder
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


module my_4_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input C0,
    output [3:0] S,
    output C4
    );
    
    wire C2;

    my_2_bit_adder tba0 (A[1:0], B[1:0], C0, S[1:0], C2);
    my_2_bit_adder tba1 (A[3:2], B[3:2], C2, S[3:2], C4);
        
endmodule
