`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2018 18:38:33
// Design Name: 
// Module Name: draw_end
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


module draw_end(
     input wire clk_e,
     input wire rst,
     input wire [10:0] vcount_in,
     input wire vsync_in,
     input wire vblnk_in,
     input wire [10:0] hcount_in,
     input wire hsync_in,
     input wire hblnk_in,
     input wire [7:0] ones,
     input wire [7:0] tens,
     input wire [7:0] hundreds,
     
     output wire [10:0] vcount_out,
     output wire vsync_out,
     output wire vblnk_out,
     output wire [10:0] hcount_out,
     output wire hsync_out,
     output wire hblnk_out,
     output wire [11:0] rgb_out

    );
    
wire [10:0] hcount_out_d, vcount_out_d, hcount_out_c, vcount_out_c;
wire hsync_out_d, vsync_out_d, hblnk_out_d, vblnk_out_d, hsync_out_c, vsync_out_c, hblnk_out_c, vblnk_out_c;
wire [11:0] rgb_out_d, rgb_out_c;

draw_end_background my_draw_end_bckground(
      .vcount_in(vcount_in),
      .vsync_in(vsync_in),
      .vblnk_in(vblnk_in),
      .hcount_in(hcount_in),
      .hsync_in(hsync_in),
      .hblnk_in(hblnk_in),
      .clk(clk_e),
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
 .TEXT_HEIGHT(2)
 )
my_draw_rect_char_end(
    .pclk(clk_e),
    .hcount_in(hcount_out_d),
    .hsync_in(hsync_out_d),
    .hblnk_in(hblnk_out_d),
    .vcount_in(vcount_out_d),
    .vsync_in(vsync_out_d),
    .vblnk_in(vblnk_out_d),
    .rgb_in(rgb_out_d),
    .char_pixels(char_pixels),
                    
    .hcount_out(hcount_out_c),
    .hsync_out(hsync_out_c),
    .hblnk_out(hblnk_out_c),
    .vcount_out(vcount_out_c),
    .vsync_out(vsync_out_c),
    .vblnk_out(vblnk_out_c),
    .rgb_out(rgb_out_c),
    .char_xy(char_xy),
    .char_line(char_line)
    ); 
                  
char_end my_char_end(
    .char_xy(char_xy),
                    
    .char_code(char_code)
    );
                  
assign addr = {char_code, char_line};
                  
 font_rom my_font_rom_end(
    .clk(clk_e),
    .addr(addr),
    .char_line_pixels(char_pixels)
    );   
       
 wire [7:0] char_pixels_s, char_xy_s;
    wire [3:0] char_line_s;
    wire [6:0] char_code_s;
    wire [10:0] addr_s;
                      
    draw_rect_char # (
     .X_UP_LEFT_CORNER(336),
     .Y_UP_LEFT_CORNER(276),
     .TEXT_HEIGHT(3)
     )
    my_draw_rect_char_end_s(
        .pclk(clk_e),
        .hcount_in(hcount_out_c),
        .hsync_in(hsync_out_c),
        .hblnk_in(hblnk_out_c),
        .vcount_in(vcount_out_c),
        .vsync_in(vsync_out_c),
        .vblnk_in(vblnk_out_c),
        .rgb_in(rgb_out_c),
        .char_pixels(char_pixels_s),
                        
        .hcount_out(hcount_out),
        .hsync_out(hsync_out),
        .hblnk_out(hblnk_out),
        .vcount_out(vcount_out),
        .vsync_out(vsync_out),
        .vblnk_out(vblnk_out),
        .rgb_out(rgb_out),
        .char_xy(char_xy_s),
        .char_line(char_line_s)
        ); 
                      
    char_end_score my_char_end_s(
        .char_xy(char_xy_s),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds),
                        
        .char_code(char_code_s)
        );
                      
    assign addr_s = {char_code_s, char_line_s};
                      
     font_rom my_font_rom_end_s(
        .clk(clk_e),
        .addr(addr_s),
        .char_line_pixels(char_pixels_s)
        );   
              
             
endmodule
