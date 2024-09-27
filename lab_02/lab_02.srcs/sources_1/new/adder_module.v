`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 14:05:22
// Design Name: 
// Module Name: adder_module
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


module my_full_adder(
    input A,
    input B,
    input CIN,
    output S,
    output COUT
    );
    
    assign S = A ^ B ^ CIN;
    assign COUT = (A & B) | ( CIN & (A ^ B) );
    
endmodule
