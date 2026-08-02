module control_unit(
    input [6:0] opcode,

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
    case(opcode)
        7'b0110011:
        begin
            branch = 0;
            mem_read = 0;
            mem_to_reg = 0;
            alu_op = 2'b10;
            mem_write = 0;
            alu_src = 0;
            reg_write = 1;
            jump = 0;
        end
    endcase
end

endmodule