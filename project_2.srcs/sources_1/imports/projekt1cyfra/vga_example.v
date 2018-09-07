// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  input wire rst,
  input wire start,
  input wire replay,
  
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  output wire pclk_mirror,
  inout wire ps2_clk,
  inout wire ps2_data
  
  );



///////////////////////////////////////////////////////////////
////////////       main clock module           ///////////////
/////////////////////////////////////////////////////////////

wire clk100;
wire clk40;
wire locked;
//wire reset;

clk_wiz_0   clk_main 
 (
  // Clock out ports
  .clk100MHz(clk100),
  .clk40Mhz(clk40),
  // Status and control signals
  .reset(1'b0),
  .locked(locked),
 // Clock in ports
  .clk(clk)
 );
 
////////////////////////////////////////////////////////
 //////////       ODDR module           ///////////////
 ////////////////////////////////////////////////////////  

    ODDR pclk_oddr (
      .Q(pclk_mirror),
      .C(clk40),
      .CE(1'b1),
      .D1(1'b1),
      .D2(1'b0),
      .R(1'b0),
      .S(1'b0)
     );
  
  // Instantiate the vga_timing module, which is
  // the module you are designing for this lab.
  ////////////////////////////////////////////////////////
  //////////       timing module           ///////////////
  ////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////
//////////       background module           ///////////////
///////////////////////////////////////////////////////////

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
  
//////////////////////////////////////////////////////////////
//////////       draw rect module           ///////////////
///////////////////////////////////////////////////////////
  
    wire [11:0] xpos,ypos;  
    wire [11:0] xpos_in, ypos_in;  
    wire [10:0] vcount_out, hcount_out;
    wire vsync_out, hsync_out;
    wire vblnk_out, hblnk_out;
    wire [11:0] rgb_out;
    wire [11:0] rgb_pixel; 
    wire [13:0] address;
    
    draw_rect draw_rect (
        .pclk(clk40),
        .rst(rst),
        .vcount_in(vcount_out_bg),
        .vsync_in(vsync_out_bg),
        .vblnk_in(vblnk_out_bg),
        .hcount_in(hcount_out_bg),
        .hsync_in(hsync_out_bg),
        .hblnk_in(hblnk_out_bg),
        .rgb_in(rgb_out_bg),
        .xpos(xpos_in),
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
//////////       mouse module           ///////////////
////////////////////////////////////////////////////////

wire left, right;

MouseCtl mouse_module (
    .clk(clk100),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos),
    //.ypos(550),
    .left(left),
    .right(right)
    
);

          wire [11:0] xpos_buff,ypos_buff;
          wire [0:3] green_out_m, red_out_m, blue_out_m; 
          

////////////////////////////////////////////////////////
//////////       buffer module           ///////////////
////////////////////////////////////////////////////////



buffer_module buffer_module(
    .clk(clk40),
    .rst(rst),
    .xpos_in(xpos),
    .ypos_in(450),
    
    .xpos_out(xpos_buff),
    .ypos_out(ypos_buff)
);

////////////////////////////////////////////////////////
//////////          rom module           ///////////////
////////////////////////////////////////////////////////

image_rom my_rom(
 
        .clk(clk40),
        .address(address),
        .rgb(rgb_pixel)
        );

 
////////////////////////////////////////////////////////
        //////////           ctl module          ///////////////
        //////////////////////////////////////////////////////// 
        
        draw_rect_ctl my_ctl(
//            .mouse_left(left),
            .clk_in(clk40),
            .rst(rst),
            .mouse_xpos(xpos_buff),
//            .mouse_ypos(ypos_buff),
            .xpos(xpos_in),
            .ypos(ypos_in)
                   
        );  
        
        
        
        
        
        
        
        
        
        
        wire [9:0] random_number;

        
        number_generator my_number_generator(
            .clk(clk40),
            .number(random_number)
            );   
 
            
            wire restart, end_game, enable_second, enable_third;
            
            wire [11:0] xpos_b, ypos_b;  
            
            wire [10:0] hcount_out_b, vcount_out_b;
              wire hsync_out_b, vsync_out_b;
              wire vblnk_out_b, hblnk_out_b;
              wire [11:0] rgb_out_b;
              wire [7:0] bags_peng, bags_peng_1, bags_peng_out, missed_bags, missed_bags_1;
              
              
  //first bag///
  //////////////          
              bag_ctl my_first_bag(
              .clk(clk40),
              .rst(rst),
              .random(random_number),
              .xpos_p(xpos_in),
              .restart(restart),
              .enable_bag(1'b1),
              //.bags_peng_in(bags_peng_1),
              
              .xpos(xpos_b),
              .ypos(ypos_b),
              //.caught_num(caught_num),
              .bags_peng(bags_peng_1),
              .missed_bags(missed_bags_1)
              
            );   
 
           wire [20:0] address_b;   
           wire [11:0] rgb_pixel_b;
          image_rom # (
                  .image_path(""),
                  .x_bit_width(6),
                  .y_bit_width(5)
                  )
                  bag_rom(     
              .clk(clk40),
              .address(address_b),
              .rgb(rgb_pixel_b)
      
        );
        
        
        
        
         draw_rect # (
              .x_bit_width(6),
              .y_bit_width(5)
              )
          my_draw_bag (
            .vcount_in(vcount_out),
            .vsync_in(vsync_out),
            .vblnk_in(vblnk_out),
            .hcount_in(hcount_out),
            .hsync_in(hsync_out),
            .hblnk_in(hblnk_out),
            .rgb_in(rgb_out),
            .pclk(clk40),
            .xpos(xpos_b),  
            .ypos(ypos_b),
            .pixel_addr(address_b),
            .rgb_pixel(rgb_pixel_b),
            .rst(rst),
            
            .hcount_out(hcount_out_b),
            .hsync_out(hsync_out_b),
            .hblnk_out(hblnk_out_b),
            .vcount_out(vcount_out_b),
            .vsync_out(vsync_out_b),
            .vblnk_out(vblnk_out_b),
            .rgb_out(rgb_out_b)
          );

/////////////////////////////////////////////
/////////////////////////////////////////////

//second bag
 wire [11:0] xpos_b2, ypos_b2;  
           
           wire [10:0] hcount_out_b2, vcount_out_b2;
             wire hsync_out_b2, vsync_out_b2;
             wire vblnk_out_b2, hblnk_out_b2;
             wire [11:0] rgb_out_b2;
             wire [7:0] bags_peng_2, missed_bags_2;
             
  bag_ctl my_second_bag(
            .clk(clk40),
            .rst(rst),
            .random(random_number),
            .xpos_p(xpos_in),
            .restart(restart),
            .enable_bag(enable_second),
            //.bags_peng_in(bags_peng_1),
            
            .xpos(xpos_b2),
            .ypos(ypos_b2),
            //.caught_num(caught_num),
            .bags_peng(bags_peng_2),
            .missed_bags(missed_bags_2)
            
          );   

         wire [20:0] address_b2;   
         wire [11:0] rgb_pixel_b2;
        image_rom # (
                .image_path(""),
                .x_bit_width(6),
                .y_bit_width(5)
                )
                second_bag_rom(     
            .clk(clk40),
            .address(address_b2),
            .rgb(rgb_pixel_b2)
    
      );
      
      
      
      
       draw_rect # (
            .x_bit_width(6),
            .y_bit_width(5)
            )
        my_draw_second_bag (
          .vcount_in(vcount_out_b),
          .vsync_in(vsync_out_b),
          .vblnk_in(vblnk_out_b),
          .hcount_in(hcount_out_b),
          .hsync_in(hsync_out_b),
          .hblnk_in(hblnk_out_b),
          .rgb_in(rgb_out_b),
          .pclk(clk40),
          .xpos(xpos_b2),  
          .ypos(ypos_b2),
          .pixel_addr(address_b2),
          .rgb_pixel(rgb_pixel_b2),
          .rst(rst),
          
          .hcount_out(hcount_out_b2),
          .hsync_out(hsync_out_b2),
          .hblnk_out(hblnk_out_b2),
          .vcount_out(vcount_out_b2),
          .vsync_out(vsync_out_b2),
          .vblnk_out(vblnk_out_b2),
          .rgb_out(rgb_out_b2)
        );

//third bag
/////////////////////////////
 wire [11:0] xpos_b3, ypos_b3;  
           
           wire [10:0] hcount_out_b3, vcount_out_b3;
             wire hsync_out_b3, vsync_out_b3;
             wire vblnk_out_b3, hblnk_out_b3;
             wire [11:0] rgb_out_b3;
             wire [7:0] bags_peng_3, missed_bags_3;
             
  bag_ctl my_third_bag(
            .clk(clk40),
            .rst(rst),
            .random(random_number),
            .xpos_p(xpos_in),
            .restart(restart),
            .enable_bag(enable_third),
            //.bags_peng_in(bags_peng_1),
            
            .xpos(xpos_b3),
            .ypos(ypos_b3),
            //.caught_num(caught_num),
            .bags_peng(bags_peng_3),
            .missed_bags(missed_bags_3)
            
          );   

         wire [20:0] address_b3;   
         wire [11:0] rgb_pixel_b3;
        image_rom # (
                .image_path(""),
                .x_bit_width(6),
                .y_bit_width(5)
                )
                third_bag_rom(     
            .clk(clk40),
            .address(address_b3),
            .rgb(rgb_pixel_b3)
    
      );
      
      
      
      
       draw_rect # (
            .x_bit_width(6),
            .y_bit_width(5)
            )
        my_draw_third_bag (
          .vcount_in(vcount_out_b2),
          .vsync_in(vsync_out_b2),
          .vblnk_in(vblnk_out_b2),
          .hcount_in(hcount_out_b2),
          .hsync_in(hsync_out_b2),
          .hblnk_in(hblnk_out_b2),
          .rgb_in(rgb_out_b2),
          .pclk(clk40),
          .xpos(xpos_b3),  
          .ypos(ypos_b3),
          .pixel_addr(address_b3),
          .rgb_pixel(rgb_pixel_b3),
          .rst(rst),
          
          .hcount_out(hcount_out_b3),
          .hsync_out(hsync_out_b3),
          .hblnk_out(hblnk_out_b3),
          .vcount_out(vcount_out_b3),
          .vsync_out(vsync_out_b3),
          .vblnk_out(vblnk_out_b3),
          .rgb_out(rgb_out_b3)
        );

wire [7:0] ones, tens, hundreds, score;


    bag_enable my_bags_enable(
        .clk(clk40),
        .rst(rst),
        .score(score),
        .restart(restart),
        
        .enable_second(enable_second),
        .enable_third(enable_third)
        );

    score_conv my_score_conv (
        .clk(clk40),
        .rst(rst),
        .caught_num(score),
        .end_game(end_game),
        
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds)
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
    my_draw_rect_char(
        .pclk(clk40),
        .hcount_in(hcount_out_b3),
        .hsync_in(hsync_out_b3),
        .hblnk_in(hblnk_out_b3),
        .vcount_in(vcount_out_b3),
        .vsync_in(vsync_out_b3),
        .vblnk_in(vblnk_out_b3),
        .rgb_in(rgb_out_b3),
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
            
    char_score my_char_score(
        .char_xy(char_xy),
        .ones(ones),
        .tens(tens),
        .hundreds(hundreds),
              
        .char_code(char_code)
    );
            
    assign addr = {char_code, char_line};
            
    font_rom my_font_rom(
        .clk(clk40),
        .addr(addr),
        .char_line_pixels(char_pixels)
    );   
 
 
 //
 assign bags_peng = bags_peng_1 + bags_peng_2 + bags_peng_3;
 
    peng_bags_ctl my_peng_bags_ctl(
        .clk(clk40),
        .rst(rst),
        .restart(restart),
        .xpos_p(xpos_in),
        .mouse_left(left),
        .bags_peng_in(bags_peng),
              
        .bags_peng_out(bags_peng_out),
        .score(score)
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
    my_draw_rect_char_h(
        .pclk(clk40),
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
                        
    char_peng_bags my_char_held_bags(
        .clk(clk40),
        .rst(rst),
        .char_xy(char_xy_1),
        .peng_bags(bags_peng_out),
                          
        .char_code(char_code_1)
    );
                        
    assign addr_1 = {char_code_1, char_line_1};
                        
    font_rom my_font_rom_h(
        .clk(clk40),
        .addr(addr_1),
        .char_line_pixels(char_pixels_1)
    );   
             
 
    assign missed_bags = missed_bags_1 + missed_bags_2 + missed_bags_3;
 
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
    my_draw_rect_char_l(
        .pclk(clk40),
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

    char_life my_char_life(
        .clk(clk40),
        .rst(rst),
        .char_xy(char_xy_2),
        .missed_bags(missed_bags),
                                                 
        .char_code(char_code_2)
    );
                                               
    assign addr_2 = {char_code_2, char_line_2};
                                               
    font_rom my_font_rom_l(
        .clk(clk40),
        .addr(addr_2),
        .char_line_pixels(char_pixels_2)
    );   
                     
                     
                     
                     
    wire [10:0] hcount_out_st, vcount_out_st;
    wire hsync_out_st, vsync_out_st, hblnk_out_st, vblnk_out_st;
    wire [11:0] rgb_out_st;                 
                     
    draw_start my_draw_start(
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
                        
    draw_end my_draw_end(
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
       
    
    wire hsync_out_menu, vsync_out_menu;
    wire [11:0] rgb_out_menu;      
    menu_ctl my_menu(
        .clk(clk40),
        .rst(rst),
        .start(start),
        .replay(replay),
        .mouse_left(left),
        .mouse_right(right),
        .missed_bags(missed_bags),
        .bags_carried(bags_peng_out),
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
        .hsync_out(hsync_out_menu),
        .vsync_out(vsync_out_menu),
        .rgb_out(rgb_out_menu)
    );
       
             
 ////////////////////////////////////////////////////////
          //////////       mouse display           ///////////////
          ////////////////////////////////////////////////////////
          

          
//          MouseDisplay mouse_display(
          
//              .xpos(xpos_buff),
//              .ypos(ypos_buff),
//              .pixel_clk(clk40),
//              .red_in(rgb_out_l[11:8]),
//              .green_in(rgb_out_l[7:4]),
//              .blue_in(rgb_out_l[3:0]),
//              .blank(hblnk_out_l || vblnk_out_l),
//              .hcount({1'b0,hcount_out_l+1}), 
//              .vcount({1'b0,vcount_out_l}),
              
              
//              .red_out(red_out_m),
//              .green_out(green_out_m),
//              .blue_out(blue_out_m)
//          );

 
 
 
always @(posedge clk40)
            begin
              hs <= hsync_out_menu;
              vs <= vsync_out_menu;
              //{r,g,b} <=  {red_out_m,green_out_m,blue_out_m};
              {r,g,b} <=  rgb_out_menu;
           end       
endmodule
