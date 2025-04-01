`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 10:41:24 PM
// Design Name: 
// Module Name: BCD
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


module BCD(
    input [7:0] ins,
    input [2:0] counter,
    
    output reg [7:0] oneDigit
);
        
    wire [7:0] a;
 
    assign a = ins % 8'b00001010;
    
    always@(counter) begin
        case(counter)
            //First digit
            3'd0:   
                begin
                    oneDigit = ins % 10; 
                end
            //Second digit
            3'd1:    
                begin
                    if(ins > 4'b1001)
                    begin
                        oneDigit = ins % 10;
                    end
                    else
                    begin
                        oneDigit = 8'b11111111;
                    end
                end
        endcase
    end
endmodule