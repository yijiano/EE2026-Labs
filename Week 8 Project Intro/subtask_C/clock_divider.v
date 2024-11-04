`timescale 1ns / 1ps


module clock_divider(input clk, input [31:0] f, output reg slow_clk = 0);

    reg[31:0] count = 0;
    
    always@(posedge clk) begin
        if(count == f) begin
            count <= 0;
            slow_clk <= ~slow_clk;
        end
        else begin
            count <= count + 1;
        end
    end
endmodule
