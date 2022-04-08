module sprite_rom #(parameter FILE="./sprites/test_sprite.mem") (
    input [9:0] x, input[9:0] y, output [7:0] data);
//combinatorial ROM for square sprites

    localparam sq_size = 16;

    reg [3:0] memory [0:255];

    initial begin
        if (FILE != 0) begin
            $readmemh(FILE, memory);
        end
    end

    assign data = memory[x + (sq_size * y)];

endmodule

// module memtranspose();
//     integer i;
//     reg [7:0] memory [0:63]; // 8 bit memory with 16 entries

//     initial begin
//         $readmemh("./sprites/test_spritet", memory);
//         $writememh("./sprites/sprite_x.mem", memory);
//     end
// endmodule