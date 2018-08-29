`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2018 17:14:14
// Design Name: 
// Module Name: buffer_module
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


module buffer_module(
    input wire clk,
    input wire [11:0] xpos_in,
    input wire [11:0] ypos_in,
    
    output reg [11:0] xpos_out,
    output reg [11:0] ypos_out
    );
    
    
always @(posedge clk)
    begin
        xpos_out <= xpos_in;
        ypos_out <= ypos_in;      
    end   
    
endmodule

