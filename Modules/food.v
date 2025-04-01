`timescale 1ns / 1ps

module food(
    input clk,
    input reset,
    input food_eaten,           // Signal indicating food has been eaten
    output reg [9:0] food_x,    // X-coordinate of the food
    output reg [9:0] food_y     // Y-coordinate of the food
);

    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter SEGMENT_SIZE = 10;

    // 10-bit LFSRs for pseudo-random position generation
    reg [9:0] lfsr_x = 10'b1100101011;  // Initial seed for X LFSR
    reg [9:0] lfsr_y = 10'b1011011101;  // Initial seed for Y LFSR

    // LFSR update logic for pseudo-random number generation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize food position and LFSR seeds
            food_x <= 300;
            food_y <= 200;
            lfsr_x <= 10'b1100101011;
            lfsr_y <= 10'b1011011101;
        end else if (food_eaten) begin
            // Update LFSRs to generate new values
            lfsr_x <= {lfsr_x[8:0], lfsr_x[9] ^ lfsr_x[6]};
            lfsr_y <= {lfsr_y[8:0], lfsr_y[9] ^ lfsr_y[5]};

            // Use LFSR output to generate food position within screen bounds
            food_x <= (lfsr_x % (SCREEN_WIDTH / SEGMENT_SIZE)) * SEGMENT_SIZE;
            food_y <= (lfsr_y % (SCREEN_HEIGHT / SEGMENT_SIZE)) * SEGMENT_SIZE;
        end
    end

endmodule
