// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  input wire pclk,
  input wire rst,
  output reg [10:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg hsync,
  output reg hblnk
  );

  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.
  
  reg [10:0] hcount_nxt = 0;
  reg [10:0] vcount_nxt = 0;
  reg vblnk_nxt = 0;
  reg vsync_nxt = 0;
  reg hblnk_nxt = 0;
  reg hsync_nxt = 0;
  
  localparam HOR_TOTAL_TIME = 1055,
             HOR_BLANK_START = 800,
             HOR_BLANK_TIME = 256,
             HOR_SYNC_START = 840,
             HOR_SYNC_TIME = 128,
             VER_TOTAL_TIME = 627,
             VER_BLANK_START = 600,
             VER_BLANK_TIME = 28,
             VER_SYNC_START = 601,
             VER_SYNC_TIME = 4;
  
	always @(posedge pclk) begin
                 if(rst) begin 
                     vcount <= 11'b0;
                     vsync <= 1'b0;
                     vblnk <= 1'b0;
                     hcount <= 11'b0;
                     hsync <= 1'b0;
                     hblnk <= 1'b0;
                 end
                 else begin
                     vcount <= vcount_nxt;
                     vsync <= vsync_nxt;
                     vblnk <= vblnk_nxt;
                     hcount <= hcount_nxt;
                     hsync <= hsync_nxt;
                     hblnk <= hblnk_nxt;
                 end
             end
  
  always @* begin 
      if (hcount >= HOR_TOTAL_TIME) begin
          hcount_nxt = 0;
          if (vcount >= VER_TOTAL_TIME)
              vcount_nxt = 0;
          else
              vcount_nxt = vcount+1; 
      end
      else begin
           hcount_nxt = hcount+1;
           vcount_nxt = vcount;
           end
      end    
     
    always @* begin
      if(vcount_nxt >= VER_BLANK_START)
              vblnk_nxt = 1;
          else
              vblnk_nxt = 0;
          
      if((vcount_nxt >= VER_SYNC_START) && (vcount_nxt < VER_SYNC_START + VER_SYNC_TIME))
              vsync_nxt = 1;
          else 
              vsync_nxt = 0;
    
      if(hcount_nxt >= HOR_BLANK_START)
                  hblnk_nxt = 1;
          else
                  hblnk_nxt = 0;
                  
       if((hcount_nxt >= HOR_SYNC_START) && (hcount_nxt <= HOR_SYNC_START+HOR_SYNC_TIME))
                  hsync_nxt = 1;
          else 
                  hsync_nxt = 0;
    end

endmodule

