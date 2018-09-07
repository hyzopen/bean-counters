`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2018 16:49:55
// Design Name: 
// Module Name: char_peng_bags
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


module char_peng_bags(
   input wire clk,
   input wire rst,
   input wire [7:0] char_xy,
   input wire [7:0] peng_bags,
   
   output reg [6:0] char_code
   );
       
    localparam ASCII_CONV = 48;
   
    reg [7:0] tens, ones, hundreds, tens_nxt, ones_nxt, hundreds_nxt;
   
    always @(posedge clk) begin
        if(rst) begin
            hundreds    <= 0;
            tens        <= 0;
            ones        <= 0;
        end
        else begin
            hundreds    <= hundreds_nxt;
            tens        <= tens_nxt;
            ones        <= ones_nxt;
        end
   end
   
   
   always @* begin
       ones_nxt = peng_bags % 10 + ASCII_CONV;
       tens_nxt = (peng_bags - (peng_bags % 10))/10 + ASCII_CONV;
       if(peng_bags >= 100)
           tens_nxt = tens_nxt - 10;
       hundreds_nxt = (peng_bags - (peng_bags % 100))/100 + ASCII_CONV;
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
                           8'h02: code_data = "B";   
                           8'h03: code_data = "A";   
                           8'h04: code_data = "G";   
                           8'h05: code_data = "S";   
                           8'h06: code_data = " ";    
                           8'h07: code_data = "C";   
                           8'h08: code_data = "A";   
                           8'h09: code_data = "R";      
                           8'h0a: code_data = "R";   
                           8'h0b: code_data = "I";   
                           8'h0c: code_data = "E";   
                           8'h0d: code_data = "D";   
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
