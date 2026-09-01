module immediate_generator (
    input  wire [31:0] instruction,
    output reg  [31:0] immediate
);

always @(*) begin
    case (instruction[6:0])

        // I-type: LW, ADDI, ANDI, ORI, XORI, SLTI
        7'b0000011,
        7'b0010011: begin
            immediate = {{20{instruction[31]}}, instruction[31:20]};
        end

        // S-type: SW
        7'b0100011: begin
            immediate = {{20{instruction[31]}},
                         instruction[31:25],
                         instruction[11:7]};
        end

        // B-type: BEQ
        7'b1100011: begin
            immediate = {{19{instruction[31]}},
                         instruction[31],
                         instruction[7],
                         instruction[30:25],
                         instruction[11:8],
                         1'b0};
        end

        default: begin
            immediate = 32'b0;
        end

    endcase
end

endmodule