`timescale 1ns / 1ps

module single_cycle_tb;

    reg clk;
    reg reset;

    wire [31:0] pc_out;
    wire [31:0] alu_result_out;
    wire [31:0] write_back_data_out;

    // Instantiate processor
    riscv_top DUT (
        .clk                  (clk),
        .reset                (reset),
        .pc_out               (pc_out),
        .alu_result_out       (alu_result_out),
        .write_back_data_out  (write_back_data_out)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    initial begin

        // Initial values
        clk   = 1'b0;
        reset = 1'b1;

        // Hold reset
        #10;
        reset = 1'b0;

        // Run processor
        #70;

        $finish;
    end

    // Monitor important signals
    initial begin
        $monitor("Time=%0t | PC=%h | ALU=%d | WB=%d",
                 $time,
                 pc_out,
                 alu_result_out,
                 write_back_data_out);
    end

endmodule