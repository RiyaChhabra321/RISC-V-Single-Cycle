module riscv_top (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] pc_out,
    output wire [31:0] alu_result_out,
    output wire [31:0] write_back_data_out
);

    // =========================================================
    // Program Counter
    // =========================================================
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;

    assign pc_plus4 = pc + 32'd4;

    // =========================================================
    // Instruction Memory
    // =========================================================
    wire [31:0] instruction;

    // Instruction fields
    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire       funct7_bit5;

    assign opcode      = instruction[6:0];
    assign rd          = instruction[11:7];
    assign funct3      = instruction[14:12];
    assign rs1         = instruction[19:15];
    assign rs2         = instruction[24:20];
    assign funct7_bit5 = instruction[30];

    // =========================================================
    // Control Unit
    // =========================================================
    wire       reg_write;
    wire       mem_write;
    wire       mem_read;
    wire       alu_src;
    wire       mem_to_reg;
    wire       branch;
    wire [1:0] alu_op;

    // =========================================================
    // Register File
    // =========================================================
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;

    // =========================================================
    // Immediate Generator
    // =========================================================
    wire [31:0] immediate;

    // =========================================================
    // ALU
    // =========================================================
    wire [31:0] alu_input_b;
    wire [31:0] alu_result;
    wire        zero;

    wire [3:0] alu_control_signal;

    assign alu_input_b = alu_src ? immediate : read_data2;

    // =========================================================
    // Data Memory
    // =========================================================
    wire [31:0] memory_read_data;

    // =========================================================
    // Branch Logic
    // =========================================================
    wire [31:0] branch_target;
    wire        branch_taken;

    assign branch_target = pc + immediate;
    assign branch_taken  = branch & zero;

    assign pc_next = branch_taken ? branch_target : pc_plus4;

    // =========================================================
    // Write Back
    // =========================================================
    assign write_back_data = mem_to_reg ?
                             memory_read_data :
                             alu_result;

    // =========================================================
    // Module Instantiations
    // =========================================================

    program_counter PC (
        .clk     (clk),
        .reset   (reset),
        .pc_next (pc_next),
        .pc      (pc)
    );

    instruction_memory IMEM (
        .address     (pc),
        .instruction (instruction)
    );

    control_unit CU (
        .opcode     (opcode),
        .reg_write  (reg_write),
        .mem_write  (mem_write),
        .mem_read   (mem_read),
        .alu_src    (alu_src),
        .mem_to_reg (mem_to_reg),
        .branch     (branch),
        .alu_op     (alu_op)
    );

    register_file RF (
        .clk        (clk),
        .reset      (reset),
        .reg_write  (reg_write),
        .rs1        (rs1),
        .rs2        (rs2),
        .rd         (rd),
        .write_data (write_back_data),
        .read_data1 (read_data1),
        .read_data2 (read_data2)
    );

    immediate_generator IG (
        .instruction (instruction),
        .immediate   (immediate)
    );

    alu_control AC (
        .alu_op       (alu_op),
        .funct3       (funct3),
        .funct7_bit5  (funct7_bit5),
        .alu_control  (alu_control_signal)
    );

    alu ALU (
        .a           (read_data1),
        .b           (alu_input_b),
        .alu_control (alu_control_signal),
        .result      (alu_result),
        .zero        (zero)
    );

    data_memory DMEM (
        .clk        (clk),
        .mem_write  (mem_write),
        .mem_read   (mem_read),
        .address    (alu_result),
        .write_data (read_data2),
        .read_data  (memory_read_data)
    );

    // =========================================================
    // Debug Outputs
    // =========================================================
    assign pc_out              = pc;
    assign alu_result_out      = alu_result;
    assign write_back_data_out = write_back_data;

endmodule