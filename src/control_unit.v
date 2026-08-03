`timescale 1ns/1ps

module control_unit(
    input  [6:0] opcode,

    output reg branch,
    output reg mem_read,
    output reg mem_to_reg,
    output reg [1:0] alu_op,
    output reg mem_write,
    output reg alu_src,
    output reg reg_write,
    output reg jump,
    output reg jalr,
    output reg lui,
    output reg auipc
);

always @(*) begin

    // Default values
    branch     = 1'b0;
    mem_read   = 1'b0;
    mem_to_reg = 1'b0;
    alu_op     = 2'b00;
    mem_write  = 1'b0;
    alu_src    = 1'b0;
    reg_write  = 1'b0;
    jump       = 1'b0;
    jalr       = 1'b0;
    lui        = 1'b0;
    auipc      = 1'b0;

    case (opcode)

        // R-Type (ADD/SUB/SLL/SLT/SLTU/XOR/SRL/SRA/OR/AND)
        7'b0110011: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            alu_op    = 2'b10;
        end

        // I-Type ALU (ADDI/SLTI/SLTIU/XORI/ORI/ANDI/SLLI/SRLI/SRAI)
        7'b0010011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b11;   // distinct from R-Type's 2'b10:
                                  // instruction[31:25] is part of the
                                  // immediate here, NOT a real funct7,
                                  // so it must never be used to pick SUB
        end

        // Load (LB/LH/LW/LBU/LHU) - byte/half/word selected by funct3
        // directly inside data_memory
        7'b0000011: begin
            reg_write  = 1'b1;
            mem_read   = 1'b1;
            mem_to_reg = 1'b1;
            alu_src    = 1'b1;
            alu_op     = 2'b00;
        end

        // Store (SB/SH/SW) - byte/half/word selected by funct3
        // directly inside data_memory
        7'b0100011: begin
            mem_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b00;
        end

        // Branch (BEQ/BNE/BLT/BGE/BLTU/BGEU) - exact comparison and
        // take/not-take polarity resolved from funct3 in alu_control
        // and single_cycle_cpu
        7'b1100011: begin
            branch = 1'b1;
            alu_op = 2'b01;
        end

        // LUI
        7'b0110111: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            lui       = 1'b1;
        end

        // AUIPC
        7'b0010111: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            auipc     = 1'b1;
        end

        // JAL
        7'b1101111: begin
            reg_write = 1'b1;
            jump      = 1'b1;
        end

        // JALR
        7'b1100111: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b00;  // ALU computes rs1 + imm as the target
            jump      = 1'b1;
            jalr      = 1'b1;
        end

        default: begin
            // Default assignments already cover invalid opcode
        end

    endcase

end

endmodule