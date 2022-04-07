module game(input clk, input rst, input button, input[8:0] switches, input[9:0] x, input[9:0]y, 
    output[9:0] lx, output[9:0] ly, output[1:0] mode, output square, output highlight, output[1:0] turn);

    reg sig;
	 reg [1:0] state, flag, curr_mode;
    reg [8:0] select, change;
    wire[8:0] render;
    wire[9:0] lx1, lx2, lx3, lx4, lx5, lx6, lx7, lx8, lx9;
    wire[9:0] ly1, ly2, ly3, ly4, ly5, ly6, ly7, ly8, ly9;
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

	always@(render) begin
	curr_mode = 2'b00;
		for(i=0; i<9; i=i+1) begin
			if(render[i])begin
				curr_mode = modes[2*(i)+1 -:2];
			end
		end
	end
   always@(negedge rst, negedge button)begin
		  
       if(~rst)begin
           //reset
           state <= 2'b01; //player 1 is x
       end 
		  else if(~button) begin
           //button
           if(|select) begin
				//TODO: check if valid move
               //place marker
           //TODO:check for win
               //pass turn
               if(state == 2'b01) begin
                   state <= 2'b10;
               end
               else if(state == 2'b10) begin
                   state <= 2'b01;
               end
           end
       end
   end
	 
	//  always@(posedge clk, negedge rst, negedge button) begin
	// 	  sig <= ~button;
	// 	  if(~rst)begin
    //         //reset
    //         state <= 2'b01; //player 1 is x
	// 			change <= 9'b000000000;
    //     end 
	// 	  else if(~button) begin
    //         //button
    //         if(|select) begin
	// 			//TODO: check if valid move
    //             //place marker
	// 				 if(~sig) begin
	// 					  change <= select;
	// 				 end
	// 			  	 else begin
	// 			   	  change <= 9'b000000000;
	// 				 end
    //         //TODO:check for win
    //             //pass turn
    //             if(state == 2'b01) begin
    //                 state <= 2'b10;
    //             end
    //             else if(state == 2'b10) begin
    //                 state <= 2'b01;
    //             end
    //         end
    //     end
	//  end

    space sq1(112,32,240,160, rst, change[0], x, y, state, lx1, ly1, render[0], modes[1:0]);
    space sq2(256,32,384,160, rst, change[1], x, y, state, lx2, ly2, render[1], modes[3:2]);
    space sq3(400,32,528,160, rst, change[2], x, y, state, lx3, ly3, render[2], modes[5:4]);

    space sq4(112,176,240,304, rst, change[3], x, y, state, lx4, ly4, render[3], modes[7:6]);
    space sq5(256,176,384,304, rst, change[4], x, y, state, lx5, ly5, render[4], modes[9:8]);
    space sq6(400,176,528,304, rst, change[5], x, y, state, lx6, ly6, render[5], modes[11:10]);

    space sq7(112,320,240,448, rst, change[6], x, y, state, lx7, ly7, render[6], modes[13:12]);
    space sq8(256,320,384,448, rst, change[7], x, y, state, lx8, ly8, render[7], modes[15:14]);
    space sq9(400,320,528,448, rst, change[8], x, y, state, lx9, ly9, render[8], modes[17:16]);


    assign square = | render; 
    assign highlight = ((render[0] & select[0]) | (render[1] & select[1]) | (render[2] & select[2]) |
                        (render[3] & select[3]) | (render[4] & select[4]) | (render[5] & select[5]) |
                        (render[6] & select[6]) | (render[7] & select[7]) | (render[8] & select[8]));
    assign mode = curr_mode;
    assign lx = 10'b0000000000;
    assign ly = 10'b0000000000;
    assign turn = state;


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