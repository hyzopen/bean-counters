`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2018 08:57:47
// Design Name: 
// Module Name: draw_background
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 

//////////////////////////////////////////////////////////////////////////////////


module draw_background(
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [10:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire pclk,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,  
    output reg [11:0] rgb_out
    );
    

reg [11:0] rgb_new;
reg[10:0] x = 320;

always @(posedge pclk)
          begin
            hcount_out <= hcount_in;
            hsync_out <= hsync_in;
            hblnk_out <=  hblnk_in; 
            vcount_out <=  vcount_in;
            vsync_out <= vsync_in;
            vblnk_out <= vblnk_in;
            rgb_out <=  rgb_new;
         end
    
always @*
      begin
        // During blanking, make it it black.
    if (vblnk_in || hblnk_in) rgb_new <= 12'h0_0_0; 
        else
        begin
    
          // Active display, top edge, make a yellow line.
         if (vcount_in == 0) rgb_new <= 12'hf_f_0;
          // Active display, bottom edge, make a red line.
          else if (vcount_in == 599) rgb_new <= 12'hf_0_0;
          // Active display, left edge, make a green line.
          else if (hcount_in == 0) rgb_new <= 12'h0_f_0;
          // Active display, right edge, make a blue line.
          else if (hcount_in == 799) rgb_new <= 12'h0_0_f;
          // Active display, interior, fill with gray.
             else if        ((vcount_in >= 10 && vcount_in <= 160 && hcount_in >= 10 && hcount_in <= 20)
                             ||(vcount_in <= 160 && hcount_in >= 20 && vcount_in >= hcount_in + 60 && vcount_in <= hcount_in +70)
                             ||(vcount_in >= 10 && hcount_in >= 20 && vcount_in >= - hcount_in + 90 && vcount_in <= - hcount_in + 100)
                             ||(vcount_in>=10 && vcount_in <= 20 && hcount_in >= 120 && hcount_in <= 185)
                             ||(vcount_in>=80 && vcount_in <= 90 && hcount_in >= 120 && hcount_in <= 185)
                             ||(vcount_in>=150 && vcount_in <= 160 && hcount_in >= 120 && hcount_in <= 185)
                             ||(vcount_in>=20 && vcount_in <= 80 && hcount_in >= 175 && hcount_in <= 185)
                             ||(vcount_in>=90 && vcount_in <= 150 && hcount_in >= 120 && hcount_in <= 130)) rgb_new <= 12'h1_f_8;
           else                 
           rgb_new <= 12'hf_f_f;   
        end
      end
    
    endmodule