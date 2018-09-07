`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 016/08/2018 05:40:34 PM
// Design Name: 
// Module Name: ship_ctl
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

//endmodule
module bag_ctl(
    input wire clk,
    input wire rst, 
    input wire [9:0] random,
    input wire [11:0] xpos_p,
    input wire restart,
    input wire enable_bag,
    
    output reg [7:0] bags_peng,
    output reg [7:0] missed_bags,
    output reg [11:0] xpos,
    output reg [11:0] ypos
    );
    
    localparam
    WIDTH = 64,
    PENG_WIDTH = 128,
    XPOS_START = 0,
    XPOS_END = 600,
    YPOS_START = 100,
    YPOS_END = 600,
    SPEED_DIVIDER = 400000,
    
    STATE_CAUGHT    = 2'b00,
    STATE_NEW       = 2'b01,
    STATE_FALL      = 2'b10;
    
    reg [11:0] xpos_nxt = 0, ypos_nxt, ypos_start, range;
    reg [1:0] state = 2'b01, state_nxt = 2'b01;
    reg [7:0] bags_peng_nxt = 0, missed_bags_nxt = 0;
     
    reg [22:0] speed_counter, speed_counter_nxt;
    
    initial begin
    ypos = 100;
    xpos = 0;
    state = STATE_NEW;
    bags_peng = 0;
    missed_bags = 0;
    range = 1;
    end
    
    
    always @(posedge clk) begin
        if (rst || restart) begin
            xpos <= 0;
            ypos <= 0;
            speed_counter <= 0;
            state <= STATE_NEW;
            bags_peng <= 0;
            missed_bags <= 0;
        end
        else begin
            xpos <= xpos_nxt;
            ypos <= ypos_nxt;
            state <= state_nxt;
            speed_counter <= speed_counter_nxt;
            bags_peng <= bags_peng_nxt;
            missed_bags <= missed_bags_nxt;
        end
    end
    
    always @*
        begin
            case(state)
                STATE_CAUGHT: state_nxt = STATE_NEW;
                STATE_NEW: state_nxt = (restart || !enable_bag) ? STATE_NEW : STATE_FALL;
                STATE_FALL: state_nxt = ((xpos > xpos_p && xpos + WIDTH < xpos_p + PENG_WIDTH && ypos + 32 >= 450 && ypos + 32 < 460) || (ypos > YPOS_END)) ? STATE_CAUGHT : STATE_FALL;
            endcase
        end
        
     always @* 
        begin
            xpos_nxt = xpos;
            ypos_nxt = ypos;
            speed_counter_nxt = speed_counter;
            bags_peng_nxt = bags_peng;
            missed_bags_nxt = missed_bags;
                
                case(state)
                    STATE_CAUGHT:
                        if (xpos > xpos_p && xpos + WIDTH < xpos_p + PENG_WIDTH && ypos + 32 >= 450 && ypos + 32 < 460)
                            begin
                                bags_peng_nxt = bags_peng + 1;
                            end
                        else 
                            begin
                                missed_bags_nxt = missed_bags +1;
                            end
                    STATE_NEW:
                        begin
                            if(enable_bag) begin
                                xpos_nxt = XPOS_START;
                                ypos_nxt = YPOS_START;
                                range = random%16;
                            end
                            else begin
                                xpos_nxt = 800;
                                ypos_nxt = 0;
                            end
                        end
                    STATE_FALL:
                        if(speed_counter >= SPEED_DIVIDER)
                            begin
                                speed_counter_nxt = 0;
                                xpos_nxt = xpos + 1 ;
                                ypos_nxt = YPOS_START + (range + 1) * xpos**2/(2**10);
                            end
                        else
                            begin
                                speed_counter_nxt = speed_counter + 1;
                            end
                  endcase
        end
endmodule
