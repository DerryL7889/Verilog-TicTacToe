module top (input rst, input button, input[8:0] switches, input clk, //raw 50MHz clock each module uses it's own clock divider or the 60hz vsync signal
    output [6:0] ssd, output [6:0] ssd1, output [6:0] ssd2, output [6:0] ssd3, output [6:0] ssd4, output[11:0] rgb, output hsync, output vsync);

    wire[9:0] x, y;
    wire[9:0] lx, ly;
    wire[1:0] mode, turn, game_state;
    wire blank, highlight, render;
	 
    //vgasync module
    vgaSync vs1(clk, rst, x, y, blank, hsync, vsync);

    //game module
    game g1(clk, rst, button, switches, x, y, lx, ly, mode, render, highlight, turn, game_state);
	 SSDriver ssdd0(turn, ~(game_state == 2'b10), ssd);
	 
	 assign ssd1[6] = 1;
	 assign ssd1[5] = (game_state == 2'b00) ^ (game_state == 2'b10);
	 assign ssd1[4] = 1;
	 assign ssd1[3] = (game_state == 2'b00);
	 assign ssd1[2] = (game_state == 2'b00) ^ (game_state == 2'b01);
	 assign ssd1[1] = (game_state == 2'b00);
	 assign ssd1[0] = (game_state == 2'b00);
	 
	 assign ssd2[6] = 1;
	 assign ssd2[5] = 1;
	 assign ssd2[4] = 1;
	 assign ssd2[3] = 1;
	 assign ssd2[2] = (game_state == 2'b00);
	 assign ssd2[1] = (game_state == 2'b00);
	 assign ssd2[0] = 1;
	
	 assign ssd3[6] = (game_state == 2'b00) ^ (game_state == 2'b01);
	 assign ssd3[5] = 1;
	 assign ssd3[4] = (game_state == 2'b00) ^ (game_state == 2'b10);
	 assign ssd3[3] = (game_state == 2'b00) ^ (game_state == 2'b01);
	 assign ssd3[2] = (game_state == 2'b00);
	 assign ssd3[1] = (game_state == 2'b00) ^ (game_state == 2'b01);
	 assign ssd3[0] = (game_state == 2'b00);
	 
	 assign ssd4 = 8'b11111111;
	 
    //render module
    renderer r1(rst, x, y, lx, ly, render, mode, highlight, blank, rgb);
	
endmodule