`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2018 16:57:16
// Design Name: 
// Module Name: peng_bags_ctl
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


module number_generator(
    input wire clk,
    input wire rst,
    output reg [7:0] random_number
    );
    
    
     
    reg [7:0] random, random_next, random_done;
    reg [3:0] count, count_next; 
    wire feedback = random[7] ^ random[5] ^ random[4] ^ random[3]; 
     
    always @ (posedge clk)
    begin
     if (rst)
     begin
      random <= 8'hF; 
      count <= 4'hF;
      random_number <= 0;
     end
      
     else
     begin
      random <= random_next;
      count <= count_next;
      random_number <= random_done;
     end
    end
     
    always @ (*)
    begin
       
      random_next = {random[6:0], feedback}; 
      count_next = count + 1;
     
     if (count == 8)
     begin
      count_next = 0;
      random_done = random;
     end
      
    end
    
endmodule