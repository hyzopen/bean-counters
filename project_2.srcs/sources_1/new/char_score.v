`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2018 15:19:36
// Design Name: 
// Module Name: char_rom_16x16
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

module char_score(
    input wire [7:0] char_xy,
    input wire [7:0] ones,
    input wire [7:0] tens,
    input wire [7:0] hundreds,
    
    output reg [6:0] char_code
    );
        
  
    always @*   begin
        case (char_xy)
            //line 0             
            8'h00: char_code = 7'h00;   
            8'h01: char_code = 7'h00;   
            8'h02: char_code = 7'h00;   
            8'h03: char_code = 7'h00;   
            8'h04: char_code = 7'h00;   
            8'h05: char_code = "S";   
            8'h06: char_code = "C";    
            8'h07: char_code = "O";   
            8'h08: char_code = "R";   
            8'h09: char_code = "E";      
            8'h0a: char_code = 7'h00;   
            8'h0b: char_code = 7'h00;   
            8'h0c: char_code = 7'h00;   
            8'h0d: char_code = 7'h00;   
            8'h0e: char_code = 7'h00;   
            8'h0f: char_code = 7'h00;   
                            
            //line 1                 
            8'h10: char_code = 7'h00;    
            8'h11: char_code = 7'h00;    
            8'h12: char_code = 7'h00;   
            8'h13: char_code = 7'h00;  
            8'h14: char_code = 7'h00; 
            8'h15: char_code = 7'h00;   
            8'h16: char_code = hundreds;  
            8'h17: char_code = tens;  
            8'h18: char_code = ones;  
            8'h19: char_code = 7'h00;     
            8'h1a: char_code = 7'h00;  
            8'h1b: char_code = 7'h00;   
            8'h1c: char_code = 7'h00;  
            8'h1d: char_code = 7'h00;  
            8'h1e: char_code = 7'h00;  
            8'h1f: char_code = 7'h00;  
                         
        endcase
    end            
endmodule
