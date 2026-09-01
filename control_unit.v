module control_unit (
    input  wire [6:0] opcode,

    output reg       reg_write,
    output reg       mem_write,
    output reg       mem_read,
    output reg       alu_src,
    output reg       mem_to_reg,
    output reg       branch,
    output reg [1:0] alu_op
);

always @(*) begin

    // Default values
    reg_write = 1'b0;
    mem_write = 1'b0;
    mem_read  = 1'b0;
    alu_src   = 1'b0;
    mem_to_reg = 1'b0;
    branch    = 1'b0;
    alu_op    = 2'b00;

    case (opcode)

        // R-type instructions
        7'b0110011: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            alu_op    = 2'b10;
        end

        // I-type ALU instructions (ADDI, ANDI, ORI, XORI, SLTI)
        7'b0010011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b10;
        end

        // Load (LW)
        7'b0000011: begin
            reg_write  = 1'b1;
            mem_read   = 1'b1;
            alu_src    = 1'b1;
            mem_to_reg = 1'b1;
            alu_op     = 2'b00;
        end

        // Store (SW)
        7'b0100011: begin
            mem_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b00;
        end

        // Branch (BEQ)
        7'b1100011: begin
            branch  = 1'b1;
            alu_src = 1'b0;
            alu_op  = 2'b01;
        end

        default: begin
            // Keep default values
        end

    endcase
end

endmodule