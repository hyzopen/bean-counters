`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2018 15:57:16
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


module peng_bags_ctl(
  input wire clk,
  input wire rst,
  input wire restart,
  input wire [11:0] xpos_p,
  input wire mouse_left,
  input wire [7:0] bags_peng_in,
  //input wire [9:0] ypos_p,
  
  output reg [7:0] bags_peng_out,
  output reg [7:0] score
   );
   
   localparam   PENG_WIDTH  = 128,
                XPOS_END    = 650,
                STATE_SIZE  = 2,
                
                STATE_IDLE  = 2'b00,
                STATE_CLICK = 2'b01,
                STATE_WAIT  = 2'b10;
                
   reg [7:0] bags_peng_nxt = 0, bags_peng_temp = 0, score_nxt = 0;
   reg [STATE_SIZE -1:0] state = 2'b00, state_nxt = 2'b00;
   
    always @(posedge clk) begin
        if(rst || restart) begin
            bags_peng_out <= 0;
            bags_peng_temp <= 0;
            state <= STATE_IDLE;
            score <= 0;
        end
        else begin
            bags_peng_out <= bags_peng_nxt;
            bags_peng_temp <= bags_peng_in;
            state <= state_nxt;
            score <= score_nxt;
        end
    end   
    
     always @*
                 begin
                     case(state)
                         STATE_IDLE: state_nxt = (xpos_p >= (XPOS_END - PENG_WIDTH) && mouse_left) ? STATE_CLICK : STATE_IDLE;
                         STATE_CLICK: state_nxt = STATE_WAIT;
                         STATE_WAIT: state_nxt = (!mouse_left) ? STATE_IDLE : STATE_WAIT;
                     endcase
                 end
                 
                 
                 
     always @* 
                 begin
                            bags_peng_nxt = bags_peng_out;
                            score_nxt = score;
                                
                                case(state)
                                    STATE_IDLE:  
                                        begin    
                                            if (bags_peng_temp != bags_peng_in)
                                                bags_peng_nxt = bags_peng_out + 1;
                                         end       
                                    STATE_CLICK:
                                        begin
                                            if (bags_peng_nxt > 0) begin
                                                bags_peng_nxt = bags_peng_out - 1;
                                                score_nxt = score + 1;
                                            end
                                        end
                                    STATE_WAIT: begin
                                                end
                                     
                                endcase
                        end
endmodule
