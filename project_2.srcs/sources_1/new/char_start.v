`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2018 18:18:59
// Design Name: 
// Module Name: char_start
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


module char_start(
   // input wire clk,
    input wire [7:0] char_xy,
    
    output reg [6:0] char_code
    );

            
    reg [7:0] code_data;
    
    always @*   begin
        char_code = code_data[6:0];
    end
                
    always @*   begin
        case (char_xy)
            8'h00: code_data = 8'h00;
            8'h01: code_data = "C";   
            8'h02: code_data = "l";   
            8'h03: code_data = "i";   
            8'h04: code_data = "c";   
            8'h05: code_data = "k";   
            8'h06: code_data = " ";   
            8'h07: code_data = "t";    
            8'h08: code_data = "o";   
            8'h09: code_data = " ";   
            8'h0a: code_data = "s";      
            8'h0b: code_data = "t";   
            8'h0c: code_data = "a";   
            8'h0d: code_data = "r";   
            8'h0e: code_data = "t";   
            8'h0f: code_data = 8'h00;   
        endcase
    end            
endmodule
