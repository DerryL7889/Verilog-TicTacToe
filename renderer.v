module renderer(input rst, input[9:0] x, input[9:0] y, input[9:0] lx, input[9:0] ly, input render, input[1:0] mode, input highlight, input blanking, output[11:0] rgb);

    reg[3:0] red, blue, green;
    wire[7:0] x_sprite, o_sprite;

    always@(x,y) begin
        //display
        if(!blanking)begin
            if(render)begin
                if(mode == 2'b01)begin
                    //x
						  if(x_sprite == 4'b0000) begin
                        red = 4'b0000;
							   green = 4'b0000;
                        blue = 4'b0000;
                    end
						  else begin
						      red = 4'b1111;
                        green = 4'b1111;
                        blue = 4'b1111;
                    end
                end
                else if(mode == 2'b10)begin
                    //o
						  if(o_sprite == 4'b0000) begin
                        red = 4'b0000;
							   green = 4'b0000;
                        blue = 4'b0000;
                    end
						  else begin
						      red = 4'b1111;
                        green = 4'b1111;
                        blue = 4'b1111;
                    end

                end
                else begin
                    red = 4'b0000;
                    green = 4'b0000;
                    blue = 4'b0000;
                end

                //highlight
                if(highlight)begin
                    red = ~red;
                    green = ~green;
                    blue = ~blue;
                end
            end
            else begin
                red = 4'b1000;
                green = 4'b1000;
                blue = 4'b1000;
            end

        end
        else begin
            red = 4'b0000;
            green = 4'b0000;
            blue = 4'b0000;
        end
    end

    sprite_rom #(.FILE("./sprites/sprite_x.mem")) sp1(lx/8 , ly/8, x_sprite);
	 sprite_rom #(.FILE("./sprites/test_sprite.mem")) sp2(lx/8 , ly/8, o_sprite);

    assign rgb = {red,green,blue};


endmodule