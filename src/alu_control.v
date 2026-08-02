module alu_control(

    input [1:0] alu_op,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg [3:0] alu_control

);

always @(*) begin

    case (alu_op)

        // Load / Store
        2'b00:
            alu_control = 4'b0000;   // ADD

        // Branch
        2'b01:
            alu_control = 4'b0001;   // SUB

        // R-Type / I-Type
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

                // AND
                3'b111:
                    alu_control = 4'b0010;

                // OR
                3'b110:
                    alu_control = 4'b0011;

                // XOR
                3'b100:
                    alu_control = 4'b0100;

                // SLT
                3'b010:
                    alu_control = 4'b0101;

                default:
                    alu_control = 4'b0000;

            endcase

        end

        default:
            alu_control = 4'b0000;

    endcase

end

endmodule