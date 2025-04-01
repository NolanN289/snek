`timescale 1ns / 1ps

module tb_clock_divider;

    // Inputs
    reg clk_100MHz;
    reg reset;

    // Outputs
    wire game_tick;

    // Instantiate the Unit Under Test (UUT)
    clock_divider uut (
        .clk_100MHz(clk_100MHz), 
        .reset(reset), 
        .game_tick(game_tick)
    );

    // Clock generation
    initial begin
        clk_100MHz = 0;
        forever #5 clk_100MHz = ~clk_100MHz; // 100 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        #10;
        reset = 0;

        // Wait for a longer time to observe the output
        #1000000000; // Wait for 1 second (enough time to see multiple game ticks)

        // Finish simulation
        $finish;
    end

    // Self-checking mechanism
    always @(posedge clk_100MHz) begin
        if (reset) begin
            // Check if the counter and game_tick are reset
            if (uut.counter !== 0 || game_tick !== 0) begin
                $display("Test failed: Reset did not work correctly at time %t", $time);
                $stop;
            end
        end else begin
            // Check if game_tick is asserted correctly
            if (uut.counter == 19999999 && game_tick !== 1) begin
                $display("Test failed: game_tick not asserted correctly at time %t", $time);
                $stop;
            end
            // Check if game_tick is deasserted correctly
            if (uut.counter != 19999999 && game_tick !== 0) begin
                $display("Test failed: game_tick not deasserted correctly at time %t", $time);
                $stop;
            end
        end
    end

    // Exhaustive checking for key transitions
    always @(posedge clk_100MHz) begin
        if (!reset) begin
            // Check transition from max counter value to 0
            if (uut.counter == 19999999) begin
                #10; // Wait for one clock cycle
                if (uut.counter !== 0) begin
                    $display("Test failed: Counter did not reset correctly at time %t", $time);
                    $stop;
                end
            end

            // Check transition from 0 to 1
            if (uut.counter == 0) begin
                #10; // Wait for one clock cycle
                if (uut.counter !== 1) begin
                    $display("Test failed: Counter did not increment correctly at time %t", $time);
                    $stop;
                end
            end
        end
    end

endmodule