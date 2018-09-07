`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2017 19:27:45
// Design Name: 
// Module Name: draw_rect_ctl
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


module draw_rect_ctl(
    input wire          clk_in,
    input wire          rst,
    input wire  [11:0]  mouse_xpos,
//    input wire  [11:0]  mouse_ypos,
    output reg  [11:0]  xpos,
    output reg  [11:0]  ypos
    );
    
    localparam  YPOS    = 450,
                WIDTH   = 128;
    
    reg [11:0]  xpos_nxt, ypos_nxt;
    
    always @(posedge clk_in) begin
        if(rst) begin
            xpos <= 0;
            ypos <= 450;
        end
        else begin 
            xpos <= xpos_nxt;
            ypos <= ypos_nxt;
        end
    end
    
    always @* begin
        xpos_nxt = mouse_xpos;
        ypos_nxt = YPOS;
        if (mouse_xpos >= 800 - WIDTH)
            xpos_nxt = 800 - WIDTH;
    end
 endmodule   
