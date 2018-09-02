`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2018 18:01:52
// Design Name: 
// Module Name: draw_start
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


module draw_start(
     input wire clk_s,
     input wire rst,
     input wire [10:0] vcount_in,
     input wire vsync_in,
     input wire vblnk_in,
     input wire [10:0] hcount_in,
     input wire hsync_in,
     input wire hblnk_in,
     
     output wire [10:0] vcount_out,
     output wire vsync_out,
     output wire vblnk_out,
     output wire [10:0] hcount_out,
     output wire hsync_out,
     output wire hblnk_out,
     output wire [11:0] rgb_out

    );
    
wire [10:0] hcount_out_d, vcount_out_d;
wire hsync_out_d, vsync_out_d, hblnk_out_d, vblnk_out_d;
wire [11:0] rgb_out_d;

draw_start_background my_draw_start_bckground(
      .vcount_in(vcount_in),
      .vsync_in(vsync_in),
      .vblnk_in(vblnk_in),
      .hcount_in(hcount_in),
      .hsync_in(hsync_in),
      .hblnk_in(hblnk_in),
      .clk(clk_s),
      .rst(rst),
      
      .vcount_out(vcount_out_d),
      .vsync_out(vsync_out_d),
      .vblnk_out(vblnk_out_d),
      .hcount_out(hcount_out_d),
      .hsync_out(hsync_out_d),
      .hblnk_out(hblnk_out_d),
      .rgb_out(rgb_out_d)
      );
      

//wire [10:0] hcount_out_c, vcount_out_c;
//wire hsync_out_c, vsync_out_c;
//wire vblnk_out_c, hblnk_out_c;
//wire [11:0] rgb_out_c;
                     
wire [7:0] char_pixels, char_xy;
wire [3:0] char_line;
wire [6:0] char_code;
wire [10:0] addr;
                  
draw_rect_char # (
 .X_UP_LEFT_CORNER(336),
 .Y_UP_LEFT_CORNER(400),
 .TEXT_HEIGHT(1)
 )
my_draw_rect_char_st(
    .pclk(clk_s),
    .hcount_in(hcount_out_d),
    .hsync_in(hsync_out_d),
    .hblnk_in(hblnk_out_d),
    .vcount_in(vcount_out_d),
    .vsync_in(vsync_out_d),
    .vblnk_in(vblnk_out_d),
    .rgb_in(rgb_out_d),
    .char_pixels(char_pixels),
                    
    .hcount_out(hcount_out),
    .hsync_out(hsync_out),
    .hblnk_out(hblnk_out),
    .vcount_out(vcount_out),
    .vsync_out(vsync_out),
    .vblnk_out(vblnk_out),
    .rgb_out(rgb_out),
    .char_xy(char_xy),
    .char_line(char_line)
    ); 
                  
char_start my_char_start(
    .char_xy(char_xy),
                    
    .char_code(char_code)
    );
                  
assign addr = {char_code, char_line};
                  
 font_rom my_font_rom_st(
    .clk(clk_s),
    .addr(addr),
    .char_line_pixels(char_pixels)
    );   
       
             
endmodule
