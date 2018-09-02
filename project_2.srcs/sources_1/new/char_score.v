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
    input wire clk,
    input wire [7:0] char_xy,
    input wire [7:0] caught_num,
    
    output reg [6:0] char_code
    );
        
    localparam ASCII_CONV = 48;
    
    reg [7:0] tens = 0, ones = 0, hundreds = 0, tens_nxt = 0, ones_nxt = 0, hundreds_nxt = 0;
    
    always @(posedge clk) begin
        hundreds <= hundreds_nxt;
        tens <= tens_nxt;
        ones <= ones_nxt;
    end
    
    
    always @* begin
        ones_nxt = caught_num % 10 + ASCII_CONV;
//        if (caught_num < 10)
//            tens_nxt = 0 + ASCII_CONV;
//        else
        tens_nxt = (caught_num - (caught_num % 10))/10 + ASCII_CONV;
        if(caught_num >= 100)
            tens_nxt = tens_nxt - 10;
        hundreds_nxt = (caught_num - (caught_num % 100))/100 + ASCII_CONV;
    end

            
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
                            8'h03: code_data = 8'h00;   
                            8'h04: code_data = 8'h00;   
                            8'h05: code_data = "S";   
                            8'h06: code_data = "C";    
                            8'h07: code_data = "O";   
                            8'h08: code_data = "R";   
                            8'h09: code_data = "E";      
                            8'h0a: code_data = ":";   
                            8'h0b: code_data = 8'h00;   
                            8'h0c: code_data = 8'h00;   
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
                            8'h16: code_data = hundreds;   //  
                            8'h17: code_data = tens;   // 
                            8'h18: code_data = ones;   // 
                            8'h19: code_data = 8'h00;   //     
                            8'h1a: code_data = 8'h00;   // 
                            8'h1b: code_data = 8'h00;   // 
                            8'h1c: code_data = 8'h00;   // 
                            8'h1d: code_data = 8'h00;   // 
                            8'h1e: code_data = 8'h00;   // 
                            8'h1f: code_data = 8'h00;   // 
                         
                        endcase
                end            
endmodule
