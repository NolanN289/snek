`timescale 1ns / 1ps

module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC on Basys 3 (reset)
    input btnU,             // btnU for moving up
    input btnD,             // btnD for moving down
    input btnL,             // btnL for moving left
    input btnR,             // btnR for moving right
    output hsync,           // to VGA connector
    output vsync,           // to VGA connector
    output [11:0] rgb,      // to DAC, 3 RGB bits to VGA connector
    output [7:0] anode,      // 7-segment anode
    output wire seg_A,
    output wire seg_B,
    output wire seg_C,
    output wire seg_D,
    output wire seg_E,
    output wire seg_F,
    output wire seg_G
);

    // VGA Controller wires
    wire w_video_on, w_p_tick;
    wire [9:0] w_x, w_y;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;

    // Snake Direction wire
    reg [1:0] snake_direction;

    // Game Tick wire
    wire game_tick;

    // Score wires
    wire add_signal;
    wire [7:0] score;

    // Clock divider for generating game tick
    clock_divider cd(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .game_tick(game_tick)
    );

    // VGA Controller instantiation
    vga_controller vc(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .video_on(w_video_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(w_p_tick),
        .x(w_x),
        .y(w_y)
    );

    // Directional control logic based on button inputs
    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            snake_direction <= 2'b00;  // Default direction: right
        end else begin
            // Set direction based on button inputs
            if (btnU && snake_direction != 2'b11)
                snake_direction <= 2'b01;  // Up
            else if (btnD && snake_direction != 2'b01)
                snake_direction <= 2'b11;  // Down
            else if (btnL && snake_direction != 2'b00)
                snake_direction <= 2'b10;  // Left
            else if (btnR && snake_direction != 2'b10)
                snake_direction <= 2'b00;  // Right
        end
    end

    // Snake game instantiation
    snake_game sg (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .video_on(w_video_on),
        .snake_direction(snake_direction), // Connect direction signal
        .x(w_x),
        .y(w_y),
        .rgb(rgb_next),
        .game_tick(game_tick),
        .score(score)
    );

    // RGB buffering and rendering
    always @(posedge clk_100MHz) begin
        if (w_p_tick) begin
            rgb_reg <= rgb_next;
        end
    end

    assign rgb = rgb_reg;

    scoreCountTop gs(
        .clk(clk_100MHz), 
        .ins(score), 
        .anode(anode), 
        .seg_A(seg_A), 
        .seg_B(seg_B), 
        .seg_C(seg_C), 
        .seg_D(seg_D), 
        .seg_E(seg_E), 
        .seg_F(seg_F), 
        .seg_G(seg_G)
    );

endmodule