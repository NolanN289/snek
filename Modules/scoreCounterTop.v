module scoreCountTop(
    input clk,
    input [7:0] ins,
    output [7:0] anode,
    output wire seg_A,
    output wire seg_B,
    output wire seg_C,
    output wire seg_D,
    output wire seg_E,
    output wire seg_F,
    output wire seg_G
);
    wire [2:0] counter;
    wire [7:0] oneDigit;

    Anode (
        .counter(counter), 
        .anode(anode)
    );

    BCD ( 
        .ins(ins), 
        .counter(counter), 
        .oneDigit(oneDigit)
    );
    
    Cathode (
        .digit(oneDigit), 
        .seg_A(seg_A),
        .seg_B(seg_B),
        .seg_C(seg_C),
        .seg_D(seg_D),
        .seg_E(seg_E),
        .seg_F(seg_F),
        .seg_G(seg_G)
    );

endmodule