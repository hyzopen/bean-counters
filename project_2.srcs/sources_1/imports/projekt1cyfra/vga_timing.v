// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  output reg [10:0] vcount,
  output wire vsync,
  output wire vblnk,
  output reg [10:0] hcount,
  output wire hsync,
  output wire hblnk,
  input wire pclk
  );

  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.

  localparam    HOR_TOTAL_TIME  = 1055,
                HOR_BLANK_START = 800,
                HOR_BLANK_TIME  = 256,
                HOR_SYNC_START  = 840,
                HOR_SYNC_TIME   = 128,
                
                VER_TOTAL_TIME  = 627,
                VER_BLANK_START = 600,
                VER_BLANK_TIME  = 28,
                VER_SYNC_START  = 601,
                VER_SYNC_TIME   = 4;
                
    reg [10:0]  vcount_nxt = 0;
    reg [10:0]  hcount_nxt = 0;                        


    always @(posedge pclk) 
        begin
            vcount <= vcount_nxt;
            hcount <= hcount_nxt;
        end

    always @*
        begin        
            if(hcount >= HOR_TOTAL_TIME)
                begin
                    hcount_nxt = 0;
                    if(vcount >= VER_TOTAL_TIME)
                        vcount_nxt = 0;
                    else vcount_nxt = vcount + 1;
                end
            else
                begin
                    hcount_nxt = hcount + 1;
                    vcount_nxt = vcount;
                end 
        end
        
        
    assign hblnk = ((hcount >= HOR_BLANK_START) && (hcount <= HOR_BLANK_START + HOR_BLANK_TIME));
    assign hsync = ((hcount >= HOR_SYNC_START) && (hcount <= HOR_SYNC_START + HOR_SYNC_TIME));
    assign vblnk = ((vcount >= VER_BLANK_START) && (vcount <= VER_BLANK_START + VER_BLANK_TIME));
    assign vsync = ((vcount >= VER_SYNC_START) && (vcount <= VER_SYNC_START + VER_SYNC_TIME));
            
endmodule
