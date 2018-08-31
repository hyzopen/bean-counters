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
wire reset;

clk_wiz_0   clk_main 
 (
  // Clock out ports
  .clk100MHz(clk100),
  .clk40Mhz(clk40),
  // Status and control signals
  .reset(reset),
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
    .vcount(vcount),
    .vsync(vsync),
    .vblnk(vblnk),
    .hcount(hcount),
    .hsync(hsync),
    .hblnk(hblnk),
    .pclk(clk40)
  );

////////////////////////////////////////////////////////////
//////////       background module           ///////////////
///////////////////////////////////////////////////////////

wire [10:0] vcount_out_b, hcount_out_b;
wire vsync_out_b, hsync_out_b;
wire vblnk_out_b, hblnk_out_b;
wire [11:0] rgb_out_b;

draw_background my_background (
    .vcount_in(vcount),
    .vsync_in(vsync),
    .vblnk_in(vblnk),
    .hcount_in(hcount),
    .hsync_in(hsync),
    .hblnk_in(hblnk),
    .pclk(clk40),
    
    .hcount_out(hcount_out_b),
    .hsync_out(hsync_out_b),
    .hblnk_out(hblnk_out_b),
    .vcount_out(vcount_out_b),
    .vsync_out(vsync_out_b),
    .vblnk_out(vblnk_out_b),
    .rgb_out(rgb_out_b)
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
        .vcount_in(vcount_out_b),
        .vsync_in(vsync_out_b),
        .vblnk_in(vblnk_out_b),
        .hcount_in(hcount_out_b),
        .hsync_in(hsync_out_b),
        .hblnk_in(hblnk_out_b),
        .rgb_in(rgb_out_b),
        .pclk(clk40),
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

wire left;

MouseCtl mouse_module (
    .clk(clk100),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos),
    //.ypos(550),
    .left(left)
    
);

          wire [11:0] xpos_buff,ypos_buff;
          wire [0:3] green_out_m, red_out_m, blue_out_m; 
          

////////////////////////////////////////////////////////
//////////       buffer module           ///////////////
////////////////////////////////////////////////////////



buffer_module buffer_module(
    .xpos_in(xpos),
    .ypos_in(450),
    .clk(clk40),
    
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
            .mouse_left(left),
            .clk_in(clk40),
            .mouse_xpos(xpos_buff),
            .mouse_ypos(ypos_buff),
            .xpos(xpos_in),
            .ypos(ypos_in)
                   
        );  
        
        
       
        
        
        wire [7:0] number;

        
        number_generator my_number_generator(
            .clk(clk40),
            .number(number)
            );   
            
            
            wire [11:0] xpos_s, ypos_s; 
            
            wire [10:0] hcount_out_s, vcount_out_s;
              wire hsync_out_s, vsync_out_s;
              wire vblnk_out_s, hblnk_out_s;
              wire [11:0] rgb_out_s;
            
                bag_ctl my_bag_ctl(
                          .clk(clk40),
                          .xpos(xpos_s),
                          .ypos(ypos_s),
                          .random(number)
                          
                        );   
             
                       wire [20:0] address_s, address_s2;   
                        wire [11:0] rgb_pixel_s,rgb_pixel_s2;
                      image_rom # (
                              .image_path(),
                              .x_bit_width(6),
                              .y_bit_width(5)
                              )
                              bag_rom(     
                          .clk(clk40),
                          .address(address_s),
                          .rgb(rgb_pixel_s)
                  
                    );
                    
                    
                    
                    
                     draw_rect # (
                                    .x_bit_width(6),
                                    .y_bit_width(5)
                                    ) my_draw_bag (
                        .vcount_in(vcount_out),
                        .vsync_in(vsync_out),
                        .vblnk_in(vblnk_out),
                        .hcount_in(hcount_out),
                        .hsync_in(hsync_out),
                        .hblnk_in(hblnk_out),
                        .rgb_in(rgb_out),
                        .pclk(clk40),
                        .xpos(xpos_s),  
                        .ypos(ypos_s),
                        .pixel_addr(address_s),
                        .rgb_pixel(rgb_pixel_s),
                        
                        .hcount_out(hcount_out_s),
                        .hsync_out(hsync_out_s),
                        .hblnk_out(hblnk_out_s),
                        .vcount_out(vcount_out_s),
                        .vsync_out(vsync_out_s),
                        .vblnk_out(vblnk_out_s),
                        .rgb_out(rgb_out_s)
                      );

 
 
 
 
 ////////////////////////////////////////////////////////
          //////////       mouse display           ///////////////
          ////////////////////////////////////////////////////////
          

          
          MouseDisplay mouse_display(
          
              .xpos(xpos_buff),
              .ypos(ypos_buff),
              .pixel_clk(clk40),
              .red_in(rgb_out_s[11:8]),
              .green_in(rgb_out_s[7:4]),
              .blue_in(rgb_out_s[3:0]),
              .blank(hblnk_out_s || vblnk_out_s),
              .hcount({1'b0,hcount_out_s+1}), 
              .vcount({1'b0,vcount_out_s}),
              
              
              .red_out(red_out_m),
              .green_out(green_out_m),
              .blue_out(blue_out_m)
          );

 
 
 
always @(posedge clk40)
            begin
              hs <= hsync;
              vs <= vsync;
              {r,g,b} <=  {red_out_m,green_out_m,blue_out_m};
           end       
endmodule
