
module top(
    input clk,
    input btnC, btnU, btnL, btnR, btnD, 
    input [15:0] sw,
    output [15:0] led, output reg dp, output reg [6:0] seg, output reg [3:0] an
    ); 
    
    /* --- Clocks ------------------------------------------------------------*/
    wire clk_p33hz;
    wire clk_p75hz;
    wire clk_1p5hz;
    wire clk_1hz;
    //wire clk_10hz;
    //wire clk_100hz;
    
    clk_counter #(150_000_000, 150_000_000, 32) clk_p33hz_module (clk, clk_p33hz);
    clk_counter #(66_666_666, 66_666_666, 32) clk_p75hz_module  (clk, clk_p75hz);
    clk_counter #(33_333_333, 33_333_333, 32) clk_1p5hz_module  (clk, clk_1p5hz);   // Should be correct -> 50% duty cycle
    clk_counter #(50_000_000, 50_000_000, 32) clk_1hz_module  (clk, clk_1hz);   // Should be correct -> 50% duty cycle
    //clk_counter #(5_000_000, 50_000_000, 32)  clk_10hz_module (clk, clk_10hz);  // Should be correct
    //clk_counter #(500_000, 50_000_000, 32)    clk_100hz_module(clk, clk_100hz);  // Looks like PWM
    
    /* --- FSM Code -------------------------------------------*/
    //reg unlocked = 0;
    wire unlocked;
    trigger_counter #(500_000_000, 32, 1) trig_cnt(
        clk, 
        sw == 16'b0000000101100100, 
        unlocked
    );

    reg cycle_up = 1;
    reg [2:0] state_cycle=0;

    always @ (posedge clk_1hz) begin
        if (unlocked) begin
            if (cycle_up) begin
                state_cycle <= state_cycle == 4 ? 0 : state_cycle + 1;
            end else begin
                state_cycle <= state_cycle == 0 ? 4 : state_cycle - 1;
            end
        end
    end
    /* --- 7 segment display configuration ------------------------------------*/
    wire [2:0] state_seg; // Max 2^3 = 8 values
    // 7 segment display configuration
    always @ (*) begin
        if (!unlocked) begin // Start State
            an <= 4'b0101;
            seg <= 7'b1010101;
            dp = 1;
        end else if (state_cycle == 0) begin
            an <= 4'b1110;
            seg <= 7'b1111111;
            dp <= 0;
        end else if (state_cycle == 1) begin
            an <= 4'b1100;
            seg <= 7'b1110111;
            dp <= 1;          
        end else if (state_cycle == 2) begin
            an <= 4'b1000;
            seg <= 7'b0110111;
            dp <= 1;          
        end else if (state_cycle == 3) begin
            an <= 4'b0000;
            seg <= 7'b0110110;
            dp <= 1;         
        end else if (state_cycle == 4) begin
            an <= 4'b0000;
            seg <= 7'b0000110;
            dp <= 0;     
        end else begin
            seg = 7'b0000000; // l
            dp = 'b1;
            an = 4'b1110;
        end
    end
    
    /* --- Button Code -------------------------------------------*/
    reg prev_btnC=0, prev_btnU=0, prev_btnL=0, prev_btnR=0, prev_btnD=0;
    always @ (posedge clk) begin
        if (prev_btnL == 0 && btnL == 1) begin
            cycle_up <= 0;
        end
        
        if (prev_btnR == 0 && btnR == 1) begin
            cycle_up <= 1;
        end
        prev_btnC <= btnC; prev_btnU <= btnU; prev_btnL <= btnL; 
        prev_btnR <= btnR; prev_btnD <= btnD;
    end
    
    /* --- LED -------------------------------------------*/
    wire [15:0] led_clock = clk_p75hz ? ~16'b0 : 16'b0;
    assign led = sw & led_clock;
endmodule