`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2023 04:40:22 PM
// Design Name: 
// Module Name: module_pack
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


module module_pack(
        input clk,        
        input clk_2,
        input clk_6p25MHz,  
        input rst,
        input rastSW,                 
        input input_val,                    
        input [9:0] X_in, 
        input [9:0] Y_in,
        output reg [15:0] nums,
        output [3:0] digit,                    
        output reg [10:0] LED
    );
        
        reg nn_rst = 0;   
        reg [31:0] rst_counter = 32'b0; 
        // These are required to trigger NN flag
        reg [9:0] MOUSE_X_POS = 0;
        reg [9:0] MOUSE_Y_POS = 0;
        reg rmb = 0;
        reg [11:0] pixel_addr = 0;
        reg [9:0] h_cnt = 0; //640
        reg [9:0] v_cnt = 0;  //480
        reg canvas_valid = 0;  
        reg ct_value = 0;      
//        always @ (posedge clk_6p25MHz) begin                      
//           h_cnt = X_in;
//           v_cnt = Y_in;
//        end
        always @ (posedge clk) begin // , posedge rst
            //pixel_addr = h_cnt + v_cnt*56;
            pixel_addr = X_in + Y_in*56;
            // To avoid bouncing problem, we set a delay in reset, about 10ms to 100ms
            if (rst || (rst_counter > 0)) begin
                nn_rst = 1'b1;
                rst_counter = (rst_counter > 9_999_999) ? 0 : rst_counter + 1;
                ct_value = 1'b0;
                canvas_valid = 1'b0;
                MOUSE_X_POS = 0;
                MOUSE_Y_POS = 0;
            end else begin 
                nn_rst = 1'b0;
                ct_value = input_val;
                canvas_valid = 1'b1;
                MOUSE_X_POS = X_in << 3;
                MOUSE_Y_POS = Y_in << 3;
            end 
                             
        end
        
        wire pixel;
        wire [11:0] writeAddr;
        wire writeEnable;
        wire writeData;
        // The memory control for canvas.
        blk_mem_gen_0 blk_mem_gen_0_inst(
            /* Write */
            .clka(clk),
            .wea(writeEnable),
            .addra(writeAddr),
            .dina(writeData),
            /* Read */
            .addrb(pixel_addr),
            .clkb(clk),
            .doutb(pixel)
        );
        
        CanvasTransfer ct_inst(
                .clk(clk),
                .rst(rst),
                .rast(rastSW),
                .rmb(nn_rst),
                .lmb(ct_value),
                .mmb(1'b0),
                .x(MOUSE_X_POS),
                .y(MOUSE_Y_POS),
                .addr(writeAddr),
                .enable(writeEnable),
                .data(writeData)
            );
        
     
        // Neural net portion
        // Do not change anything here or on your own risk
            
        wire digit_valid;
        wire [9:0] addr_img;
        wire val_img;
        wire [15:0] addr_const;
        wire signed [15:0] val_const;
        wire [6:0] addr_inter;
        wire signed [63:0] val_inter;
        wire [6:0] addr_out;
        wire out_valid;
        wire signed [63:0] val_out;
    
        reg imgw_valid;
        reg [9:0] addr_imgw;
        reg val_imgw;
        reg nn_algo_rst = 0; //I use separate reg rst for safety purpose. If confident, can send same NN_RST into Neural_Net Module's RST        
        
         // ---------------- XXXX -----------------------    
        always@(posedge clk_2, posedge nn_rst) begin 
            if (nn_rst) begin    
                nn_algo_rst = 1'b1;            
                imgw_valid = 0;
                addr_imgw = 0;
                val_imgw = 0;
                LED = 11'b0;
                nums = 16'hffff;                                   
            end else begin
                nn_algo_rst  = 1'b0;
                // Update pixels?
                if (canvas_valid && pixel_addr % 112 < 56 && pixel_addr[0] == 1'b0) begin
                    //TODO see pixel result.
                    imgw_valid = 1;
                    addr_imgw = pixel_addr / 112 * 28 + (pixel_addr % 112 / 2);
                    val_imgw = pixel;                    
                    // TODO: Stop updating while nn.
                end else begin
                    imgw_valid = 0;
                end
                // This portion to obtain and store the final output from Neural_Net module
                if (digit_valid) begin
                    // Save LED data.
                    // Start next cycle.
                    LED[10:0] = 11'b0;
                    LED[digit] = 1'b1;
                    nums[3:0] = digit;
                    nums[7:4] = digit;
                    nums[11:8] = digit;
                    nums[15:12] = digit;
                    nn_algo_rst = 1'b1;
                end else begin                   
                    nn_algo_rst = 1'b0;
                end
            end
            LED[10] = nn_rst ? 1 : 0;
        end
        
        blk_mem_gen_img blk_mem_gen_img_inst(
            /* Write */
            .clka(clk),
            .wea(imgw_valid/*1'b0*/),
            .addra(addr_imgw),
            .dina(val_imgw),
            /* Read */
            .addrb(addr_img),
            .clkb(clk_2),
            .doutb(val_img)
        );
    
        blk_mem_gen_const blk_mem_gen_const_inst(
            /* Read */
            .clka(clk_2),
            .wea(1'b0),
            .addra(addr_const),
            .dina(16'b0),
            .douta(val_const)
        );
        
    
        blk_mem_gen_inter blk_mem_gen_inter_inst(
            /* Write */
            .clka(clk_2),
            .wea(out_valid),
            .addra(addr_out),
            .dina(val_out),
            /* Read */
            .addrb(addr_inter),
            .clkb(clk_2),
            .doutb(val_inter)
        );
    
        neural_net nn1(.clk(clk_2),
                       .rst(nn_algo_rst),
                       .digit(digit),
                       .digit_valid(digit_valid),
                       .addr_img(addr_img),
                       .val_img(val_img),
                       .addr_const(addr_const),
                       .val_const(val_const),
                       .addr_inter(addr_inter),
                       .val_inter(val_inter),
                       .addr_out(addr_out),
                       .out_valid(out_valid),
                       .val_out(val_out)
        );
        
    
endmodule