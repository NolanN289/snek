`timescale 1ns / 1ps


module clock_divider(
    input clk_100MHz,    // 100 MHz input clock
    input reset,         // Reset signal
    output reg game_tick // Game tick output signal
);

    reg [25:0] counter; // 26-bit counter for 10 Hz signal (100 MHz / 10 Hz = 10 million cycles)

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            counter <= 0;
            game_tick <= 0;
        end else begin
            if (counter == 19999999) begin //9999999 for 10hz, 19999999 for 5 Hz
                counter <= 0;
                game_tick <= 1;
            end else begin
                counter <= counter + 1;
                game_tick <= 0;
            end
        end
    end

endmodule
