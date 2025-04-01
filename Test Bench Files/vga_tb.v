`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2024
// Design Name: 
// Module Name: vga_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// A testbench for the VGA controller module to verify its functionality.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module vga_tb();

    // Parameters
    parameter CLK_PERIOD = 10; // Adjust for 100MHz clock

    // Signals
    reg clk;
    reg reset;
    wire hsync, vsync;
    wire [9:0] pixel_x, pixel_y;
    wire video_on;
    wire p_tick;

    // Instantiate the VGA Controller Module
    vga_controller uut (
        .clk_100MHz(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .x(pixel_x),
        .y(pixel_y),
        .p_tick(p_tick)
    );

    // Clock generation
   always begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk; // Toggle clock
    end

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        #100; // Hold reset for a short time
        reset = 0;

        
        // Run the simulation for a sufficient time to observe behavior
        #20_000_000 $finish; // Wait for enough time to observe multiple frames
        // Finish simulation
        
    end 

endmodule
