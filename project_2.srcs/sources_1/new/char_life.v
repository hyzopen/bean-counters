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
   input wire rst,
   input wire [7:0] char_xy,
   input wire [7:0] missed_bags,
   
   output reg [6:0] char_code
   );
       

   reg [7:0] first, second, third, first_nxt, second_nxt, third_nxt;
   
        
   always @(posedge clk) begin
        if(rst) begin
            first   <= 0;
            second  <= 0;
            third   <= 0;
        end
        else begin
            first <= first_nxt;
            second <= second_nxt;
            third <= third_nxt;
        end
   end
   
   
   always @* begin
       first_nxt = 'h03;
       second_nxt = 'h03;
       third_nxt = 'h03;
       case (missed_bags)
            0: begin
                   first_nxt = 'h03;
                   second_nxt = 'h03;
                   third_nxt = 'h03;
               end     
            1: begin
                    first_nxt = 'h00;
                    second_nxt = 'h03;
                    third_nxt = 'h03;
               end
            2: begin
                    first_nxt = 'h00;
                    second_nxt = 'h00; 
                    third_nxt = 'h03;  
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
                           
             
                        
                       endcase
               end            

endmodule
