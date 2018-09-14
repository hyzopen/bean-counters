`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2018 00:22:44
// Design Name: 
// Module Name: vga_ctl
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


module vga_ctl(
    input wire clk40,
    input wire rst,
    input wire [11:0] xpos_p,
    input wire enable_second,
    input wire enable_third,
    input wire [7:0] ones,
    input wire [7:0] tens,
    input wire [7:0] hundreds,
    input wire start,
    input wire replay,
    input wire left,
    input wire right,
    input wire [3:0] held_bags_out,
    
    output wire vs,
    output wire hs,
    output wire [11:0] rgb,
    output wire restart,
    output wire end_game,
    output wire [7:0] held_bags
    
    );
    


    
    wire [10:0] vcount, hcount;
    wire vsync, hsync;
    wire vblnk, hblnk;
    
    vga_timing my_timing (
		.pclk(clk40),
        .rst(rst),
        .vcount(vcount),
        .vsync(vsync),
        .vblnk(vblnk),
        .hcount(hcount),
        .hsync(hsync),
        .hblnk(hblnk)
		);
    

    
    wire [10:0] vcount_out_bg, hcount_out_bg;
    wire vsync_out_bg, hsync_out_bg;
    wire vblnk_out_bg, hblnk_out_bg;
    wire [11:0] rgb_out_bg;
    
    draw_background my_background (
        .vcount_in(vcount),
        .vsync_in(vsync),
        .vblnk_in(vblnk),
        .hcount_in(hcount),
        .hsync_in(hsync),
        .hblnk_in(hblnk),
        .pclk(clk40),
        .rst(rst),
        
        .hcount_out(hcount_out_bg),
        .hsync_out(hsync_out_bg),
        .hblnk_out(hblnk_out_bg),
        .vcount_out(vcount_out_bg),
        .vsync_out(vsync_out_bg),
        .vblnk_out(vblnk_out_bg),
        .rgb_out(rgb_out_bg)
      );
      

	  
 
    wire [10:0] vcount_out, hcount_out;
    wire vsync_out, hsync_out;
    wire vblnk_out, hblnk_out;
    wire [11:0] rgb_out;
    wire [11:0] rgb_pixel; 
    wire [13:0] address;
        
    draw_rect draw_peng (
        .pclk(clk40),
        .rst(rst),
        .vcount_in(vcount_out_bg),
        .vsync_in(vsync_out_bg),
        .vblnk_in(vblnk_out_bg),
        .hcount_in(hcount_out_bg),
        .hsync_in(hsync_out_bg),
        .hblnk_in(hblnk_out_bg),
        .rgb_in(rgb_out_bg),
        .xpos(xpos_p),
        .ypos(450),
            
        .rgb_pixel(rgb_pixel),
            
        .hcount_out(hcount_out),
        .hsync_out(hsync_out),
        .hblnk_out(hblnk_out),
        .vcount_out(vcount_out),
        .vsync_out(vsync_out),
        .vblnk_out(vblnk_out),
        .pixel_addr(address),
        .rgb_out(rgb_out)
        );
      


    
    ////////////////////////////////////////////////////////
    //////////          rom module           ///////////////
    ////////////////////////////////////////////////////////
    
    image_rom peng_rom(
		.clk(clk40),
        .address(address),
            
        .rgb(rgb_pixel)
        );
    
   
    wire [10:0] hcount_out_b, vcount_out_b;
    wire hsync_out_b, vsync_out_b;
    wire vblnk_out_b, hblnk_out_b;
    wire [11:0] rgb_out_b;
    wire[7:0] missed_bags;
    wire [7:0] random_number;
                  
    number_generator number_generator(
        .clk(clk40),
        .rst(rst),
                    
        .random_number(random_number)
        );   
                         
                 
    draw_bags draw_bags(
        .pclk(clk40),
        .rst(rst),
        .xpos_in(xpos_p),
        .restart(restart),
        .hcount(hcount_out),
        .vcount(vcount_out),
        .hsync(hsync_out),
        .vsync(vsync_out),
        .vblnk(vblnk_out),
        .hblnk(hblnk_out),
        .rgb(rgb_out),
        .enable_second(enable_second),
        .enable_third(enable_third),
        .random_number(random_number),
                      
        .hcount_out(hcount_out_b),
        .vcount_out(vcount_out_b),
        .hsync_out(hsync_out_b),
        .vsync_out(vsync_out_b),
        .hblnk_out(hblnk_out_b),
        .vblnk_out(vblnk_out_b),
        .rgb_out(rgb_out_b),
        .held_bags(held_bags),
        .missed_bags(missed_bags)
        ); 
                      

//char score control
      
    wire [10:0] hcount_out_c, vcount_out_c;
    wire hsync_out_c, vsync_out_c;
    wire vblnk_out_c, hblnk_out_c;
    wire [11:0] rgb_out_c;
    wire [7:0] char_pixels, char_xy;
    wire [3:0] char_line;
    wire [6:0] char_code;
    wire [10:0] addr;
                
    draw_rect_char # (
    .X_UP_LEFT_CORNER(543),
    .Y_UP_LEFT_CORNER(50)
    )
    draw_rect_char_score(
        .pclk(clk40),
		.rst(rst),
        .hcount_in(hcount_out_b),
        .hsync_in(hsync_out_b),
        .hblnk_in(hblnk_out_b),
        .vcount_in(vcount_out_b),
        .vsync_in(vsync_out_b),
        .vblnk_in(vblnk_out_b),
        .rgb_in(rgb_out_b),
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
                
    char_score char_score(
        .char_xy(char_xy),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds),
                  
        .char_code(char_code)
        );
                
    assign addr = {char_code, char_line};
                
    font_rom font_rom_score(
        .clk(clk40),
        .addr(addr),
        .char_line_pixels(char_pixels)
        );   
     
     

//char carried bags control
                  
    wire [10:0] hcount_out_h, vcount_out_h;
    wire hsync_out_h, vsync_out_h;
    wire vblnk_out_h, hblnk_out_h;
    wire [11:0] rgb_out_h;
    wire [7:0] char_pixels_1, char_xy_1;
    wire [3:0] char_line_1;
    wire [6:0] char_code_1;
    wire [10:0] addr_1;
                            
    draw_rect_char # (
    .X_UP_LEFT_CORNER(671),
    .Y_UP_LEFT_CORNER(50)
    )
    draw_rect_char_held(
        .pclk(clk40),
		.rst(rst),
        .hcount_in(hcount_out_c),
        .hsync_in(hsync_out_c),
        .hblnk_in(hblnk_out_c),
        .vcount_in(vcount_out_c),
        .vsync_in(vsync_out_c),
        .vblnk_in(vblnk_out_c),
        .rgb_in(rgb_out_c),
        .char_pixels(char_pixels_1),
                              
        .hcount_out(hcount_out_h),
        .hsync_out(hsync_out_h),
        .hblnk_out(hblnk_out_h),
        .vcount_out(vcount_out_h),
        .vsync_out(vsync_out_h),
        .vblnk_out(vblnk_out_h),
        .rgb_out(rgb_out_h),
        .char_xy(char_xy_1),
        .char_line(char_line_1)
        ); 
                            
    char_peng_bags char_held(
        .clk(clk40),
        .rst(rst),
        .char_xy(char_xy_1),
        .peng_bags(held_bags_out),
                              
        .char_code(char_code_1)
        );
                            
    assign addr_1 = {char_code_1, char_line_1};
                            
    font_rom font_rom_held(
        .clk(clk40),
        .addr(addr_1),
        .char_line_pixels(char_pixels_1)
        );   
                 
     
    
     
 //char life control
    wire [10:0] hcount_out_l, vcount_out_l;
    wire hsync_out_l, vsync_out_l;
    wire vblnk_out_l, hblnk_out_l;
    wire [11:0] rgb_out_l;
    wire [7:0] char_pixels_2, char_xy_2;
    wire [3:0] char_line_2;
    wire [6:0] char_code_2;
    wire [10:0] addr_2;
                                                     
    draw_rect_char # (
    .X_UP_LEFT_CORNER(415),
    .Y_UP_LEFT_CORNER(50),
    .TEXT_COLOR (12'hf_0_0),
    .TEXT_HEIGHT(1)
    )
    draw_rect_char_life(
        .pclk(clk40),
		.rst(rst),
        .hcount_in(hcount_out_h),
        .hsync_in(hsync_out_h),
        .hblnk_in(hblnk_out_h),
        .vcount_in(vcount_out_h),
        .vsync_in(vsync_out_h),
        .vblnk_in(vblnk_out_h),
        .rgb_in(rgb_out_h),
        .char_pixels(char_pixels_2),
                                                     
        .hcount_out(hcount_out_l),
        .hsync_out(hsync_out_l),
        .hblnk_out(hblnk_out_l),
        .vcount_out(vcount_out_l),
        .vsync_out(vsync_out_l),
        .vblnk_out(vblnk_out_l),
        .rgb_out(rgb_out_l),
        .char_xy(char_xy_2),
        .char_line(char_line_2)
        ); 
    
    char_life char_life(
        .clk(clk40),
        .rst(rst),
        .char_xy(char_xy_2),
        .missed_bags(missed_bags),
                                                     
        .char_code(char_code_2)
        );
                                                   
    assign addr_2 = {char_code_2, char_line_2};
                                                   
    font_rom font_rom_life(
        .clk(clk40),
        .addr(addr_2),
        .char_line_pixels(char_pixels_2)
        );   
                         
                         
                         
    wire [10:0] hcount_out_st, vcount_out_st;
    wire hsync_out_st, vsync_out_st, hblnk_out_st, vblnk_out_st;
    wire [11:0] rgb_out_st;                 
                         
    draw_start draw_start(
        .clk_s(clk40),
        .rst(rst),
        .vcount_in(vcount_out_l),
        .vsync_in(vsync_out_l),
        .vblnk_in(vblnk_out_l),
        .hcount_in(hcount_out_l),
        .hsync_in(hsync_out_l),
        .hblnk_in(hblnk_out_l),
                                                        
        .vcount_out(vcount_out_st),
        .vsync_out(vsync_out_st),
        .vblnk_out(vblnk_out_st),
        .hcount_out(hcount_out_st),
        .hsync_out(hsync_out_st),
        .hblnk_out(hblnk_out_st),
        .rgb_out(rgb_out_st)
                                                   
        );               
        
    wire [10:0] hcount_out_e, vcount_out_e;
    wire hsync_out_e, vsync_out_e, hblnk_out_e, vblnk_out_e;
    wire [11:0] rgb_out_e;                 
                            
    draw_end draw_end(
        .clk_e(clk40),
        .rst(rst),
        .vcount_in(vcount_out_st),
        .vsync_in(vsync_out_st),
        .vblnk_in(vblnk_out_st),
        .hcount_in(hcount_out_st),
        .hsync_in(hsync_out_st),
        .hblnk_in(hblnk_out_st),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds),
                                                           
        .vcount_out(vcount_out_e),
        .vsync_out(vsync_out_e),
        .vblnk_out(vblnk_out_e),
        .hcount_out(hcount_out_e),
        .hsync_out(hsync_out_e),
        .hblnk_out(hblnk_out_e),
        .rgb_out(rgb_out_e)
		);         
           
        
 
    menu_ctl menu(
        .clk(clk40),
        .rst(rst),
        .start(start),
        .replay(replay),
        .mouse_left(left),
        .mouse_right(right),
        .missed_bags(missed_bags),
        .held_bags(held_bags_out),
        .hsync_s(hsync_out_st),
        .vsync_s(vsync_out_st),
        .rgb_s(rgb_out_st),
        .hsync_g(hsync_out_l),
        .vsync_g(vsync_out_l),
        .rgb_g(rgb_out_l),
        .hsync_e(hsync_out_e),
        .vsync_e(vsync_out_e),
        .rgb_e(rgb_out_e),
                   
        .restart(restart),
        .end_game(end_game),
        .hsync_out(hs),
        .vsync_out(vs),
        .rgb_out(rgb)
        );
           
            
endmodule
