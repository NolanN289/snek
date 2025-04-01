`timescale 1ns / 1ps

module snake_game(
    input clk_100MHz,
    input reset,
    input video_on,
    input [1:0] snake_direction,
    input game_tick,
    input [9:0] x, y,
    output reg [11:0] rgb,
    output reg [7:0] score      // The score that will be passed to the top module
);

    parameter SNAKE_COLOR = 12'h0F0;
    parameter FOOD_COLOR = 12'hF00;   // Red color for food
    parameter BACKGROUND = 12'hFFF;
    parameter BORDER_COLOR = 12'h000;

    parameter SNAKE_START_X = 320;
    parameter SNAKE_START_Y = 240;
    parameter INITIAL_SNAKE_LENGTH = 3;
    parameter SEGMENT_SIZE = 10;
    parameter SCREEN_WIDTH = 640;
    parameter SCREEN_HEIGHT = 480;
    parameter MAX_SNAKE_LENGTH = 12;

    reg [9:0] snake_x[0:MAX_SNAKE_LENGTH-1];
    reg [9:0] snake_y[0:MAX_SNAKE_LENGTH-1];

    reg game_over;
    reg [1:0] current_direction;
    reg [4:0] snake_length; // 4-bit to handle lengths up to 10

    wire [9:0] food_x, food_y;
    reg food_eaten;

    // Instantiate the food module
    food food_inst(
        .clk(clk_100MHz),
        .reset(reset),
        .food_eaten(food_eaten),
        .food_x(food_x),
        .food_y(food_y)
    );

    integer i;

    // Initialize snake and score
    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            // Reset game state
            game_over <= 0;
            snake_length <= INITIAL_SNAKE_LENGTH;
            food_eaten <= 0;
            score <= 0;

            for (i = 0; i < INITIAL_SNAKE_LENGTH; i = i + 1) begin
                snake_x[i] <= SNAKE_START_X - (i * SEGMENT_SIZE);
                snake_y[i] <= SNAKE_START_Y;
            end
            current_direction <= 2'b00; // Right
        end else if (game_tick && ~game_over && snake_length < MAX_SNAKE_LENGTH) begin
            // Update direction if no collision
            if (snake_direction == 2'b00 && current_direction != 2'b10) begin
                current_direction <= snake_direction;
            end else if (snake_direction == 2'b01 && current_direction != 2'b11) begin
                current_direction <= snake_direction;
            end else if (snake_direction == 2'b10 && current_direction != 2'b00) begin
                current_direction <= snake_direction;
            end else if (snake_direction == 2'b11 && current_direction != 2'b01) begin
                current_direction <= snake_direction;
            end

            // Shift all body segments
            for (i = 1; i < snake_length; i = i + 1) begin
                snake_x[i] <= snake_x[i-1];
                snake_y[i] <= snake_y[i-1];
            end

            // Update head position based on the current direction
            case (current_direction)
                2'b00: snake_x[0] <= snake_x[0] + SEGMENT_SIZE;  // Right
                2'b01: snake_y[0] <= snake_y[0] - SEGMENT_SIZE;  // Up
                2'b10: snake_x[0] <= snake_x[0] - SEGMENT_SIZE;  // Left
                2'b11: snake_y[0] <= snake_y[0] + SEGMENT_SIZE;  // Down
            endcase

            // Check for food collision
            food_eaten <= (snake_x[0] == food_x && snake_y[0] == food_y);
            if (food_eaten && snake_length < MAX_SNAKE_LENGTH) begin
                // Initialize new segment's position
                snake_x[snake_length] <= snake_x[snake_length - 1];
                snake_y[snake_length] <= snake_y[snake_length - 1];
                
                // Increment length after initializing the new segment
                snake_length <= snake_length + 1;
                score <= score + 1;
            end

            // Border collision detection (game over)
            if (snake_x[0] < SEGMENT_SIZE || 
                snake_x[0] + SEGMENT_SIZE > SCREEN_WIDTH - SEGMENT_SIZE || 
                snake_y[0] < SEGMENT_SIZE || 
                snake_y[0] + SEGMENT_SIZE > SCREEN_HEIGHT - SEGMENT_SIZE) begin
                game_over <= 1;
            end

            // Self-collision detection (game over)
            for (i = 1; i < snake_length; i = i + 1) begin
                if (snake_x[0] == snake_x[i] && snake_y[0] == snake_y[i]) begin
                    game_over <= 1;
                end
            end
        end
    end

    // RGB Output Logic
    always @* begin
        if (~video_on) begin
            rgb = 12'h000;
        end else begin
            rgb = BACKGROUND;

            // Display snake
            for (i = 0; i < snake_length; i = i + 1) begin
                if ((x >= snake_x[i]) && (x < snake_x[i] + SEGMENT_SIZE) && (y >= snake_y[i]) && (y < snake_y[i] + SEGMENT_SIZE)) begin
                    rgb = SNAKE_COLOR;
                end
            end

            // Display food
            if ((x >= food_x) && (x < food_x + SEGMENT_SIZE) && (y >= food_y) && (y < food_y + SEGMENT_SIZE)) begin
                rgb = FOOD_COLOR;
            end

            // Display border
            if (x == 0 || x == SCREEN_WIDTH - 1 || y == 0 || y == SCREEN_HEIGHT - 1) begin
                rgb = BORDER_COLOR;
            end
        end
    end

endmodule