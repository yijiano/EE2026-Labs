`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2023 03:05:11 PM
// Design Name: 
// Module Name: ss_display
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


module ss_display(led, seg, clk);
  output reg [6:0] seg;
  input wire clk;
  input wire [10:0] led;

  reg [3:0] display_num = 4'd15;
  reg [3:0] numsd = 4'b0000;
  
  always @(posedge clk) begin
        case (led)
            11'b00000000001: numsd=4'd0;
            11'b00000000010: numsd=4'd1;
            11'b00000000100: numsd=4'd2;
            11'b00000001000: numsd=4'd3;
            11'b00000010000: numsd=4'd4;
            11'b00000100000: numsd=4'd5;
            11'b00001000000: numsd=4'd6;
            11'b00010000000: numsd=4'd7;
            11'b00100000000: numsd=4'd8;
            11'b01000000000: numsd=4'd9;
            default: numsd=4'd15;
        endcase  
        display_num = numsd;      
  end

  always @* begin    
        case (display_num)
          0: seg = 7'b1000000;
          1: seg = 7'b1111001;
          2: seg = 7'b0100100;
          3: seg = 7'b0110000;
          4: seg = 7'b0011001;
          5: seg = 7'b0010010;
          6: seg = 7'b0000010;
          7: seg = 7'b1111000;
          8: seg = 7'b0000000;
          9: seg = 7'b0010000;
          10: seg = 7'b0111111;
          default : seg = 7'b0001001;
        endcase      
  end

endmodule
