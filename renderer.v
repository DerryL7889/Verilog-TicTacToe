module renderer(input rst, input[9:0] x, input[9:0] y, input[9:0] lx, input[9:0] ly, input render, input mode, input highlight, input blanking, output[11:0] rgb);
//right now just black if on square, gray if on border, and black if on blanking interval

    reg[3:0] red, blue, green;

    always@(x,y) begin
        //display
        if(!blanking)begin
            if(render)begin
                red = 4'b0000;
                green = 4'b0000;
                blue = 4'b0000;

                //highlight
                if(highlight)begin
                    red = red +  4'b1111;
                    green = green + 4'b1111;
                    blue = blue + 4'b1111;
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