`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2018 15:24:41
// Design Name: 
// Module Name: char_end_score
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


module char_end_score(
    input wire [7:0] char_xy,
    input wire [7:0] ones,
    input wire [7:0] tens,
    input wire [7:0] hundreds,
    
    output reg [6:0] char_code
    );
   
     reg [7:0] code_data;
                always @*   begin
                    char_code = code_data[6:0];
                end
                
                always @*   begin
                        case (char_xy)
                            //line 0               //      hex
                            8'h00: code_data = 8'h00;   
                            8'h01: code_data = 8'h00;   
                            8'h02: code_data = 8'h00;   
                            8'h03: code_data = "Y";   
                            8'h04: code_data = "O";   
                            8'h05: code_data = "U";   
                            8'h06: code_data = "R";    
                            8'h07: code_data = " ";   
                            8'h08: code_data = "S";   
                            8'h09: code_data = "C";      
                            8'h0a: code_data = "O";   
                            8'h0b: code_data = "R";   
                            8'h0c: code_data = "E";   
                            8'h0d: code_data = 8'h00;   
                            8'h0e: code_data = 8'h00;   
                            8'h0f: code_data = 8'h00;   
                            
                            //line 1                  //      hex
                            8'h10: code_data = 8'h00;   // 
                            8'h11: code_data = 8'h00;   // 
                            8'h12: code_data = 8'h00;   // 
                            8'h13: code_data = 8'h00;   // 
                            8'h14: code_data = 8'h00;   // 
                            8'h15: code_data = 8'h00;   // 
                            8'h16: code_data = 8'h00;   //  
                            8'h17: code_data = 8'h00;   // 
                            8'h18: code_data = 8'h00;  // 
                            8'h19: code_data = 8'h00;   //     
                            8'h1a: code_data = 8'h00;   // 
                            8'h1b: code_data = 8'h00;   // 
                            8'h1c: code_data = 8'h00;   // 
                            8'h1d: code_data = 8'h00;   // 
                            8'h1e: code_data = 8'h00;   // 
                            8'h1f: code_data = 8'h00;   // 
                            //line 1                  //      hex
                            8'h20: code_data = 8'h00;   // 
                            8'h21: code_data = 8'h00;   // 
                            8'h22: code_data = 8'h00;   // 
                            8'h23: code_data = 8'h00;   // 
                            8'h24: code_data = 8'h00;   // 
                            8'h25: code_data = 8'h00;   // 
                            8'h26: code_data = hundreds;   //  
                            8'h27: code_data = tens;   // 
                            8'h28: code_data = ones;   // 
                            8'h29: code_data = 8'h00;   //     
                            8'h2a: code_data = 8'h00;   // 
                            8'h2b: code_data = 8'h00;   // 
                            8'h2c: code_data = 8'h00;   // 
                            8'h2d: code_data = 8'h00;   // 
                            8'h2e: code_data = 8'h00;   // 
                            8'h2f: code_data = 8'h00;   // 
                         
                        endcase
                end            
endmodule