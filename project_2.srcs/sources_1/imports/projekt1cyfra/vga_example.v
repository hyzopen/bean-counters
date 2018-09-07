// File: vga_example.v
// This is the top level design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_example (
  input wire clk,
  input wire rst,
  input wire start,
  input wire replay,
  
  output reg vs,
  output reg hs,
  output reg [3:0] r,
  output reg [3:0] g,
  output reg [3:0] b,
  inout wire ps2_clk,
  inout wire ps2_data
  
  );



///////////////////////////////////////////////////////////////
////////////       main clock module           ///////////////
/////////////////////////////////////////////////////////////

wire clk100;
wire clk40;
wire locked;

clk_wiz_0   clk_main 
 (
  // Clock out ports
  .clk100MHz(clk100),
  .clk40Mhz(clk40),
  // Status and control signals
  .reset(1'b0),
  .locked(locked),
 // Clock in ports
  .clk(clk)
 );
 

////////////////////////////////////////////////////////
//////////       mouse module           ///////////////
////////////////////////////////////////////////////////

wire left, right;
wire [11:0] xpos, xpos_p;
wire restart, end_game, enable_second, enable_third;
wire vsync_out, hsync_out;
wire [11:0] rgb_out;
wire [7:0] held_bags, random, ones, tens, hundreds;
wire [3:0] held_bags_out;

MouseCtl mouse_module (
    .clk(clk100),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos),
    .left(left),
    .right(right)
    
);

core my_core(
    .clk40(clk40),
    .rst(rst),
    .left(left),
    .xpos_m(xpos),
    .restart(restart),
    .end_game(end_game),
    .held_bags(held_bags),
    
    .held_bags_out(held_bags_out),
    .number(random),
    .enable_second(enable_second),
    .enable_third(enable_third),
    .ones(ones),
    .tens(tens),
    .hundreds(hundreds),
    .xpos_p(xpos_p)
    );

vga_ctl my_vga_ctl(
    .clk40(clk40),
    .rst(rst),
    .xpos_p(xpos_p),
    .random(random),
    .enable_second(enable_second),
    .enable_third(enable_third),
    .ones(ones),
    .tens(tens),
    .hundreds(hundreds),
    .start(start),
    .replay(replay),
    .left(left),
    .right(right),
    .held_bags_out(held_bags_out),
    
    .vs(vsync_out),
    .hs(hsync_out),
    .rgb(rgb_out),
    .restart(restart),
    .end_game(end_game),
    .held_bags(held_bags)
    
    );

    always @(posedge clk40)
                begin
                  hs <= hsync_out;
                  vs <= vsync_out;
                  {r,g,b} <=  rgb_out;
               end                                         
 

endmodule
