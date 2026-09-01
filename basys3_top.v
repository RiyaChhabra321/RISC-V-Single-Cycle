`timescale 1ns / 1ps

// Top-level wrapper for the Digilent Basys 3 board.
// Instantiates the existing riscv_top core unchanged and maps a
// trimmed-down view of its outputs onto the board's 16 LEDs,
// since Basys 3 does not have enough I/O to expose all 96 debug
// output bits directly.

module basys3_top (
    input  wire        clk,     // 100 MHz onboard oscillator (W5)
    input  wire        btnC,    // Center button used as reset (U18)
    output wire [15:0] led      // 16 onboard LEDs
);

    wire [31:0] pc_out;
    wire [31:0] alu_result_out;
    wire [31:0] write_back_data_out;

    riscv_top DUT (
        .clk                  (clk),
        .reset                (btnC),
        .pc_out               (pc_out),
        .alu_result_out       (alu_result_out),
        .write_back_data_out  (write_back_data_out)
    );

    // Show the lower 16 bits of the final write-back value on the LEDs.
    // For this test program, once execution reaches the LW instruction,
    // this should settle to x4 = 15 (LEDs showing binary 00000000 00001111).
    assign led = write_back_data_out[15:0];

endmodule