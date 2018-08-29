`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   
 Author:        
 Version:       1.0
 Last modified: 
 Coding style:  
 Description:   This module generates a number between 1 and 6
 */
//////////////////////////////////////////////////////////////////////////////


module scale_number(
    input wire clk,
    output reg [3:0] scale_number
    );
    
//------------------------------------------------------------------------------
// local parameters
//------------------------------------------------------------------------------    
    localparam
    OBJECT_WIDTH = 100;

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------  
     reg [9:0] scale_number_nxt, scale_number_previous;

//------------------------------------------------------------------------------
// output register - without rst, so random number is even more random :)
//------------------------------------------------------------------------------    
always @(posedge clk) begin
    scale_number <= scale_number_nxt;
    scale_number_previous <= scale_number;
end
   
always @* begin   
    if(scale_number + scale_number_previous > 11)
        scale_number_nxt = scale_number + scale_number_previous - 11;
        else if (scale_number + scale_number_previous == 0)
            scale_number_nxt = scale_number + scale_number_previous + 1;
    else
        scale_number_nxt = scale_number + scale_number_previous;
    if(scale_number_nxt == 0) // to avoid stable position
        scale_number_nxt = 1;
end

endmodule