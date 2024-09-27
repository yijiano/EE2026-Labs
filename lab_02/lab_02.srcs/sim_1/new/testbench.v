`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2024 14:36:53
// Design Name: 
// Module Name: testbench
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


module testbench(
 
    );

    reg [3:0] A, B;
    reg CARRY_IN;
    wire [3:0] S;
    wire CARRY_OUT;
    
    my_4_bit_adder dut(A, B, CARRY_IN, S, CARRY_OUT);
    
    initial begin
    
        A = 4'b0011; B = 4'b0011; CARRY_IN = 1'b0; #20;
        A = 4'b1011; B = 4'b0111; CARRY_IN = 1'b0; #20;
        A = 4'b1111; B = 4'b1111; CARRY_IN = 1'b0; #20;
        
    end
    
endmodule
