`timescale 1ns / 1ps

module tb_food;

    // Declare signals for the DUT
    reg clk;
    reg reset;
    reg food_eaten;
    wire [9:0] food_x;
    wire [9:0] food_y;
    integer i = 0;

    // Instantiate the food module
    food uut (
        .clk(clk),
        .reset(reset),
        .food_eaten(food_eaten),
        .food_x(food_x),
        .food_y(food_y)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 100MHz clock (10ns period)
    end

    // Reset and stimulus generation
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        food_eaten = 0;

        // Apply reset at the beginning
        reset = 1; 
        #10;
        reset = 0;
        #10;

        // Apply the food_eaten signal to test the LFSR behavior
        food_eaten = 1; // Simulate food eaten event
        #10;
        food_eaten = 0; // Turn off the signal

        // Check after some cycles
        #20;
        $display("Food position: (%d, %d)", food_x, food_y);
        check_bounds(food_x, food_y);

        // Simulate more food eaten events
        for ( i = 0; i < 15; i = i + 1) begin
            #20;  // Wait 20 time units (2 clock cycles)
            food_eaten = 1;
            #10;
            food_eaten = 0;
            #10;

            // Check food position
            $display("Food position: (%d, %d)", food_x, food_y);
            check_bounds(food_x, food_y);
        end

        // End the simulation after testing
        $finish;
    end

    // Check bounds directly with display inside the for loop
    task check_bounds(input [9:0] x, input [9:0] y);
        begin
            // Check if food_x is within screen bounds and aligned with SEGMENT_SIZE
            if (x >= 640 || x % 10 != 0) begin
                $display("Error: food_x out of bounds: %d", x);
                $stop;
            end
            // Check if food_y is within screen bounds and aligned with SEGMENT_SIZE
            if (y >= 480 || y % 10 != 0) begin
                $display("Error: food_y out of bounds: %d", y);
                $stop;
            end
        end
    endtask

endmodule