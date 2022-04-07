module renderer(input rst, input[9:0] x, input[9:0] y, input[9:0] lx, input[9:0] ly, input render, input[1:0] mode, input highlight, input blanking, output[11:0] rgb);
//right now just black if on square, gray if on border, and black if on blanking interval

    reg[3:0] red, blue, green;

    always@(x,y) begin
        //display
        if(!blanking)begin
            if(render)begin
                if(mode == 2'b01)begin
                    //x
                    red = 4'b1111;
                    green = 4'b0000;
                    blue = 4'b0000;
                end
                else if(mode == 2'b10)begin
                    //o
                    red = 4'b0000;
                    green = 4'b0000;
                    blue = 4'b1111;
                end
					 else if(mode == 2'b00)begin
                    //o
                    red = 4'b0000;
                    green = 4'b0000;
                    blue = 4'b0000;
                end
					 else if(mode == 2'b11)begin
                    //o
                    red = 4'b0000;
                    green = 4'b1111;
                    blue = 4'b0000;
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

    assign rgb = {red,green,blue};


endmodule