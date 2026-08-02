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
    output reg jump
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

    case (opcode)

        // R-Type
        7'b0110011: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            alu_op    = 2'b10;
        end

        // I-Type (ADDI)
        7'b0010011: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 2'b10;
        end

        // Load (LW)
        7'b0000011: begin
            reg_write  = 1'b1;
            mem_read   = 1'b1;
            mem_to_reg = 1'b1;
            alu_src    = 1'b1;
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
            branch = 1'b1;
            alu_op = 2'b01;
        end

        // LUI
        7'b0110111: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
        end

        // JAL
        7'b1101111: begin
            reg_write = 1'b1;
            jump      = 1'b1;
        end

        default: begin
            // Default assignments already cover invalid opcode
        end

    endcase

end

endmodule