`timescale 1ns / 1ps

module tb_snake_game;

    // Declare signals for the DUT
    reg clk_100MHz;
    reg reset;
    reg video_on;
    reg [1:0] snake_direction;
    reg game_tick;
    reg [9:0] x, y;
    wire [11:0] rgb;

    // Instantiate the snake_game module
    snake_game uut (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .video_on(video_on),
        .snake_direction(snake_direction),
        .game_tick(game_tick),
        .x(x),
        .y(y),
        .rgb(rgb)
    );

    // Clock generation (100 MHz)
    always begin
        #5 clk_100MHz = ~clk_100MHz;  // 100 MHz clock (10ns period)
    end

    // Initialize signals
    initial begin
        clk_100MHz = 0;
        reset = 0;
        video_on = 1;
        snake_direction = 2'b00;  // Initial direction: Right
        game_tick = 0;
        x = 0;
        y = 0;

        // Apply reset at the beginning
        reset = 1; 
        #10;
        reset = 0;
        #10;

        // Start simulation and test with for loop
        // Simulate different game situations in a for loop
        for (integer i = 0; i < 5; i = i + 1) begin
            // Simulate snake movement in different directions
            case (i)
                0: begin
                    $display("Simulating Snake Moving Right...");
                    snake_direction = 2'b00;  // Move Right
                end
                1: begin
                    $display("Simulating Snake Moving Down...");
                    snake_direction = 2'b11;  // Move Down
                end
                2: begin
                    $display("Simulating Snake Moving Left...");
                    snake_direction = 2'b10;  // Move Left
                end
                3: begin
                    $display("Simulating Snake Moving Up...");
                    snake_direction = 2'b01;  // Move Up
                end
                4: begin
                    $display("Simulating Snake Collision with Boundary...");
                    snake_direction = 2'b00;  // Move Right to hit right border
                end
            endcase

            // Run game ticks for each direction
            for (integer j = 0; j < 20; j = j + 1) begin
                game_tick = 1; 
                #10;  // Wait for one clock cycle
                game_tick = 0; 
                #10;  // Wait for the next clock cycle

                // Check RGB output for snake and food rendering
                if (j % 5 == 0) begin // Check every 5 ticks for visualization
                    $display("Game Tick %d, Snake Head Position: (%d, %d), RGB: %h", j, uut.snake_x[0], uut.snake_y[0], rgb);
                end

                // Check food collision and snake length increase
                if (uut.snake_x[0] == uut.food_x && uut.snake_y[0] == uut.food_y) begin
                    $display("Food collision detected! Snake length increased.");
                end

                // Check boundary collision
                if (uut.snake_x[0] < 0 || uut.snake_x[0] >= 640 || uut.snake_y[0] < 0 || uut.snake_y[0] >= 480) begin
                    $display("Boundary collision detected! Snake hit the border at position (%d, %d).", uut.snake_x[0], uut.snake_y[0]);
                    $finish;
                end

                // Check self-collision
                for (integer k = 1; k < uut.snake_length; k = k + 1) begin
                    if (uut.snake_x[0] == uut.snake_x[k] && uut.snake_y[0] == uut.snake_y[k]) begin
                        $display("Self collision detected! Snake collided with itself at position (%d, %d).", uut.snake_x[0], uut.snake_y[0]);
                        $finish;
                    end
                end
            end
        end

        // End simulation after the loop finishes
        $finish;
    end

    // Check the RGB output for different coordinates (for visualization)
    always @* begin
        // Check if any part of the snake or food is within screen bounds
        if (x >= 0 && x < 640 && y >= 0 && y < 480) begin
            $display("x: %d, y: %d, rgb: %h", x, y, rgb);
        end
    end

endmodule