`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.08.2018 17:38:47
// Design Name: 
// Module Name: draw_start_background
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


module draw_start_background (
  input wire [10:0] vcount_in,
  input wire vsync_in,
  input wire vblnk_in,
  input wire [10:0] hcount_in,
  input wire hsync_in,
  input wire hblnk_in,
  input wire clk,
  input wire rst,
  
  output reg [10:0] vcount_out,
  output reg vsync_out,
  output reg vblnk_out,
  output reg [10:0] hcount_out,
  output reg hsync_out,
  output reg hblnk_out,
  output reg [11:0] rgb_out
  );
  
  reg [11:0] rgb_out_nxt;
       
  always @(posedge clk)
    begin
        if(rst)begin
            vcount_out <= 0;
            hcount_out <= 0;
                
            vsync_out <= 0;
            vblnk_out <= 0;
            hsync_out <= 0;
            hblnk_out <= 0;
                
            rgb_out <= 0;
        end
        else begin
            vcount_out <= vcount_in;
            hcount_out <= hcount_in;
                
            vsync_out <= vsync_in;
            vblnk_out <= vblnk_in;                
            hsync_out <= hsync_in;
            hblnk_out <= hblnk_in;
                
            rgb_out <= rgb_out_nxt;
         end
    end
    
    always @*
        begin
            // During blanking, make it it black.
            if (vblnk_in || hblnk_in) rgb_out_nxt <= 12'h0_0_0; 
            else
            begin
             // Active display, top edge, make a yellow line.
              if (vcount_in == 0) rgb_out_nxt <= 12'hf_f_0;
              // Active display, bottom edge, make a red line.
              else if (vcount_in == 599) rgb_out_nxt <= 12'hf_0_0;
              // Active display, left edge, make a green line.
              else if (hcount_in == 0) rgb_out_nxt <= 12'h0_f_0;
              // Active display, right edge, make a blue line.
              else if (hcount_in == 799) rgb_out_nxt <= 12'h0_0_f;
              // Active display, interior, fill with gray.
              
              else rgb_out_nxt <= 12'hd_d_d;
            
            end
        end     
endmodule

