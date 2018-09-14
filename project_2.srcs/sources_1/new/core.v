`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2018 00:22:27
// Design Name: 
// Module Name: core
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


module core(
    input wire clk40,
    input wire rst,
    input wire left,
    input wire [11:0] xpos_m,
    input wire restart,
    input wire end_game,
    input wire [7:0] held_bags,
    
    output wire [3:0] held_bags_out,
    output wire enable_second,
    output wire enable_third,
    output wire [7:0] ones,
    output wire [7:0] tens,
    output wire [7:0] hundreds,
    output wire [11:0] xpos_p
    );



    wire [11:0] xpos_buff;
              

    
    buffer_module buffer_module(
        .clk(clk40),
        .rst(rst),
        .xpos_in(xpos_m),
        
        .xpos_out(xpos_buff)
		);
 
  
            
	draw_rect_ctl my_peng_ctl(
		.clk_in(clk40),
		.rst(rst),
		.mouse_xpos(xpos_buff),
    
		.xpos(xpos_p) 
        );  
            

    
    wire [7:0] score;
    
    
        bag_enable bags_enable(
            .clk(clk40),
            .rst(rst),
            .score(score),
            .restart(restart),
            
            .enable_second(enable_second),
            .enable_third(enable_third)
            );
    
        score_conv score_conv (
            .clk(clk40),
            .rst(rst),
            .score(score),
            .end_game(end_game),
            
            .ones(ones),
            .tens(tens),
            .hundreds(hundreds)
			);

    
     
        peng_bags_ctl my_peng_bags_ctl(
            .clk(clk40),
            .rst(rst),
            .restart(restart),
            .xpos_p(xpos_p),
            .mouse_left(left),
            .bags_peng_in(held_bags),
                  
            .bags_peng_out(held_bags_out),
            .score(score)
			);
     
  
     
                         

endmodule
