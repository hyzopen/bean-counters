`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2018 16:41:08
// Design Name: 
// Module Name: score_conv
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


module score_conv(
    input wire clk,
    input wire rst,
    input wire [7:0] caught_num,
    input wire end_game,
    
    output reg [7:0] ones,
    output reg [7:0] tens,
    output reg [7:0] hundreds
    );
        
    localparam ASCII_CONV = 48;
    
    reg [7:0] tens_nxt = 0, ones_nxt = 0, hundreds_nxt = 0;
    
    always @(posedge clk) begin
        if(rst) begin
            hundreds<= 0;
            tens    <= 0;
            ones    <= 0;
        end
        else begin
            hundreds<= hundreds_nxt;
            tens    <= tens_nxt;
            ones    <= ones_nxt;
        end
    end
    
    
    always @* begin
        ones_nxt = caught_num % 10 + ASCII_CONV;
        tens_nxt = (caught_num % 100 - (caught_num % 10))/10 + ASCII_CONV;
        hundreds_nxt = (caught_num - (caught_num % 100))/100 + ASCII_CONV;
        if(end_game) begin
            ones_nxt = ones;
            tens_nxt = tens;
            hundreds_nxt = hundreds;
        end
    end

            
endmodule
