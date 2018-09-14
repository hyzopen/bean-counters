`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2018 20:11:28
// Design Name: 
// Module Name: draw_rect_char
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
module draw_rect_char
    # ( parameter
        X_UP_LEFT_CORNER = 0,
        Y_UP_LEFT_CORNER = 0,
        TEXT_COLOR       = 12'h0_0_0,
        TEXT_WIDTH       = 16,
        TEXT_HEIGHT      = 2
    )
    (  
    input wire        pclk,
	input wire 		  rst,
    input wire [10:0] hcount_in,
    input wire        hsync_in,
    input wire        hblnk_in,
    input wire [10:0] vcount_in,
    input wire        vsync_in,
    input wire        vblnk_in,
    input wire [11:0] rgb_in,
    input wire [7:0]  char_pixels,
    
    output reg [10:0] hcount_out,
    output reg        hsync_out,
    output reg        hblnk_out,
    output reg [10:0] vcount_out,   
    output reg        vsync_out,
    output reg        vblnk_out,
    output reg [11:0] rgb_out,
    output reg [7:0]  char_xy,
    output reg [3:0]  char_line
    );



    
    reg [10:0] hcount_in_1, hcount_in_2, hcount_in_3;
    reg hsync_in_1, hsync_in_2, hsync_in_3;
    reg hblnk_in_1, hblnk_in_2, hblnk_in_3;
    reg [10:0] vcount_in_1, vcount_in_2, vcount_in_3;
    reg vsync_in_1, vsync_in_2, vsync_in_3;
    reg vblnk_in_1, vblnk_in_2, vblnk_in_3;
    reg [11:0] rgb_in_1, rgb_in_2, rgb_in_3;
    

                    
    reg [3:0] pixel_index = 0;
	reg [11:0] rgb_in_nxt = 0, rgb_out_nxt = 0;
    reg [3:0] char_line_nxt = 0;
    reg [7:0] char_xy_nxt = 0;
    reg [10:0] hcount_temp = 0;
    reg [10:0] vcount_temp = 0;
    

    always @(posedge pclk)begin
        if(rst) begin
            hsync_in_1  <= 0;
            vsync_in_1  <= 0;
            hblnk_in_1  <= 0;
            vblnk_in_1  <= 0;
            hcount_in_1 <= 0;
            vcount_in_1 <= 0;
            rgb_in_1    <= 0;
            hsync_in_2  <= 0;
            vsync_in_2  <= 0;
            hblnk_in_2  <= 0;
            vblnk_in_2  <= 0;
            hcount_in_2 <= 0;
            vcount_in_2 <= 0;
            rgb_in_2    <= 0;
            hsync_out   <= 0;
            vsync_out   <= 0;
            hblnk_out   <= 02;
            vblnk_out   <= 0;
            hcount_out  <= 0;
            vcount_out  <= 0;
            rgb_out     <= 0;
            char_xy     <= 0;
            char_line   <= 0;
        end
        else begin
    // Just pass these through. 
            hsync_in_1 <= hsync_in;
            vsync_in_1 <= vsync_in;
            hblnk_in_1 <= hblnk_in;
            vblnk_in_1 <= vblnk_in;
            hcount_in_1 <= hcount_in;
            vcount_in_1 <= vcount_in;
            
            rgb_in_1 <= rgb_in;
        
            hsync_in_2 <= hsync_in_1;
            vsync_in_2 <= vsync_in_1;
            hblnk_in_2 <= hblnk_in_1;
            vblnk_in_2 <= vblnk_in_1;
            hcount_in_2 <= hcount_in_1;
            vcount_in_2 <= vcount_in_1;
            
            rgb_in_2 <= rgb_in_1;

            hsync_out <= hsync_in_2;
            vsync_out <= vsync_in_2;
            hblnk_out <= hblnk_in_2;
            vblnk_out <= vblnk_in_2;
            hcount_out <= hcount_in_2;
            vcount_out <= vcount_in_2;
            rgb_out <= rgb_out_nxt;
            char_xy <= char_xy_nxt;
            char_line <= char_line_nxt;
        end
    end    

        
   always @*
            begin
                rgb_out_nxt = rgb_in_2;
                char_xy_nxt = char_xy;
                char_line_nxt = 0;
                pixel_index = 0;
                hcount_temp = hcount_in - X_UP_LEFT_CORNER;
                vcount_temp = vcount_in - Y_UP_LEFT_CORNER;
                if((hcount_out >= X_UP_LEFT_CORNER) && (hcount_out < X_UP_LEFT_CORNER + 8*TEXT_WIDTH) && (vcount_out >= Y_UP_LEFT_CORNER) &&(vcount_out < Y_UP_LEFT_CORNER + 16*TEXT_HEIGHT)) begin  
                    pixel_index = (hcount_out - X_UP_LEFT_CORNER) % 8;
                    if(char_pixels[7-pixel_index] == 1) begin
                        rgb_out_nxt = TEXT_COLOR;
                    end  
                    //else rgb_out_nxt = 12'h0_f_f;          
                end
                if((hcount_in >= X_UP_LEFT_CORNER) && (hcount_in < X_UP_LEFT_CORNER + 8*TEXT_WIDTH) && (vcount_in >= Y_UP_LEFT_CORNER) &&(vcount_in < Y_UP_LEFT_CORNER + 16*TEXT_HEIGHT)) begin
                    char_line_nxt   = vcount_temp[3:0];
                    char_xy_nxt     = {vcount_temp[7:4], hcount_temp[6:3]};
                    
                end         
            end
endmodule