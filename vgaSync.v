module vgaSync(input clk, input rst, output[9:0] x, output[9:0] y, output blank, output hsync, output vsync);
 
    localparam h_dispinterval = 640;
    localparam h_fporch = 16;
    localparam h_spulse = 96;
    localparam h_bporch = 48;

    localparam v_dispinterval = 480;
    localparam v_fporch = 10;
    localparam v_spulse = 2;
    localparam v_bporch = 33;

	 reg h_sync, v_sync, b_intvl;
    //reg[9:0] xpx, ypx;
    reg[9:0] hcounter, vcounter;
    wire clk25;

    clkdiv25 cd0(clk, rst, clk25);

    always @(posedge clk25, negedge rst)
    begin
        if(~rst)
        begin
            h_sync <= 0;
            hcounter <= 0;
            v_sync <= 0;
            vcounter <= 0;
			b_intvl <= 0;
        end
		else
		  //horizontal/vertical counters
        begin
            if(hcounter >= 800)
            begin
                hcounter <= 0;
                vcounter <= vcounter + 10'd1;
            end
            else
				begin
                hcounter <= hcounter + 10'd1;
					 if(vcounter >= 525)
						 vcounter <= 0;
				end

			//sync pulse
			  if(hcounter >= 656 && hcounter < 752)
					h_sync = 0;
			  else
					h_sync = 1;

			  if(vcounter >= 490 && vcounter < 492)
					v_sync = 0;
			  else
					v_sync = 1;
					
			  
			//blanking interval
			  if((hcounter >= 640 && hcounter < 800) || (vcounter >= 480 && vcounter < 492))
					b_intvl = 1;
			  else
					b_intvl = 0;
		  end
    end
	 
	 assign hsync = h_sync;
	 assign vsync = v_sync;
	 assign blank = b_intvl;
	 assign x = hcounter;
	 assign y = vcounter;

endmodule

module clkdiv25(input cin, input rst, output reg cout);

//divides the 50mhz clock to 25mhz

    always @(posedge cin)
    begin
        if(~rst)
            cout <= 1;
        else
            cout <= ~cout;
    end

endmodule