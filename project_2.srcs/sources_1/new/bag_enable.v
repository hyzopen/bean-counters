`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2018 14:45:51
// Design Name: 
// Module Name: bag_enable
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


module bag_enable(
    input wire clk,
    input wire rst,
    input wire [7:0] score,
    input wire restart,
    
    output reg enable_second,
    output reg enable_third
    );
    
    reg enable_second_nxt, enable_third_nxt;
    
    always @(posedge clk) begin
        if(rst || restart) begin
            enable_second   <= 0;
            enable_third    <= 0;
        end
        else begin
            enable_second   <= enable_second_nxt;
            enable_third    <= enable_third_nxt;
        end
    end
    
    always @* begin
        enable_second_nxt = enable_second;
        enable_third_nxt = enable_third;
        if(score >= 10) begin
            enable_second_nxt = 1;
            if(score >= 25) 
                enable_third_nxt = 1;
            else enable_third_nxt = 0;
        end
        else enable_second_nxt = 0;
     end
            
endmodule
