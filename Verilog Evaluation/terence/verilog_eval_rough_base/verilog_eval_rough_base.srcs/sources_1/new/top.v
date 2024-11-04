
module top(
    input clk,
    input btnC, btnU, btnL, btnR, btnD, 
    input [15:0] sw,
    output [15:0] led, output reg dp, output reg [6:0] seg, output reg [3:0] an
    ); 
    
    /* --- Clocks ------------------------------------------------------------*/
    wire clk_1p5hz;
    wire clk_1hz;
    wire clk_10hz;
    wire clk_100hz;
    
    clk_counter #(33_333_333, 33_333_333, 32) clk_1p5hz_module  (clk, clk_1p5hz);   // Should be correct -> 50% duty cycle
    clk_counter #(50_000_000, 50_000_000, 32) clk_1hz_module  (clk, clk_1hz);   // Should be correct -> 50% duty cycle
    clk_counter #(5_000_000, 50_000_000, 32)  clk_10hz_module (clk, clk_10hz);  // Should be correct
    clk_counter #(500_000, 50_000_000, 32)    clk_100hz_module(clk, clk_100hz);  // Looks like PWM
    
    
    /* --- 7 segment display configuration ------------------------------------*/
    wire [2:0] state; // Max 2^3 = 8 values
    reg [2:0] state_dynamic=0;
    // 7 segment display configuration
    always @ (*) begin
        if (state == 0) begin
            seg = 7'b1001111; // l
            dp = 'b1;
            an = 4'b1110;
        end else if (state == 1) begin
            seg = 7'b1001111; // l
            dp = 'b1;
            an = 4'b1101;
        end else if (state == 2) begin
            seg = 7'b1001111; // l
            dp = 'b1;
            an = 4'b1011;
        end else if (state == 3) begin
            seg = 7'b1001111; // l
            dp = 'b1;
            an = 4'b0111;
        end else if (state == 4) begin
            seg = 7'b1001111; // l
            dp = 'b1;
            an = 4'b1110;
        end else begin
            seg = 7'b1001111; // l
            dp = 'b1;
            an = 4'b1110;
        end
    end
    
    /* --- State Machine Code -------------------------------------------*/
    trigger_counter #(300_000_000, 32, 0) trig_cnt(clk, sw[0], led[0]);
    
    reg prev_btnC=0;    
    reg prev_btnU=0;
    reg prev_btnL=0;
    reg prev_btnR=0;
    reg prev_btnD=0;
    
    assign state = state_dynamic;
    always @ (posedge clk) begin
        if (prev_btnC == 0 && btnC == 1) begin
            state_dynamic <= 3'd1;
        end
        
        if (prev_btnU == 0 && btnU == 1) begin
            state_dynamic <= 3'd2;
        end
        prev_btnC <= btnC;
        prev_btnU <= btnU;
        prev_btnL <= btnL;
        prev_btnR <= btnR;
        prev_btnD <= btnD;
    end
    
endmodule