module score_display(
    input [7:0] score,        // Score input (0 to 255)
    output reg [7:0] ones,    // 7-segment display for ones digit
    output reg [7:0] tenths   // 7-segment display for tens digit
);

    // Convert score to individual digits (ones and tens)
    reg [3:0] digit0, digit1;

    always @(*) begin
        digit0 = score % 10;               // Least significant digit (ones place)
        digit1 = (score / 10) % 10;        // Second digit (tens place)

        // 7-segment encoding (active low, so 0 means LED on)
        case(digit0)
            4'b0000 : ones = 8'b11000000; // 0
            4'b0001 : ones = 8'b11111001; // 1
            4'b0010 : ones = 8'b10100100; // 2
            4'b0011 : ones = 8'b10110000; // 3
            4'b0100 : ones = 8'b10011001; // 4
            4'b0101 : ones = 8'b10010010; // 5
            4'b0110 : ones = 8'b10000010; // 6
            4'b0111 : ones = 8'b11111000; // 7
            4'b1000 : ones = 8'b10000000; // 8
            4'b1001 : ones = 8'b10010000; // 9
            default : ones = 8'b00000000; // Default case
        endcase
        
        case(digit1)
            4'b0000 : tenths = 8'b11000000; // 0
            4'b0001 : tenths = 8'b11111001; // 1
            4'b0010 : tenths = 8'b10100100; // 2
            4'b0011 : tenths = 8'b10110000; // 3
            4'b0100 : tenths = 8'b10011001; // 4
            4'b0101 : tenths = 8'b10010010; // 5
            4'b0110 : tenths = 8'b10000010; // 6
            4'b0111 : tenths = 8'b11111000; // 7
            4'b1000 : tenths = 8'b10000000; // 8
            4'b1001 : tenths = 8'b10010000; // 9
            default : tenths = 8'b00000000; // Default case
        endcase
    end
endmodule
