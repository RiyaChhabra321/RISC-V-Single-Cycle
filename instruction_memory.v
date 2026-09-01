module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:255];
    integer i;

    assign instruction = memory[address[9:2]];

    initial begin
        // Default every location to NOP so the PC never reads X
        // if it runs past the last real instruction
        for (i = 0; i < 256; i = i + 1)
            memory[i] = 32'h00000013; // NOP (ADDI x0, x0, 0)

        // Actual program
        memory[0] = 32'h00500093; // ADDI x1, x0, 5
        memory[1] = 32'h00A00113; // ADDI x2, x0, 10
        memory[2] = 32'h002081B3; // ADD  x3, x1, x2
        memory[3] = 32'h00302023; // SW   x3, 0(x0)
        memory[4] = 32'h00002203; // LW   x4, 0(x0)
        memory[5] = 32'h00000013; // NOP
    end

endmodule