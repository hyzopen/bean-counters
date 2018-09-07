`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2018 16:02:43
// Design Name: 
// Module Name: draw_bags
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


module draw_bags(
    input wire pclk,
    input wire rst,
    input wire [11:0] xpos_in,
    input wire restart,
    input wire [10:0] hcount,
    input wire [10:0] vcount,
    input wire hsync,
    input wire vsync,
    input wire vblnk,
    input wire hblnk,
    input wire [11:0] rgb,
    input wire enable_second,
    input wire enable_third,
    input wire [7:0] random_number,
    
    output wire [10:0] hcount_out,
    output wire [10:0] vcount_out,
    output wire hsync_out,
    output wire vsync_out,
    output wire hblnk_out,
    output wire vblnk_out,
    output wire [11:0] rgb_out,
    output wire [7:0] held_bags,
    output wire [7:0] missed_bags
    );
    

    wire [11:0] xpos_b, ypos_b; 
    
     wire [10:0] hcount_out_b, vcount_out_b;
                 wire hsync_out_b, vsync_out_b;
                 wire vblnk_out_b, hblnk_out_b;
                 wire [11:0] rgb_out_b;
                 wire [7:0] bags_peng, bags_peng_1, bags_peng_out, missed_bags_1;
           

     //first bag///
     //////////////          
                 bag_ctl my_first_bag(
                 .clk(pclk),
                 .rst(rst),
                 .random(random_number),
                 .xpos_p(xpos_in),
                 .restart(restart),
                 .enable_bag(1'b1),
                 
                 .xpos(xpos_b),
                 .ypos(ypos_b),
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
                 .clk(pclk),
                 .address(address_b),
                 .rgb(rgb_pixel_b)
         
           );
           
           
           
           
            draw_rect # (
                 .x_bit_width(6),
                 .y_bit_width(5)
                 )
             my_draw_bag (
               .vcount_in(vcount),
               .vsync_in(vsync),
               .vblnk_in(vblnk),
               .hcount_in(hcount),
               .hsync_in(hsync),
               .hblnk_in(hblnk),
               .rgb_in(rgb),
               .pclk(pclk),
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
               .clk(pclk),
               .rst(rst),
               .random(random_number),
               .xpos_p(xpos_in),
               .restart(restart),
               .enable_bag(enable_second),
               
               .xpos(xpos_b2),
               .ypos(ypos_b2),
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
               .clk(pclk),
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
             .pclk(pclk),
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

    wire [7:0] bags_peng_3, missed_bags_3;
                
     bag_ctl my_third_bag(
               .clk(pclk),
               .rst(rst),
               .random(random_number),
               .xpos_p(xpos_in),
               .restart(restart),
               .enable_bag(enable_third),
               
               .xpos(xpos_b3),
               .ypos(ypos_b3),
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
               .clk(pclk),
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
             .pclk(pclk),
             .xpos(xpos_b3),  
             .ypos(ypos_b3),
             .pixel_addr(address_b3),
             .rgb_pixel(rgb_pixel_b3),
             .rst(rst),
             
             .hcount_out(hcount_out),
             .hsync_out(hsync_out),
             .hblnk_out(hblnk_out),
             .vcount_out(vcount_out),
             .vsync_out(vsync_out),
             .vblnk_out(vblnk_out),
             .rgb_out(rgb_out)
           );
           
     assign held_bags = bags_peng_1 + bags_peng_2 + bags_peng_3;
     assign missed_bags = missed_bags_1 + missed_bags_2 + missed_bags_3;
     
endmodule
