`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2018 05:40:34 PM
// Design Name: 
// Module Name: bag_ctl
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



module bag_ctl(
    input wire clk,
    input wire [9:0] random,
    
    output reg [11:0] xpos,
    output reg [11:0] ypos
    );
    
     localparam
    WIDTH = 48,
    XPOS_START = 0,
    XPOS_END = 600,
    YPOS_START = 100,
    YPOS_END = 600,
    SPEED_DIVIDER = 800000;
    
    reg [11:0] xpos_nxt = 0, ypos_nxt = 200, ypos_start= 200, scale = 1;
    
     
    reg [20:0] counter = 0, counter_nxt = 0;
    reg [22:0] speed_counter, speed_counter_nxt;
   // reg [28:0] speed_counter_2 =0, speed_counter_nxt_2 = 0;
    
    initial begin
    ypos = 100;
    xpos = 0;
    end
    
    
    always @(posedge clk)
        begin
            xpos <= xpos_nxt;
            ypos <= ypos_nxt;
            //state <= state_nxt;
            speed_counter <= speed_counter_nxt;

        end
 
         always @* begin
         if(speed_counter >= SPEED_DIVIDER) begin
             speed_counter_nxt = 0;
                if(xpos >= XPOS_END || ypos >= YPOS_END) begin
                     xpos_nxt = XPOS_START;
                     ypos_nxt = YPOS_START;
                     //ypos_start = YPOS_START;
                     scale = random%5;
                     //down_nxt = 0;
                     end
                else begin
                     xpos_nxt = xpos + 1 ;
                     ypos_nxt = YPOS_START + (scale + 1) * xpos**2/(2**10);// od 2^6 dok ok 2^10

                    end
         end
         else begin
             speed_counter_nxt = speed_counter + 1;

         end
     end
     
     
endmodule
