`timescale 1ns/1ps
module alu_control(

    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg [3:0] alu_control

);

always @(*) begin

    case (alu_op)

        // Load / Store / JALR target (rs1 + imm)
        2'b00:
            alu_control = 4'b0000;   // ADD

        // Branch: pick the comparison the ALU must perform;
        // the actual take/not-take decision (with inversion for
        // BNE/BGE/BGEU) is done in single_cycle_cpu using funct3.
        2'b01:
        begin
            case (funct3)
                3'b000, 3'b001: alu_control = 4'b0001; // BEQ/BNE  -> SUB, use zero
                3'b100, 3'b101: alu_control = 4'b0101; // BLT/BGE  -> SLT (signed)
                3'b110, 3'b111: alu_control = 4'b0110; // BLTU/BGEU-> SLTU (unsigned)
                default:        alu_control = 4'b0001;
            endcase
        end

        // R-Type
        2'b10:
        begin

            case (funct3)

                // ADD / SUB
                3'b000:
                begin
                    if (funct7 == 7'b0100000)
                        alu_control = 4'b0001;   // SUB
                    else
                        alu_control = 4'b0000;   // ADD
                end

                // SLL
                3'b001:
                    alu_control = 4'b0111;

                // SLT
                3'b010:
                    alu_control = 4'b0101;

                // SLTU
                3'b011:
                    alu_control = 4'b0110;

                // XOR
                3'b100:
                    alu_control = 4'b0100;

                // SRL / SRA
                3'b101:
                begin
                    if (funct7 == 7'b0100000)
                        alu_control = 4'b1001;   // SRA
                    else
                        alu_control = 4'b1000;   // SRL
                end

                // OR
                3'b110:
                    alu_control = 4'b0011;

                // AND
                3'b111:
                    alu_control = 4'b0010;

                default:
                    alu_control = 4'b0000;

            endcase

        end

        2'b11:
        begin

            case (funct3)

                // ADDI
                3'b000:
                    alu_control = 4'b0000;   // ADD

                // SLLI  (imm[11:5] is architecturally fixed to 0000000)
                3'b001:
                    alu_control = 4'b0111;

                // SLTI
                3'b010:
                    alu_control = 4'b0101;

                // SLTIU
                3'b011:
                    alu_control = 4'b0110;

                // XORI
                3'b100:
                    alu_control = 4'b0100;

                // SRLI / SRAI (bit 30 legitimately selects arithmetic vs logical)
                3'b101:
                begin
                    if (funct7 == 7'b0100000)
                        alu_control = 4'b1001;   // SRAI
                    else
                        alu_control = 4'b1000;   // SRLI
                end

                // ORI
                3'b110:
                    alu_control = 4'b0011;

                // ANDI
                3'b111:
                    alu_control = 4'b0010;

                default:
                    alu_control = 4'b0000;

            endcase

        end

        default:
            alu_control = 4'b0000;

    endcase

end

endmodule