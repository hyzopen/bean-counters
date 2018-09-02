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
    output reg [7:0] number
    );
    

    reg [7:0] number_nxt, number_previous;
 
    always @(posedge clk) begin
        number          <= number_nxt;
        number_previous <= number;
    end
       
    always @* begin   
        if(number + number_previous > 100)
            number_nxt = number + number_previous - 100;
        else
            number_nxt = number + number_previous;
        if(number_nxt == 0) 
            number_nxt = 1;
    end
    
endmodule