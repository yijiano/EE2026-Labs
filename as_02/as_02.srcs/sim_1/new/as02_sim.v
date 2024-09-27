`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2024 10:42:55
// Design Name: 
// Module Name: as02_sim
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


module as02_sim();
    reg [6:0] A;
    reg [6:0] B;
    reg pb;
    wire [6:0] S;
    wire [3:0] T;
    wire [3:0] an;
    wire [7:0] seg;
    
    main simulated_main(.A(A),
                        .B(B),
                        .pb(pb),
                        .S(S),
                        .T(T),
                        .an(an),
                        .seg(seg));
    
    initial
    begin
        A = 7'b1010111; B = 7'b0101010; pb = 0; #10;
        A = 7'b1100110; B = 7'b0011001; pb = 0; #10;
        A = 7'b0011001; B = 7'b1100000; pb = 0; #10;
        A = 7'b1010111; B = 7'b0101010; pb = 1; #10;
        A = 7'b1100110; B = 7'b0011001; pb = 1; #10;
        A = 7'b0011001; B = 7'b1100000; pb = 1; #10;
    end
    
endmodule
