module game(input rst, input button, input[8:0] switches, input[9:0] x, input[9:0]y, 
    output[9:0] lx, output[9:0] ly, output[1:0] mode, output square, output highlight, output turn);

    reg[2:0] state;
    wire[8:0] change, render;
    wire[9:0] lx1, lx2, lx3, lx4, lx5, lx6, lx7, lx8, lx9;
    wire[9:0] ly1, ly2, ly3, ly4, ly5, ly6, ly7, ly8, ly9;
    wire[2:0] mode1, mode2, mode3, mode4, mode5, mode6, mode7, mode8, mode9;
    
    space sq1(112,32,240,160, rst, change[0], x, y, lx1, ly1, render[0], mode1);
    space sq2(256,32,384,160, rst, change[1], x, y, lx2, ly2, render[1], mode2);
    space sq3(400,32,528,160, rst, change[2], x, y, lx3, ly3, render[2], mode3);

    space sq4(112,176,240,304, rst, change[3], x, y, lx4, ly4, render[3], mode4);
    space sq5(256,176,384,304, rst, change[4], x, y, lx5, ly5, render[4], mode5);
    space sq6(400,176,528,304, rst, change[5], x, y, lx6, ly6, render[5], mode6);

    space sq7(112,320,240,448, rst, change[6], x, y, lx7, ly7, render[6], mode7);
    space sq8(256,320,384,448, rst, change[7], x, y, lx8, ly8, render[7], mode8);
    space sq9(400,320,528,448, rst, change[8], x, y, lx9, ly9, render[8], mode9);


    assign square = | render; 
    assign highlight = ((render[0] & change[0]) | (render[1] & change[1]) | (render[2] & change[2]) |
                        (render[3] & change[3]) | (render[4] & change[4]) | (render[5] & change[5]) |
                        (render[6] & change[6]) | (render[7] & change[7]) | (render[8] & change[8]));
    assign mode = 2'b00;
    assign lx = 10'b0000000000;
    assign ly = 10'b0000000000;
    assign turn = 2'b00;


endmodule
//space sizes?
//640x480 screen, so maybe 128x128 squares? gonna make it modular anyways, but that's my plan
/*
ok so for squares, if we are doing 128x128: 32px vertical border 16px between squares -> 112px horizontal border

sq1 = 112,32,240,160
sq2 = 256,32,384,160
sq3 = 400,32,528,160

sq1 = 112,176,240,304
sq2 = 256,176,384,304
sq3 = 400,176,528,304

sq1 = 112,320,240,448
sq2 = 256,320,384,448
sq3 = 400,320,528,448
*/