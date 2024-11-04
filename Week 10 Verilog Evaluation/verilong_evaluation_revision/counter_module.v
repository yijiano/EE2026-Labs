`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2024 00:48:42
// Design Name: 
// Module Name: four_bit_counter_module
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


module counter_module(
    input clk,
    input reset,
    input [31:0] max,
    output reg [31:0] count = 0
    );
    
    always @ (posedge clk) begin
        count = reset 
            ? 0
            : ((count >= max) ? max : count + 1);
    end
endmodule