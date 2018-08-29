`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   random_algorithm
 Author:        
 Version:       1.0
 Last modified: 2018-08-17
 Coding style:  safe, with FPGA sync reset
 Description:   
 */
//////////////////////////////////////////////////////////////////////////////


module random_algorithm(
    input wire clk,
    output reg [9:0] random_number
    );
    

    reg [9:0] random_number_nxt, random_number_previous;
 
    always @(posedge clk) begin
        random_number <= random_number_nxt;
        random_number_previous <= random_number;
    end
       
    always @* begin   
        if(random_number + random_number_previous > 599)
            random_number_nxt = random_number + random_number_previous - 599;
        else
            random_number_nxt = random_number + random_number_previous;
        if(random_number_nxt == 0) 
            random_number_nxt = 1;
    end
    
endmodule
