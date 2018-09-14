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
    input wire rst,
    
    output reg [10:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,  
    output reg [11:0] rgb_out
    );
    
localparam WIDTH = 128;

reg [11:0] rgb_new;

always @(posedge pclk) begin
    if(rst) begin
        hcount_out  <= 0;
        hsync_out   <= 0;
        hblnk_out   <= 0; 
        vcount_out  <= 0;
        vsync_out   <= 0;
        vblnk_out   <= 0;
        rgb_out     <= 0;
    end
    else begin        
        hcount_out  <= hcount_in;
        hsync_out   <= hsync_in;
        hblnk_out   <=  hblnk_in; 
        vcount_out  <=  vcount_in;
        vsync_out   <= vsync_in;
        vblnk_out   <= vblnk_in;
        rgb_out     <=  rgb_new;
     end
end
    
always @* begin
        // During blanking, make it it black.
    if (vblnk_in || hblnk_in) rgb_new <= 12'h0_0_0; 
    else if (hcount_in == 799 - WIDTH ) rgb_new <= 12'h0_0_0;
    else rgb_new <= 12'hf_f_f;   
   
end

endmodule
