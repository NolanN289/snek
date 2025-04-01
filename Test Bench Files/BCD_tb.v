`timescale 1ns / 1ps

module BCD_tb;

    // Declare signals for the DUT
    reg [7:0] ins;           // Input for the DUT
    reg [2:0] counter;       // Counter input
    wire [7:0] oneDigit;     // Output of the DUT
    
    // Instantiate the BCD module
    BCD uut (
        .ins(ins),
        .counter(counter),
        .oneDigit(oneDigit)
    );

    // Procedure to check the expected behavior
    task check_output;
        input [7:0] ins;
        input [2:0] counter;
        input [7:0] expected_output;
        begin
            // Wait for a stable output
            #10;
            // Check if the output matches the expected output
            if (oneDigit !== expected_output) begin
                $display("ERROR: For ins = %d, counter = %d, expected oneDigit = %d but got %d", 
                          ins, counter, expected_output, oneDigit);
            end else begin
                $display("PASS: For ins = %d, counter = %d, got expected oneDigit = %d", 
                          ins, counter, oneDigit);
            end
        end
    endtask

    // Initial block to apply test cases
    initial begin
        // Test all values of ins (from 0 to 255)
        for (ins = 0; ins <= 255; ins = ins + 1) begin
            // Test counter = 0 (First digit)
            counter = 3'd0;
            // Expected output: ins % 10 (least significant digit)
            check_output(ins, counter, ins % 10);

            // Test counter = 1 (Second digit)
            counter = 3'd1;
            if (ins > 9) begin
                // Expected output: ins % 10 (second digit)
                check_output(ins, counter, ins % 10);
            end else begin
                // Expected output: 8'b11111111 if ins <= 9
                check_output(ins, counter, 8'b11111111);
            end
        end

        // End the simulation
        $finish;
    end

endmodule
