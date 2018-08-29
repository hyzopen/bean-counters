module image_rom # (
    parameter
    x_bit_width = 7,
    y_bit_width = 7,
    image_path = "C:\Users\Klaudusia\Desktop\proj_3\128.data"
    )
    (
    input wire clk ,
    input wire [x_bit_width+y_bit_width-1:0] address,
    output reg [11:0] rgb
);


reg [11:0] rom [(2**x_bit_width)*(2**y_bit_width):0];

initial $readmemh(image_path, rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule
