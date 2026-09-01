module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7_bit5,
    output reg  [3:0] alu_control
);

always @(*) begin
    case (alu_op)

        // Load / Store / ADDI
        2'b00: alu_control = 4'b0000; // ADD

        // Branch
        2'b01: alu_control = 4'b0001; // SUB

        // R-type / I-type ALU instructions
        2'b10: begin
            case (funct3)
                3'b000: begin
                    if (funct7_bit5)
                        alu_control = 4'b0001; // SUB
                    else
                        alu_control = 4'b0000; // ADD
                end

                3'b111: alu_control = 4'b0010; // AND
                3'b110: alu_control = 4'b0011; // OR
                3'b100: alu_control = 4'b0100; // XOR
                3'b010: alu_control = 4'b0101; // SLT
                3'b001: alu_control = 4'b0110; // SLL
                3'b101: begin
                    if (funct7_bit5)
                        alu_control = 4'b1000; // SRA
                    else
                        alu_control = 4'b0111; // SRL
                end

                default: alu_control = 4'b0000;
            endcase
        end

        default: alu_control = 4'b0000;

    endcase
end

endmodule