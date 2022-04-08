module game(input clk, input rst, input button, input[8:0] switches, input[9:0] x, input[9:0]y, 
    output[9:0] lx, output[9:0] ly, output[1:0] mode, output square, output highlight, output[1:0] turn, output[1:0] game_state);

    reg sig, valid;
	reg [1:0] state, playing, flag, curr_mode;
	reg [3:0] moves;
    reg [8:0] select, change;
    reg [9:0] curr_lx, curr_ly;
	wire clock;
    wire[8:0] render;
    wire[9:0] lx_arr[8:0];
    wire[9:0] ly_arr[8:0];
    wire[17:0] modes;
    integer i;
	 
	 //enforce only one switch active at any time
    always @(switches) begin
        flag = 2'b00;
        for(i=0; i<9; i=i+1) begin
            if (switches[i]) begin
                if(~flag[0]) begin
                    flag[0] = 1'b1;
                end
                else begin
                    flag[1] = 1'b1;
                end
            end
        end
        if(~flag[1]) begin
            select = switches;
        end
        else begin
            select = 9'b000000000;
        end
    end

    always@(x,y) begin
    curr_mode = 2'b00;
        for(i=0; i<9; i=i+1) begin
            if(render[i])begin
                curr_mode = {modes[2*i + 1],modes[2*i]};
                curr_lx <= lx_arr[i];
                curr_ly <= ly_arr[i];
            end
        end
    end
	 
    always@(posedge clock, negedge rst) begin
        if(~rst)begin
            //reset
				playing <= 2'b00; //0 = playing, 1 = current player wins, 2 = tie
				moves <= 4'b000;
            sig <= 1'b0;
            state <= 2'b01; //player 1 is x
            valid <= 1'b1;
            change <= 9'b000000000;
        end 
        else if(~button & ~sig & game_state == 2'b00) begin
            //button
            sig <= 1'b1;
            if(|select) begin
            //check if valid move
                valid = 1'b0;
                for(i=0; i<9; i=i+1) begin
                    if(select[i] & ({modes[2*i + 1],modes[2*i]} === 2'b00)) begin
                        valid = 1'b1;
                    end
                end
                
                if(valid) begin
                //place marker
                        change <= select;
								moves <= moves + 1;
                    end
            end
        end
        else if(button & sig) begin
            sig <= 1'b0;
            change <= 9'b000000000;
            if(valid) begin
                    //check for win
                    if(//horizontal
                        (modes[1:0] == state & modes[3:2] == state & modes[5:4] == state) |
                        (modes[7:6] == state & modes[9:8] == state & modes[11:10] == state) |
                        (modes[13:12] == state & modes[15:14] == state & modes[17:16] == state) |
                    //vertical
                        (modes[1:0] == state & modes[7:6] == state & modes[13:12] == state) |
                        (modes[3:2] == state & modes[9:8] == state & modes[15:14] == state) |
                        (modes[5:4] == state & modes[11:10] == state & modes[17:16] == state) |
                    //diagonal
                        (modes[1:0] == state & modes[9:8] == state & modes[17:16] == state) |
                        (modes[5:4] == state & modes[9:8] == state & modes[13:12] == state)
                    )begin
                        playing <= 2'b01;
                    end
						  //check for tie
						  else if(moves >= 4'b1001) begin
                        playing <= 2'b10;
                    end
                    //pass turn
                    else if(state == 2'b01) begin
                        state <= 2'b10;
                    end
                    else if(state == 2'b10) begin
                        state <= 2'b01;
                    end
                    valid <= 1'b0;
            end
        end
    end
	
	msclock cl1(clk, clock);
	
    space sq1(112,32,240,160, rst, change[0], x, y, state, lx_arr[0], ly_arr[0], render[0], modes[1:0]);
    space sq2(256,32,384,160, rst, change[1], x, y, state, lx_arr[1], ly_arr[1], render[1], modes[3:2]);
    space sq3(400,32,528,160, rst, change[2], x, y, state, lx_arr[2], ly_arr[2], render[2], modes[5:4]);

    space sq4(112,176,240,304, rst, change[3], x, y, state, lx_arr[3], ly_arr[3], render[3], modes[7:6]);
    space sq5(256,176,384,304, rst, change[4], x, y, state, lx_arr[4], ly_arr[4], render[4], modes[9:8]);
    space sq6(400,176,528,304, rst, change[5], x, y, state, lx_arr[5], ly_arr[5], render[5], modes[11:10]);

    space sq7(112,320,240,448, rst, change[6], x, y, state, lx_arr[6], ly_arr[6], render[6], modes[13:12]);
    space sq8(256,320,384,448, rst, change[7], x, y, state, lx_arr[7], ly_arr[7], render[7], modes[15:14]);
    space sq9(400,320,528,448, rst, change[8], x, y, state, lx_arr[8], ly_arr[8], render[8], modes[17:16]);


    assign square = | render; 
    assign highlight = ((render[0] & select[0]) | (render[1] & select[1]) | (render[2] & select[2]) |
                        (render[3] & select[3]) | (render[4] & select[4]) | (render[5] & select[5]) |
                        (render[6] & select[6]) | (render[7] & select[7]) | (render[8] & select[8]));
    assign mode = curr_mode;
    assign lx = curr_lx;
    assign ly = curr_ly;
    assign turn = state;
	 assign game_state = playing;


endmodule

module msclock(input cin, output reg cout);
	reg[31:0] count; 
	parameter D = 32'd25000;

	always @(posedge cin)
	begin
		count <= count + 32'd1;
			if (count >= (D-1))
			begin
				cout <= ~cout;
				count <= 32'd0;
			end
	end

endmodule
//space sizes
//640x480 screen, so maybe 128x128 squares?
/*
if we are doing 128x128: 32px vertical border 16px between squares -> 112px horizontal border

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