`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.08.2018 13:56:43
// Design Name: 
// Module Name: menu_ctl
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


module menu_ctl(
    input wire clk,
    input wire rst,
    input wire start,
    input wire replay,
    input wire mouse_left,
    input wire mouse_right,
    input wire [7:0] missed_bags,
    input wire [3:0] held_bags,
    input wire hsync_s,
    input wire vsync_s,
    input wire [11:0] rgb_s,
    input wire hsync_g,
    input wire vsync_g,
    input wire [11:0] rgb_g,
    input wire hsync_e,
    input wire vsync_e,
    input wire [11:0] rgb_e,
        
    output reg restart,
    output reg end_game,
    output reg hsync_out,
    output reg vsync_out,
    output reg [11:0] rgb_out
    );
    
    
    localparam  STATE_BITS  = 2;
    localparam  
    STATE_START = 2'b00,
    STATE_GAME  = 2'b01,
    STATE_END   = 2'b11;
                
   reg hsync_out_nxt = 0, vsync_out_nxt = 0, restart_nxt = 0, end_game_nxt = 0;
   reg [11:0] rgb_out_nxt = 0;
   reg [STATE_BITS-1 : 0] state, state_nxt;
   
   
   
   always @(posedge clk) begin
        if(rst)begin
            state       <= STATE_START;
            hsync_out   <= 0;
            vsync_out   <= 0;
            rgb_out     <= 0;
            restart     <= 1;
            end_game    <= 0;
        end
        else begin
            state       <= state_nxt;
            hsync_out   <= hsync_out_nxt;
            vsync_out   <= vsync_out_nxt;
            rgb_out     <= rgb_out_nxt;
            restart     <= restart_nxt;
            end_game    <= end_game_nxt;
        end
   end
   
   
   always @* begin
        case(state)
            STATE_START :   state_nxt = mouse_left || start ? STATE_GAME : STATE_START;
            STATE_GAME :    state_nxt = (missed_bags == 4 || held_bags == 6) ? STATE_END : STATE_GAME;
            STATE_END :     state_nxt = replay || mouse_right ? STATE_START : STATE_END;
            default :       state_nxt = STATE_START;
        endcase
   end    
          
          
   always @* begin
        case(state)
            STATE_START:
                begin
                    hsync_out_nxt   = hsync_s;
                    vsync_out_nxt   = vsync_s;
                    rgb_out_nxt     = rgb_s;
                    restart_nxt     = 1;
                    end_game_nxt    = 0;
                end
            STATE_END:
                begin
                    hsync_out_nxt   = hsync_e;
                    vsync_out_nxt   = vsync_e;
                    rgb_out_nxt     = rgb_e;
                    restart_nxt     = 0;    
                    end_game_nxt    = 1;
                end
             STATE_GAME:
                begin
                    hsync_out_nxt   = hsync_g;
                    vsync_out_nxt   = vsync_g;
                    rgb_out_nxt     = rgb_g;
                    restart_nxt     = 0; 
                    end_game_nxt    = 0;
                end
        endcase
    end
      
endmodule
