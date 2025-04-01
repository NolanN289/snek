`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 10:41:10 PM
// Design Name: 
// Module Name: Cathode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Cathode (
    input [7:0] digit,
    output reg seg_A,
    output reg seg_B,
    output reg seg_C,
    output reg seg_D,
    output reg seg_E,
    output reg seg_F,
    output reg seg_G
);

    reg [6:0] segments = 7'b0000000;
    
    always@ (digit) begin
        case(digit)
            8'b00000000 : segments <= 7'b1111110;//0
            8'b00000001 : segments <= 7'b0110000;//1
            8'b00000010 : segments <= 7'b1101101;//2
            8'b00000011 : segments <= 7'b1111001;//3
            8'b00000100 : segments <= 7'b0110011;//4       
            8'b00000101 : segments <= 7'b1011011;//5
            8'b00000110 : segments <= 7'b1011111;//6
            8'b00000111 : segments <= 7'b1110000;//7
            8'b00001000 : segments <= 7'b1111111;//8
            8'b00001001 : segments <= 7'b1111011;//9
       endcase
        
           seg_A = ~segments[6];
           seg_B = ~segments[5];
           seg_C = ~segments[4];
           seg_D = ~segments[3];
           seg_E = ~segments[2];
           seg_F = ~segments[1];
           seg_G = ~segments[0];
    end
endmodule
