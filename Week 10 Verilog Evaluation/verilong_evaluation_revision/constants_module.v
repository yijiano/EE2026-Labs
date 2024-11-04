`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2024 00:26:22
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


module constants_module();

    /////////////////////////////////////////////////////////
    //                         --a--
    //                        |     |
    //                        f     b
    //                        |     |
    //                         --g--
    //                        |     |
    //                        e     c
    //                        |     |
    //                         --d--
    /////////////////////////////////////////////////////////

    parameter [6:0] SEG_BLANK = 7'b1111111; // 0 -> gfedcba = 1000000

    parameter [6:0] SEG_DIGIT_0 = 7'b1000000; // 0 -> gfedcba = 1000000
    parameter [6:0] SEG_DIGIT_1 = 7'b1111001; // 1 -> gfedcba = 1111001
    parameter [6:0] SEG_DIGIT_2 = 7'b0100100; // 2 -> gfedcba = 0100100
    parameter [6:0] SEG_DIGIT_3 = 7'b0110000; // 3 -> gfedcba = 0110000
    parameter [6:0] SEG_DIGIT_4 = 7'b0011001; // 4 -> gfedcba = 0011001
    parameter [6:0] SEG_DIGIT_5 = 7'b0010010; // 5 -> gfedcba = 0010010
    parameter [6:0] SEG_DIGIT_6 = 7'b0000010; // 6 -> gfedcba = 0000010
    parameter [6:0] SEG_DIGIT_7 = 7'b1111000; // 7 -> gfedcba = 1111000
    parameter [6:0] SEG_DIGIT_8 = 7'b0000000; // 8 -> gfedcba = 0000000
    parameter [6:0] SEG_DIGIT_9 = 7'b0010000; // 9 -> gfedcba = 0010000

    /////////////////////////////////////////////////////////
    // A B E H J L M N R U W X Y (X is same as H)
    /////////////////////////////////////////////////////////

    parameter [6:0] SEG_LETTER_A = 7'b0001000; // A -> gfedcba = 0001000
    parameter [6:0] SEG_LETTER_B = 7'b0000011; // B -> gfedcba = 0000011
    parameter [6:0] SEG_LETTER_E = 7'b0000110; // E -> gfedcba = 0000110
    parameter [6:0] SEG_LETTER_H = 7'b0001001; // H -> gfedcba = 0001001
    parameter [6:0] SEG_LETTER_J = 7'b0100001; // J -> gfedcba = 0100001
    parameter [6:0] SEG_LETTER_L = 7'b1000111; // L -> gfedcba = 1000111
    parameter [6:0] SEG_LETTER_M = 7'b1101011; // M -> gfedcba = 1101011
    parameter [6:0] SEG_LETTER_N = 7'b0101011; // N -> gfedcba = 0101011
    parameter [6:0] SEG_LETTER_R = 7'b0101111; // R -> gfedcba = 0101111
    parameter [6:0] SEG_LETTER_U = 7'b1000001; // U -> gfedcba = 1000001
    parameter [6:0] SEG_LETTER_W = 7'b1010101; // W -> gfedcba = 1010101
    parameter [6:0] SEG_LETTER_X = 7'b0001001; // X -> gfedcba = 0001001
    parameter [6:0] SEG_LETTER_Y = 7'b0010001; // Y -> gfedcba = 0010001

    /////////////////////////////////////////////////////////
    // u r d l c
    /////////////////////////////////////////////////////////

    parameter [6:0] SEG_btnU = 7'b1100011; // u -> gfedcba = 1100011
    parameter [6:0] SEG_btnR = 7'b0101111; // r -> gfedcba = 0101111
    parameter [6:0] SEG_btnD = 7'b0100001; // d -> gfedcba = 0100001
    parameter [6:0] SEG_btnL = 7'b1001111; // l -> gfedcba = 1001111
    parameter [6:0] SEG_btnC = 7'b0100111; // c -> gfedcba = 0100111

endmodule
