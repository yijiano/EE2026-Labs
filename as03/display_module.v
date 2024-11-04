`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.09.2024 04:07:30
// Design Name: 
// Module Name: display_module
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


module display_module(
    input clk,
    output reg [7:0] seg,
    output reg [3:0] an,
    output reg [2:0] count
    );

    always @ (posedge clk) begin
        count = (count >= 2) ? 0 : count + 1;
    end

    always @ (count) begin
        case (count)
            2'b00 : {seg, an} = {8'b10100001, 4'b1110};
            2'b01 : {seg, an} = {8'b11001111, 4'b1101};
            2'b10 : {seg, an} = {8'b10101111, 4'b1011};
        endcase
    end
endmodule
