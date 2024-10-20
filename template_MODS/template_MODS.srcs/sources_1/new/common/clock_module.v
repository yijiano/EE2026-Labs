`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2024 16:07:32
// Design Name: 
// Module Name: clock_module
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


module clock_module(
    input clk,
    input [31:0] f_out,
    output reg out = 0
    );

    parameter basys_clk = 100 * 1_000_000;
    wire [31:0] m;
    assign m = basys_clk / (2 * f_out) - 1;
    
    reg [31:0] count = 0;
    always @ (posedge clk) begin
        count <= (count >= m) ? 0 : count + 1;
        out <= (count == 0) ? ~out : out;
    end
endmodule
