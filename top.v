module top (input rst, input button, input[8:0] switches, input clk, //raw 50MHz clock each module uses it's own clock divider or the 60hz vsync signal
    output [6:0] ssd, output[11:0] rgb, output hsync, output vsync);

    wire[9:0] x, y;
    wire[9:0] lx, ly;
    wire[1:0] mode, turn, game_state;
    wire blank, highlight, render;
    //vgasync module
    vgaSync vs1(clk, rst, x, y, blank, hsync, vsync);

    //game module
    game g1(clk, rst, button, switches, x, y, lx, ly, mode, render, highlight, turn, game_state);
	 SSDriver ssd1(turn, ~(game_state == 2'b10), ssd);
    
    //render module
    renderer r1(rst, x, y, lx, ly, render, mode, highlight, blank, rgb);

endmodule