`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.08.2018 00:11:55
// Design Name: 
// Module Name: char_life
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


module char_life(
   input wire clk,
   input wire [7:0] char_xy,
   input wire [7:0] missed_bags,
   
   output reg [6:0] char_code
   );
       
//   localparam ASCII_CONV = 48;
   
//    reg [7:0] tens = 0, ones = 0, hundreds = 0, tens_nxt = 0, ones_nxt = 0, hundreds_nxt = 0;
   reg [7:0] first = 'h03, second = 'h03, third = 'h03, first_nxt = 'h03, second_nxt = 'h03, third_nxt = 'h03;
   
        
   always @(posedge clk) begin
       first <= first_nxt;
       second <= second_nxt;
       third <= third_nxt;
   end
   
   
   always @* begin
       first_nxt = 'h03;
       second_nxt = 'h03;
       third_nxt = 'h03;
       case (missed_bags)
            0: begin
               end     
            1: begin
                    first_nxt = 'h00;
               end
            2: begin
                    first_nxt = 'h00;
                    second_nxt = 'h00;   
               end
            default: begin
                    first_nxt = 'h00;
                    second_nxt = 'h00;      
                    third_nxt = 'h00;
               end
        endcase
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
                           8'h05: code_data = 8'h00;   
                           8'h06: code_data = first;    
                           8'h07: code_data = 8'h00;   
                           8'h08: code_data = second;   
                           8'h09: code_data = 8'h00;      
                           8'h0a: code_data = third;   
                           8'h0b: code_data = 8'h00;   
                           8'h0c: code_data = 8'h00;   
                           8'h0d: code_data = 8'h00;   
                           8'h0e: code_data = 8'h00;   
                           8'h0f: code_data = 8'h00;   
                           
                           //line 1                  //      hex
//                           8'h10: code_data = 8'h00;   // 
//                           8'h11: code_data = 8'h00;   // 
//                           8'h12: code_data = 8'h00;   // 
//                           8'h13: code_data = 8'h00;   // 
//                           8'h14: code_data = 8'h00;   // 
//                           8'h15: code_data = 8'h00;   // 
//                           8'h16: code_data = hundreds;   //  
//                           8'h17: code_data = tens;   // 
//                           8'h18: code_data = ones;   // 
//                           8'h19: code_data = 8'h00;   //     
//                           8'h1a: code_data = 8'h00;   // 
//                           8'h1b: code_data = 8'h00;   // 
//                           8'h1c: code_data = 8'h00;   // 
//                           8'h1d: code_data = 8'h00;   // 
//                           8'h1e: code_data = 8'h00;   // 
//                           8'h1f: code_data = 8'h00;   // 
                        
                       endcase
               end            

endmodule
