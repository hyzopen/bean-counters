`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   number_generator
 Author:        
 Version:       1.0
 Last modified: 2018-08-17
 Coding style: 
 Description:   
 */
//////////////////////////////////////////////////////////////////////////////


module number_generator(
    input wire clk,
    input wire rst,
    output reg [7:0] number
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
      number <= 0;
     end
      
     else
     begin
      random <= random_next;
      count <= count_next;
      number <= random_done;
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